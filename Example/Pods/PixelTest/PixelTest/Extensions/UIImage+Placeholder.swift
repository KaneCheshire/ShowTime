//
//  UIImage+Placeholder.swift
//  PixelTest
//
//  Created by Kane Cheshire on 19/10/2019.
//

import UIKit

public extension UIImage {
    
    static let small = placeholderImageGenerator.generate(CGSize(width: 16, height: 16))
    static let medium = placeholderImageGenerator.generate(CGSize(width: 64, height: 64))
    static let large = placeholderImageGenerator.generate(CGSize(width: 128, height: 128))
    
    static func sized(width: CGFloat, height: CGFloat) -> UIImage { return placeholderImageGenerator.generate(CGSize(width: width, height: height)) }
    
}

private extension UIImage {
    
    static let placeholderImageGenerator = PlaceholderImageGenerator()
    
}
