//
//  Scale.swift
//  PixelTest
//
//  Created by Kane Cheshire on 19/03/2018.
//

import Foundation

/// Represents the scale of the resulting snapshot image.
/// I.e. whether it's @1x, @2x, @3x etc.
///
/// - native: Uses the device's native scale. (@2x on an iPhone SE, @3x on an iPhone 8 Plus)
/// - explicit: Forces an explicit scale, regardless of device.
public enum Scale {
    case native
    case explicit(CGFloat)
    
    var explicitOrScreenNativeValue: CGFloat {
        switch self {
        case .native: return UIScreen.main.scale
        case .explicit(let explicit): return explicit
        }
    }
    
    var explicitOrCoreGraphicsValue: CGFloat {
        switch self {
        case .native: return 0
        case .explicit(let explicit): return explicit
        }
    }
}
