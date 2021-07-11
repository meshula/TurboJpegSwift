# TurboJpegSwift

Swift wrapping of libturbojpeg

This is a minimal proof of concept. To use it, the libturbojpeg libs must be manually linked. There might be a way to tell the SwiftPM to do it, but I haven't found it. Also, because of the assembly components of libturbojpeg for Intel processors, it's probably not possible to get SPM to build libturbojpeg directly as an alternative to distributing binary libs. Ideally resolving the latter would resolve the former problem.

References:

- [https://blog.human-friendly.com/drawing-images-from-pixel-data-in-swift] Drawing Images from Pixel Data in Swift
- [https://www.reddit.com/r/SwiftUI/comments/ekt9yd/how_to_display_multiple_cgimagessecond_in_a/] How to display multiple CGImages/second in a SwiftUI view
- [https://github.com/kean/DFJPEGTurbo/blob/master/DFJPEGTurbo/DFJPEGTurboImageDecoder.m] ObjC turbojpeg bindings
- [https://developer.apple.com/documentation/swiftui/image/init(:scale:orientation:label:)] Image: Creates a labeled image based on a Core Graphics image instance, usable as content for controls
- -[https://medium.com/flawless-app-stories/avplayer-swiftui-part-2-player-controls-c28b721e7e27] SwiftUI player controls
