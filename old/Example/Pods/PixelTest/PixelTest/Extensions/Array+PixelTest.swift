//
//  Array+PixelTest.swift
//  PixelTest
//
//  Created by Kane Cheshire on 11/02/2018.
//

import Foundation

extension Array {
    
    /// Safely attempts to retrieve an item by index.
    ///
    /// - Parameter index: The index to try to get the element from.
    subscript(safe index: Index) -> Element? {
        return indices ~= index ? self[index] : nil
    }
    
}
