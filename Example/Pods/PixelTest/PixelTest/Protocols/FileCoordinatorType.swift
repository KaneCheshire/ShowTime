//
//  FileCoordinatorType.swift
//  PixelTest
//
//  Created by Kane Cheshire on 24/04/2018.
//

import Foundation

protocol FileCoordinatorType {
    
    func fileURL(for config: Config, imageType: ImageType) -> URL
    func write(_ data: Data, to url: URL) throws
    func data(at url: URL) throws -> Data
    func store(diffImage: UIImage, failedImage: UIImage, config: Config)
    func removeDiffAndFailureImages(config: Config)
    
}
