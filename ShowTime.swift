//
//  ShowTime.swift
//  ShowTime
//
//  Created by Kane Cheshire on 11/11/2016.
//  Copyright © 2016 Kane Cheshire. All rights reserved.
//

import UIKit

/// ShowTime displays your taps and swipes when you're presenting or demoing
/// Change the options to customise ShowTime
struct ShowTime {
  
  /// Whether ShowTime is enabled
  static var itsShowTime = true
  
  /// The fill (background) colour of the touch circles
  static var fillColor: UIColor = UIColor(white: 0.5, alpha: 0.5)
  /// The colour of the stroke (outline) of the touch circles
  static var strokeColor: UIColor = .gray
  /// The width (thickness) of the stroke around the touch circles
  static var strokeWidth: CGFloat = 1
  /// The size of the touch circles. The default is 44 x 44
  static var size = CGSize(width: 44, height: 44)
  /// Whether the touch circles should indicate a multiple tap (i.e. show a number 2 for a double tap)
  static var shouldShowMultipleTapCount = false
  /// The colour of the text to use when showing multiple tap counts
  static var multipleTapCountTextColor: UIColor = .black
  /// Whether the touch circles should visually show how much force is applied
  static var shouldShowForce = true
  
}

fileprivate final class TouchView: UILabel {
  
  convenience init(touch: UITouch, relativeTo view: UIView) {
    self.init()
    let location = touch.location(in: view)
    frame = CGRect(x: location.x - ShowTime.size.width / 2, y: location.y - ShowTime.size.height / 2, width: ShowTime.size.width, height: ShowTime.size.height)
    layer.cornerRadius = ShowTime.size.height / 2
    backgroundColor = ShowTime.fillColor
    layer.borderColor = ShowTime.strokeColor.cgColor
    layer.borderWidth = ShowTime.strokeWidth
    clipsToBounds = true
    textAlignment = .center
    textColor = ShowTime.multipleTapCountTextColor
    isUserInteractionEnabled = false
    text = ShowTime.shouldShowMultipleTapCount && touch.tapCount > 1 ? "\(touch.tapCount)" : nil
  }
  
  func update(with touch: UITouch, in view: UIView) {
    let location = touch.location(in: view)
    frame = CGRect(x: location.x - ShowTime.size.width / 2, y: location.y - ShowTime.size.height / 2, width: ShowTime.size.width, height: ShowTime.size.height)
    if ShowTime.shouldShowForce {
      let scale = 1 + (0.5 * touch.normalizedForce)
      CATransaction.begin()
      CATransaction.setDisableActions(true)
      layer.transform = CATransform3DMakeScale(scale, scale, 0)
      CATransaction.setDisableActions(false)
      CATransaction.commit()
    }
  }
  
}

extension UIWindow {
  
  fileprivate static var touches = [Int : TouchView]()
  
  open override class func initialize() {
    struct Swizzled { static var once = false } // Workaround for missing dispatch_once in Swift 3
    guard !Swizzled.once else { return }
    Swizzled.once = true
    method_exchangeImplementations(class_getInstanceMethod(self, #selector(UIWindow.sendEvent(_:))), class_getInstanceMethod(self, #selector(UIWindow.swizzled_sendEvent(_:))))
  }
  
  @objc private func swizzled_sendEvent(_ event: UIEvent) {
    self.swizzled_sendEvent(event)
    guard ShowTime.itsShowTime else { return }
    event.allTouches?.forEach {
      switch $0.phase {
      case .began:
        touchBegan($0)
      case .moved, .stationary:
        touchMoved($0)
      case .cancelled, .ended:
        touchEnded($0)
      }
    }
  }
  
  private func touchBegan(_ touch: UITouch) {
    let touchView = TouchView(touch: touch, relativeTo: self)
    self.addSubview(touchView)
    UIWindow.touches[touch.hashValue] = touchView
  }
  
  private func touchMoved(_ touch: UITouch) {
    guard let touchView = UIWindow.touches[touch.hashValue] else { return }
    touchView.update(with: touch, in: self)
  }
  
  private func touchEnded(_ touch: UITouch) {
    guard let touchView = UIWindow.touches[touch.hashValue] else { return }
    UIView.animate(withDuration: 0.2, animations: {
      touchView.alpha = 0
      touchView.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
    }, completion: { _ in
      touchView.removeFromSuperview()
    })
    UIWindow.touches[touch.hashValue] = nil
  }
  
}

extension UITouch {
  
  var normalizedForce: CGFloat {
    if #available(iOS 9.0, *), maximumPossibleForce > 0 {
      return force / maximumPossibleForce
    }
    return 0
  }
  
}
