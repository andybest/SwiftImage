/*
 The MIT License (MIT)
 
 Copyright (c) 2017 Andy Best
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation

public struct PixelData {
    public var r: UInt8
    public var g: UInt8
    public var b: UInt8
    
    public init(r: UInt8, g: UInt8, b: UInt8) {
        self.r = r
        self.g = g
        self.b = b
    }
}

public enum ImageFormat {
    case bitmap
}

public enum BitDepth: Int {
    case rgb24 = 24
}

public struct ImageDescriptor {
    public let width: Int
    public let height: Int
    public let bitDepth: BitDepth
    public let pixels: [PixelData]
    
    public init(width: Int, height: Int, bitDepth: BitDepth, pixels: [PixelData]) {
        self.width = width
        self.height = height
        self.bitDepth = bitDepth
        self.pixels = pixels
    }
}

public struct ImageEncoder {
    public static func encodeImage(toPath path: String, withFormat format: ImageFormat, imageDescriptor: ImageDescriptor) throws {
        let imageData: Data
        
        switch format {
        case .bitmap:
            imageData = encodeBitmapImage(width: imageDescriptor.width,
                                          height: imageDescriptor.height,
                                          bitDepth: imageDescriptor.bitDepth,
                                          pixels: imageDescriptor.pixels)
        }
        
        try imageData.write(to: URL(fileURLWithPath: path))
    }
}
