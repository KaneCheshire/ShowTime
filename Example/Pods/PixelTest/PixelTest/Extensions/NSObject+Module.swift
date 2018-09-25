//
//  NSObject+Module.swift
//  PixelTest
//
//  Created by Kane Cheshire on 16/04/2018.
//

import Foundation

extension NSObject {
    
    // MARK: - Properties -
    // MARK: Internal
    
    /// The module the object belongs to.
    var module: Module {
        return Module(name: typeComponents[safe: 0] ?? "Unknown")
    }
    
    /// The class of the object.
    var className: String {
        return typeComponents[safe: 1] ?? "Unknown"
    }
    
    // MARK: Private
    
    private var typeComponents: [String] {
        return String(reflecting: type(of: self)).components(separatedBy: ".")
    }
    
}
