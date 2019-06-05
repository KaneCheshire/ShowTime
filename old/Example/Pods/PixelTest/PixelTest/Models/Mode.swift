//
//  Mode.swift
//  PathKit
//
//  Created by Kane Cheshire on 19/03/2018.
//

import Foundation

/// Represents a mode that the test/tests are running in.
/// Typically you would change this in `setUp()`.
///
/// - record: The tests are running in record mode. While this mode is set, any tests that run record a snapshot, overwriting any existing snapshots for that test.
/// - test: The tests are running in test mode. While this mode is set, any tests that run will be verified against recorded snapshots.
public enum Mode {
    case record
    case test
}
