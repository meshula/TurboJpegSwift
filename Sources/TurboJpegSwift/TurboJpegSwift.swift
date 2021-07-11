
import TurboJpegC
import SwiftUI

private let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
private let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue:
                                                   // CGImageAlphaInfo.premultipliedFirst.rawValue
                                                   CGImageByteOrderInfo.order32Big.rawValue)

public func imageFromBitmap(pixels:UnsafeMutablePointer<UInt8>, width:Int, height:Int)->CGImage? {
    let bitsPerComponent:Int = 8
    let bitsPerPixel:Int = 32
    
    let providerRef = CGDataProvider.init(data:
            NSData(bytes: pixels, length: Int(width * height * 4))
        )

    if providerRef == nil { 
        return nil
    }
    let cgim = CGImage.init(
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bitsPerPixel,
            bytesPerRow: width * 4,
            space: rgbColorSpace,
            bitmapInfo: bitmapInfo,
            provider: providerRef!,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
        )
    return cgim
}

func tjScaled(dimension: Int32, scale: tjscalingfactor) -> Int32 {
    return ((dimension * scale.num) + scale.denom - 1) / scale.denom
}

public
func imageWithData(data : Data?) -> CGImage? {
    if data == nil { return nil }
    if data!.count == 0 { return nil }
    var width : Int32 = 0
    var height : Int32 = 0
    var jpegSubsamp : Int32 = 0
    let decoder = tjInitDecompress()

    var mutableData = data
    var result = mutableData!.withUnsafeMutableBytes { bytes in
        tjDecompressHeader2(decoder, bytes.baseAddress!.assumingMemoryBound(to: UInt8.self),
                            UInt(data!.count), &width, &height, &jpegSubsamp)
    }

    if result < 0 {
        tjDestroy(decoder)
        return nil
    }

    var scale = tjscalingfactor()
    scale.num = 1
    scale.denom = 1

    width = tjScaled(dimension: width, scale: scale)
    height = tjScaled(dimension: height, scale: scale)
    let pitch : Int32 = 4
    let capacity = Int(pitch * width * height)
    let image_data = UnsafeMutablePointer<UInt8>.allocate(capacity: capacity)
    result = mutableData!.withUnsafeMutableBytes { bytes in
        tjDecompress2(decoder, bytes.baseAddress!.assumingMemoryBound(to: UInt8.self),
                      UInt(data!.count), image_data,
                      width, pitch * width, height, TJPF_RGBA.rawValue, 0);
    }

    if result < 0 {
        tjDestroy(decoder)
        return nil
    }

    let img = imageFromBitmap(pixels: image_data, width: Int(width), height: Int(height))

    tjDestroy(decoder)
    return img
}
