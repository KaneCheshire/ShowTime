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
    
    func test_init() {
        createAndVerifyTouchView()
    }
    
    func test_fillColor_auto_usesStrokeColor() {
        ShowTime.fillColor = .auto
        ShowTime.strokeColor = .red
        createAndVerifyTouchView()
    }
    
    func test_fillColor_specific_usesSpecificColor() {
        ShowTime.fillColor = .orange
        ShowTime.strokeColor = .yellow
        createAndVerifyTouchView()
    }
    
    func test_specificSize() {
        ShowTime.size = CGSize(width: 22, height: 22) // TODO: Make it impossible to choose a height different from a width
        createAndVerifyTouchView()
    }
    
    func test_strokeWidth() {
        ShowTime.strokeWidth = 1
        createAndVerifyTouchView()
    }
    
    func test_multipleTapCount_off() {
        ShowTime.shouldShowMultipleTapCount = false
        createAndVerifyTouchView(tapCount: 2)
    }
    
    func test_multipleTapCount_on() {
        ShowTime.shouldShowMultipleTapCount = true
        createAndVerifyTouchView(tapCount: 2)
    }
    
    func test_multipleTapCount_customFont() {
        ShowTime.shouldShowMultipleTapCount = true
        ShowTime.multipleTapCountTextFont = .italicSystemFont(ofSize: 10)
        createAndVerifyTouchView(tapCount: 2)
    }
    
    func test_multipleTapCount_customColor() {
        ShowTime.shouldShowMultipleTapCount = true
        ShowTime.multipleTapCountTextColor = .white
        createAndVerifyTouchView(tapCount: 2)
    }
    
}

private extension ShowTimeSnapshotTests {
    
    func createAndVerifyTouchView(tapCount: Int = 1, line: UInt = #line, function: StaticString = #function) {
        let touch = MockTouch(tapCount: tapCount, phase: .moved, type: .direct)
        let view = TouchView(touch: touch, relativeTo: UIView())
        verify(view, layoutStyle: .fixed(width: view.frame.width, height: view.frame.height), function: function, line: line)
    }
    
}
