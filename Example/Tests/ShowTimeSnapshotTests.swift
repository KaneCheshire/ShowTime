//
//  ShowTimeSnapshotTests.swift
//  ShowTime_Tests
//
//  Created by Kane Cheshire on 10/04/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import PixelTest
@testable import ShowTime

class ShowTimeSnapshotTests: PixelTestCase {
    
    override func setUp() {
        super.setUp()
        ShowTime.fillColor = .auto
        ShowTime.strokeColor = UIColor(red: 0.21, green: 0.61, blue: 0.92, alpha: 1)
        ShowTime.strokeWidth = 3
        ShowTime.size = CGSize(width: 44, height: 44)
        ShowTime.shouldShowMultipleTapCount = false
        ShowTime.multipleTapCountTextColor = .black
        ShowTime.multipleTapCountTextFont = .systemFont(ofSize: 17, weight: .bold)
        mode = .test
    }
    
    func test_init() throws {
        try createAndVerifyTouchView()
    }
    
    func test_fillColor_auto_usesStrokeColor() throws {
        ShowTime.fillColor = .auto
        ShowTime.strokeColor = .red
        try createAndVerifyTouchView()
    }
    
    func test_fillColor_specific_usesSpecificColor() throws {
        ShowTime.fillColor = .orange
        ShowTime.strokeColor = .yellow
        try createAndVerifyTouchView()
    }
    
    func test_specificSize() throws {
        ShowTime.size = CGSize(width: 22, height: 22) // TODO: Make it impossible to choose a height different from a width
        try createAndVerifyTouchView()
    }
    
    func test_strokeWidth() throws {
        ShowTime.strokeWidth = 1
        try createAndVerifyTouchView()
    }
    
    func test_multipleTapCount_off() throws {
        ShowTime.shouldShowMultipleTapCount = false
        try createAndVerifyTouchView(tapCount: 2)
    }
    
    func test_multipleTapCount_on() throws {
        ShowTime.shouldShowMultipleTapCount = true
        try createAndVerifyTouchView(tapCount: 2)
    }
    
    func test_multipleTapCount_customFont() throws {
        ShowTime.shouldShowMultipleTapCount = true
        ShowTime.multipleTapCountTextFont = .italicSystemFont(ofSize: 10)
        try createAndVerifyTouchView(tapCount: 2)
    }
    
    func test_multipleTapCount_customColor() throws {
        ShowTime.shouldShowMultipleTapCount = true
        ShowTime.multipleTapCountTextColor = .white
        try createAndVerifyTouchView(tapCount: 2)
    }
    
}

private extension ShowTimeSnapshotTests {
    
    func createAndVerifyTouchView(tapCount: Int = 1, line: UInt = #line, function: StaticString = #function) throws {
        let touch = MockTouch(tapCount: tapCount, phase: .moved, type: .direct)
        let view = TouchView(touch: touch, relativeTo: UIView())
        try verify(view, layoutStyle: .fixed(width: view.frame.width, height: view.frame.height), function: function, line: line)
    }
    
}
