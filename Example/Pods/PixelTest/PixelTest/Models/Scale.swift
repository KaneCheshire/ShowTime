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

}

extension Scale {
    
    /// The value of the scale using the explicit value, or screen value if native.
    /// I.e. Native would return 3.0 on iPhone X, 2.0 on iPhone SE.
    var explicitOrScreenNativeValue: CGFloat {
        switch self {
        case .native: return UIScreen.main.scale
        case .explicit(let explicit): return explicit
        }
    }
    
    /// The value of the scale using the explit value, or core graphics value if native.
    /// I.e. Native would return 0, meaning use whatever the device's native value is.
    var explicitOrCoreGraphicsValue: CGFloat {
        switch self {
        case .native: return 0
        case .explicit(let explicit): return explicit
        }
    }
    
}
