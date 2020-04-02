//
//  XCTestCase+InfoPlist.swift
//  PixelTest
//
//  Created by Kane Cheshire on 21/10/2019.
//

import XCTest

extension XCTestCase {
    
    var testTargetInfoPlist: InfoPlist { return InfoPlist(bundle: Bundle(for: type(of: self))) }
    
}
