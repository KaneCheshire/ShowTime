//
//  UIView+PixelTest.swift
//  PixelTest
//
//  Created by Kane Cheshire on 11/02/2018.
//

import UIKit

extension UIView {
    
    /// Creates an image from the view's contents, using its layer.
    ///
    /// - Parameter scale: The scale of the image to create.
    /// - Returns: An image, or nil if an image couldn't be created.
    func image(withScale scale: Scale) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, scale.explicitOrCoreGraphicsValue)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.saveGState()
        layer.render(in: context)
        context.restoreGState()
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
    
}
