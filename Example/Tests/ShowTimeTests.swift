import UIKit
import XCTest
@testable import ShowTime

class ShowTimeTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        _touches.removeAll()
    }
    
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
    
    func test_handlingEvents() {
        XCTAssertTrue(_touches.isEmpty)
        let eventWithNoTouches = MockEvent()
        let window = UIWindow()
        window.sendEvent(eventWithNoTouches)
        XCTAssertTrue(_touches.isEmpty)
        
        let touch1 = MockTouch()
        let eventWithOneTouch = MockEvent(touches: [touch1])
        window.sendEvent(eventWithOneTouch)
        XCTAssertEqual(_touches.count, 1)
        XCTAssertNotNil(_touches[touch1])
        
        let touch2 = MockTouch()
        let touch3 = MockTouch()
        XCTAssertNil(_touches[touch2])
        XCTAssertNil(_touches[touch3])
        let eventWithMultipleTouches = MockEvent(touches: [touch2, touch3])
        window.sendEvent(eventWithMultipleTouches)
        XCTAssertEqual(_touches.count, 3)
        XCTAssertNotNil(_touches[touch2])
        XCTAssertNotNil(_touches[touch3])
    }
    
    func test_touchPhases() {
        XCTAssertTrue(_touches.isEmpty)
        let touch = MockTouch(phase: .began)
        let event = MockEvent(touches: [touch])
        let window = UIWindow()
        window.sendEvent(event)
        XCTAssertEqual(_touches.count, 1)
        
        touch._phase = .moved
        window.sendEvent(event)
        XCTAssertEqual(_touches.count, 1)
        
        touch._phase = .ended
        window.sendEvent(event)
        XCTAssertEqual(_touches.count, 0)
        
        let touch2 = MockTouch(phase: .began)
        let event2 = MockEvent(touches: [touch2])
        window.sendEvent(event2)
        XCTAssertEqual(_touches.count, 1)
        
        touch2._phase = .stationary
        window.sendEvent(event2)
        XCTAssertEqual(_touches.count, 1)
        
        touch2._phase = .cancelled
        window.sendEvent(event2)
        XCTAssertEqual(_touches.count, 0)
    }
    
    func test_ignoringApplePencilEvents() {
        XCTAssertTrue(_touches.isEmpty)
        XCTAssertTrue(ShowTime.shouldIgnoreApplePencilEvents)
        
        let window = UIWindow()
        let applePencilTouch = MockTouch(type: .stylus)
        let event = MockEvent(touches: [applePencilTouch])
        window.sendEvent(event)
        XCTAssertEqual(_touches.count, 0)
        
        ShowTime.shouldIgnoreApplePencilEvents = false
        XCTAssertFalse(ShowTime.shouldIgnoreApplePencilEvents)
        window.sendEvent(event)
        XCTAssertEqual(_touches.count, 1)
    }
    
    func test_removingTouchViewsAfterDisabling() {
        XCTAssertTrue(_touches.isEmpty)
        
        let defaultState = ShowTime.enabled
        ShowTime.enabled = .always
        
        let window = UIWindow()
        let startEvent = MockEvent(touches: [MockTouch(phase: .began)])
        window.sendEvent(startEvent)
        ShowTime.enabled = .never
        let endEvent = MockEvent(touches: [MockTouch(phase: .ended)])
        window.sendEvent(endEvent)
        
        XCTAssertTrue(_touches.isEmpty)
        ShowTime.enabled = defaultState
    }
    
    func test_autoFillColorSetsAlpha() {
        ShowTime.fillColor = .auto
        ShowTime.strokeColor = .red
        XCTAssertEqual(ShowTime.fillColor, .auto)
        XCTAssertEqual(ShowTime.strokeColor, .red)
        let view = TouchView(touch: UITouch(), relativeTo: UIView())
        XCTAssertEqual(view.backgroundColor, UIColor.red.withAlphaComponent(0.5))
        XCTAssertEqual(view.layer.borderColor, UIColor.red.cgColor)
    }
    
    func test_specificFillColorSet() {
        ShowTime.fillColor = .yellow
        ShowTime.strokeColor = .black
        XCTAssertEqual(ShowTime.fillColor, .yellow)
        XCTAssertEqual(ShowTime.strokeColor, .black)
        let view = TouchView(touch: UITouch(), relativeTo: UIView())
        XCTAssertEqual(view.backgroundColor, .yellow)
        XCTAssertEqual(view.layer.borderColor, UIColor.black.cgColor)
    }
    
}

extension ShowTimeTests {
    
    class MockEvent: UIEvent {
        
        let touches: [UITouch]
        
        init(touches: [UITouch] = []) {
            self.touches = touches
        }
        
        override var allTouches: Set<UITouch>? {
            return Set(touches)
        }
        
    }
    
}

class MockTouch: UITouch {
    
    let taps: Int
    var _phase: UITouch.Phase
    let _type: UITouch.TouchType
    
    init(tapCount: Int = 1, phase: UITouch.Phase = .began, type: UITouch.TouchType = .direct) {
        self.taps = tapCount
        self._phase = phase
        self._type = type
    }
    
    override var tapCount: Int {
        return taps
    }
    
    override var phase: UITouch.Phase {
        return _phase
    }
    
    override var type: UITouch.TouchType {
        return _type
    }
    
}
