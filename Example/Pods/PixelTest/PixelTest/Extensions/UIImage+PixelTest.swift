//
//  UIImage+PixelTest.swift
//  PixelTest
//
//  Created by Kane Cheshire on 11/02/2018.
//

import Foundation

extension UIImage {
    
    /// Determines if the image is equal to another image.
    ///
    /// - Parameter image: The other image.
    /// - Returns: `true` if the two images are identical.
    func equalTo(_ image: UIImage) -> Bool {
        guard size == image.size else { return false }
        return pngData() == image.pngData()
    }
    
    /// Creates a diff image betweeh the view and another image.
    ///
    /// - Parameter image: The other image
    /// - Returns: A new image representing a diff of the two images, or nil if an image couldn't be created.
    func diff(with image: UIImage) -> UIImage? { // TODO: split this up
        let maxWidth = max(size.width, image.size.width)
        let maxHeight = max(size.height, image.size.height)
        let diffSize = CGSize(width: maxWidth, height: maxHeight)
        UIGraphicsBeginImageContextWithOptions(diffSize, true, scale)
        let context = UIGraphicsGetCurrentContext()
        draw(in: CGRect(origin: .zero, size: size))
        context?.setAlpha(0.5)
        context?.beginTransparencyLayer(auxiliaryInfo: nil)
        image.draw(in: CGRect(origin: .zero, size: image.size))
        context?.setBlendMode(.difference)
        context?.setFillColor(UIColor.white.cgColor)
        context?.fill(CGRect(origin: .zero, size: diffSize))
        context?.endTransparencyLayer()
        let diffImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return diffImage
    }
    
}
