import UIKit
import XCTest
@testable import ShowTime

class MockTouch: UITouch {
  
  let taps: Int
  
  init(tapCount: Int = 1) {
    self.taps = tapCount
  }
  
  override var tapCount: Int {
    return taps
  }
}

class Tests: XCTestCase {
  
  func test_enablingShowTime() {
    ShowTime.enabled = .never
    XCTAssertEqual(ShowTime.enabled, .never)
    XCTAssertFalse(ShowTime.shouldEnable)
    
    ShowTime.enabled = .debugOnly
    XCTAssertEqual(ShowTime.enabled, .debugOnly)
    XCTAssertTrue(ShowTime.shouldEnable)
    
    ShowTime.enabled = .always
    XCTAssertEqual(ShowTime.enabled, .always)
    XCTAssertTrue(ShowTime.shouldEnable)
  }
  
  func test_creatingTouchView() {
    
    let touch = MockTouch(tapCount: 5)
    let touchView = TouchView(touch: touch, relativeTo: UIView())
    XCTAssertEqual(touchView.frame.width, ShowTime.size.width)
    XCTAssertEqual(touchView.frame.height, ShowTime.size.height)
    XCTAssertEqual(touchView.layer.cornerRadius, ShowTime.size.height / 2)
    XCTAssertEqual(touchView.layer.borderColor, ShowTime.strokeColor.cgColor)
    XCTAssertEqual(touchView.layer.borderWidth, ShowTime.strokeWidth)
    XCTAssertEqual(touchView.backgroundColor, ShowTime.fillColor)
    XCTAssertFalse(ShowTime.shouldShowMultipleTapCount)
    XCTAssertNil(touchView.text)
    XCTAssertEqual(touchView.textAlignment, .center)
    XCTAssertEqual(touchView.textColor, ShowTime.multipleTapCountTextColor)
    XCTAssertTrue(touchView.clipsToBounds)
    XCTAssertFalse(touchView.isUserInteractionEnabled)
  }
  
  func test_touchViewUsesChangedValues() {
    ShowTime.size = CGSize(width: 10000, height: 10000)
    ShowTime.strokeColor = .orange
    ShowTime.strokeWidth = 100
    ShowTime.fillColor = .green
    ShowTime.multipleTapCountTextColor = .yellow
    ShowTime.shouldShowMultipleTapCount = true
    
    let touch = MockTouch(tapCount: 5)
    let touchView = TouchView(touch: touch, relativeTo: UIView())
    XCTAssertEqual(touchView.frame.width, ShowTime.size.width)
    XCTAssertEqual(touchView.frame.width, 10000)
    XCTAssertEqual(touchView.frame.height, ShowTime.size.height)
    XCTAssertEqual(touchView.frame.height, 10000)
    XCTAssertEqual(touchView.layer.cornerRadius, ShowTime.size.height / 2)
    XCTAssertEqual(touchView.layer.cornerRadius, 5000)
    XCTAssertEqual(touchView.layer.borderColor, ShowTime.strokeColor.cgColor)
    XCTAssertEqual(touchView.layer.borderColor, UIColor.orange.cgColor)
    XCTAssertEqual(touchView.layer.borderWidth, ShowTime.strokeWidth)
    XCTAssertEqual(touchView.layer.borderWidth, 100)
    XCTAssertEqual(touchView.backgroundColor, ShowTime.fillColor)
    XCTAssertEqual(touchView.backgroundColor, .green)
    XCTAssertEqual(touchView.text, "5")
    XCTAssertEqual(touchView.textAlignment, .center)
    XCTAssertEqual(touchView.textColor, ShowTime.multipleTapCountTextColor)
    XCTAssertEqual(touchView.textColor, .yellow)
    XCTAssertTrue(touchView.clipsToBounds)
    XCTAssertFalse(touchView.isUserInteractionEnabled)
  }
  
  func test_showingMultipleTapCount() {
    XCTAssertFalse(ShowTime.shouldShowMultipleTapCount)
    let touchWith5Taps = MockTouch(tapCount: 5)
    let touchView1 = TouchView(touch: touchWith5Taps, relativeTo: UIView())
    XCTAssertNil(touchView1.text)
    
    ShowTime.shouldShowMultipleTapCount = true
    XCTAssertTrue(ShowTime.shouldShowMultipleTapCount)
    let touchWith1Tap = MockTouch()
    let touchView2 = TouchView(touch: touchWith1Tap, relativeTo: UIView())
    XCTAssertNil(touchView2.text)
    
    XCTAssertTrue(ShowTime.shouldShowMultipleTapCount)
    let touchWith2Taps = MockTouch(tapCount: 2)
    let touchView3 = TouchView(touch: touchWith2Taps, relativeTo: UIView())
    XCTAssertEqual(touchView3.text, "2")
  }
    
}
