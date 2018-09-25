//
//  FileCoordinatorType.swift
//  PixelTest
//
//  Created by Kane Cheshire on 24/04/2018.
//

import Foundation

protocol FileCoordinatorType {
    
    func fileURL(for testCase: PixelTestCase, forFunction function: StaticString, scale: Scale, imageType: ImageType, layoutStyle: LayoutStyle) -> URL?
    func write(_ data: Data, to url: URL) throws
    func data(at url: URL) throws -> Data
    func storeDiffImage(_ diffImage: UIImage, failedImage: UIImage, for pixelTestCase: PixelTestCase, function: StaticString, scale: Scale, layoutStyle: LayoutStyle)
    func removeDiffAndFailureImages(for pixelTestCase: PixelTestCase, function: StaticString, scale: Scale, layoutStyle: LayoutStyle)
    
}
