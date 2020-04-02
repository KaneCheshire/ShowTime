//
//  LayoutStyle.swift
//  PixelTest
//
//  Created by Kane Cheshire on 19/03/2018.
//

import Foundation

/// Represents a layout style for verifying a view.
///
/// - dynamicWidth: The view should have a dynamic width, but fixed height.
/// - dynamicHeight: The view should have a dynamic height, but fixed width.
/// - dynamicWidthHeight: The view should have a dynamic width and height.
/// - fixed: The view should have a fixed width and height.
public enum LayoutStyle {
    case dynamicWidth(fixedHeight: CGFloat)
    case dynamicHeight(fixedWidth: CGFloat)
    case dynamicWidthHeight
    case fixed(width: CGFloat, height: CGFloat)
    
    var fileValue: String {
        switch self {
        case .dynamicWidth(fixedHeight: let height): return "dw_\(height)"
        case .dynamicHeight(fixedWidth: let width): return "\(width)_dh"
        case .dynamicWidthHeight: return "dw_dh"
        case .fixed(width: let width, height: let height): return "\(width)_\(height)"
        }
    }
}

public extension LayoutStyle {
    
    /// Default `dynamicHeight` with a `fixedWidth` of `320`, i.e. iPhone SE size.
    static let dynamicHeight: LayoutStyle = .dynamicHeight(fixedWidth: 320)
    
}
