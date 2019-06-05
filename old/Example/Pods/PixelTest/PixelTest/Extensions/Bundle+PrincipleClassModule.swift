//
//  Bundle+PrincipleClassModule.swift
//  PixelTest
//
//  Created by Kane Cheshire on 19/09/2018.
//

import Foundation

extension Bundle {
    
    /// Returns the module for the bundle's principle class (if any)
    var moduleForPrincipleClass: Module? {
        guard let principalClass = principalClass, let moduleName = String(reflecting: type(of: principalClass)).components(separatedBy: ".").first else { return nil }
        return Module(name: moduleName)
    }
    
}
