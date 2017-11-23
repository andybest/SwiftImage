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

struct BitmapFileHeader {
    static let HeaderSize = 14
    
    let typeIdentifier: UInt16  = 0x424D
    var size: UInt32
    let reserved1: UInt16 = 0
    let reserved2: UInt16 = 0
    var offset: UInt32
    
    var data: Data {
        get {
            let encoder = DataEncoder()
            
            encoder.append(typeIdentifier, endianness: .big)
            encoder.append(size, endianness: .little)
            encoder.append(reserved1, endianness: .little)
            encoder.append(reserved2, endianness: .little)
            encoder.append(offset, endianness: .little)
            
            return encoder.encodedData
        }
    }
}

struct BitmapDIBHeader {
    let headerSize: UInt32 = 12
    var bitmapWidth: UInt16
    var bitmapHeight: UInt16
    let numColorPlanes: UInt16 = 1
    var bitsPerPixel: UInt16
    
    var data: Data {
        get {
            let encoder = DataEncoder()
            
            encoder.append(headerSize, endianness: .little)
            encoder.append(bitmapWidth, endianness: .little)
            encoder.append(bitmapHeight, endianness: .little)
            encoder.append(numColorPlanes, endianness: .little)
            encoder.append(bitsPerPixel, endianness: .little)
            
            return encoder.encodedData
        }
    }
}

func encodeBitmapImage(width: Int, height: Int, bitDepth: BitDepth, pixels: [PixelData]) -> Data {
    let dibHeader = BitmapDIBHeader(bitmapWidth: UInt16(width),
                                    bitmapHeight: UInt16(height),
                                    bitsPerPixel: UInt16(bitDepth.rawValue))
    
    let calculatedSize = BitmapFileHeader.HeaderSize + Int(dibHeader.headerSize) + pixels.count
    
    let fileHeader = BitmapFileHeader(size: UInt32(calculatedSize),
                                      offset: UInt32(BitmapFileHeader.HeaderSize) + UInt32(dibHeader.headerSize))
    
    let mutableData = NSMutableData()
    mutableData.append(fileHeader.data)
    mutableData.append(dibHeader.data)
    
    let bgrPixels = pixels.flatMap { [$0.b, $0.g, $0.r] }
    mutableData.append(bgrPixels, length: bgrPixels.count)
    
    return mutableData as Data
}
