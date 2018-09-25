//
//  ImageType.swift
//  PixelTest
//
//  Created by Kane Cheshire on 19/03/2018.
//

import Foundation

/// Represents a type of image PixelTest knows how to use.
///
/// - reference: An image type representing a recorded/oracle image.
/// - diff: An image type representing the diff between two other images.
/// - failure: An image type representing a failed image.
enum ImageType: String {
    case reference = "Reference"
    case diff = "Diff"
    case failure = "Failure"
}
