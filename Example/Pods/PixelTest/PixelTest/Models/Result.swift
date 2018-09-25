//
//  Result.swift
//  PixelTest
//
//  Created by Kane Cheshire on 24/04/2018.
//

import Foundation

/// Represents a result of an action, with specialized success and failure values.
///
/// - success: The result is successful.
/// - fail: The result failed.
enum Result<S, F> {
    case success(S)
    case fail(F)
}
