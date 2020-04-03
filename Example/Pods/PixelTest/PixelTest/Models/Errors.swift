//
//  Errors.swift
//  PixelTest
//
//  Created by Kane Cheshire on 16/10/2019.
//

import Foundation

public enum Errors {
    
    enum Record: Error {
        case unableToCreateSnapshot
        case unableToCreateImageData
        case unableToWriteImageToDisk(Error)
    }
    
    enum Test: Error {
        case unableToCreateSnapshot
        case unableToGetRecordedImageData
        case unableToGetRecordedImage
        case imagesAreDifferent(reference: UIImage, failed: UIImage)
    }
    
}

extension Errors.Record {
    
    var localizedDescription: String {
        switch self {
            case .unableToCreateImageData: return "Unable to create image data"
            case .unableToCreateSnapshot: return "Unable to create snapshot image"
            case .unableToWriteImageToDisk(let underlying): return "Unable to write image to disk: \(underlying.localizedDescription)"
        }
    }
    
}

extension Errors.Test {
    
    var localizedDescription: String {
        switch self {
            case .unableToCreateSnapshot: return "Unable to create snapshot image"
            case .unableToGetRecordedImage: return "Unable to get recorded image"
            case .unableToGetRecordedImageData: return "Unable to get recorded image data"
            case .imagesAreDifferent: return "Images are different (see attached diff/failure images in logs)"
        }
    }
    
}
