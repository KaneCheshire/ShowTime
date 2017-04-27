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
public struct ShowTime {
  
  /// Defines if and when ShowTime should be enabled
  ///
  /// - always:    ShowTime is always enabled
  /// - never:     ShowTime is never enabled
  /// - debugOnly: ShowTime is enabled while the DEBUG flag is enabled.
  public enum Enabled {
    case always
    case never
    case debugOnly
  }
  
  /// Whether ShowTime is enabled
  public static var enabled: ShowTime.Enabled = .debugOnly
  
  /// The fill (background) colour of the visual touches
  public static var fillColor = UIColor(red:0.21, green:0.61, blue:0.92, alpha:0.5)
  /// The colour of the stroke (outline) of the visual touches
  public static var strokeColor = UIColor(red:0.21, green:0.61, blue:0.92, alpha:1)
  /// The width (thickness) of the stroke around the visual touches
  public static var strokeWidth: CGFloat = 3
  /// The size of the touch circles. The default is 44pt x 44pt
  public static var size = CGSize(width: 44, height: 44)
  /// The delay, in seconds, before the visual touch disappears after a touch ends (0.1s by default)
  public static var disappearDelay: TimeInterval = 0.1
  /// Whether the visual touches should indicate a multiple tap (i.e. show a number 2 for a double tap) (false by default)
  public static var shouldShowMultipleTapCount = false
  /// The colour of the text to use when showing multiple tap counts
  public static var multipleTapCountTextColor: UIColor = .black
  /// Whether the visual touch should visually show how much force is applied (true by default)
  public static var shouldShowForce = true
  /// Whether touch events from Apple Pencil are ignored (true by default)
  public static var shouldIgnoreApplePencilEvents = true
  
  static var shouldEnable: Bool {
    guard enabled != .never else { return false }
    guard enabled != .debugOnly else {
      #if DEBUG
        return true
      #else
        return false
      #endif
    }
    return true
  }
  
}

final class TouchView: UILabel {
  
  /// Creates a new instance representing a touch to visually display
  ///
  /// - Parameters:
  ///   - touch: A `UITouch` instance the visual touch represents
  ///   - view: A view the touch is relative to, typically the window calling `sendEvent(_:)`
  convenience init(touch: UITouch, relativeTo view: UIView) {
    self.init()
    let location = touch.location(in: view)
    frame = CGRect(x: location.x - ShowTime.size.width / 2, y: location.y - ShowTime.size.height / 2, width: ShowTime.size.width, height: ShowTime.size.height)
    layer.cornerRadius = ShowTime.size.height / 2
    layer.borderColor = ShowTime.strokeColor.cgColor
    layer.borderWidth = ShowTime.strokeWidth
    backgroundColor = ShowTime.fillColor
    text = ShowTime.shouldShowMultipleTapCount && touch.tapCount > 1 ? "\(touch.tapCount)" : nil
    textAlignment = .center
    textColor = ShowTime.multipleTapCountTextColor
    clipsToBounds = true
    isUserInteractionEnabled = false
  }
  
  /// Updates the position and force level of a visual touch
  ///
  /// - Parameters:
  ///   - touch: A `UITouch` instance the visual touch represents
  ///   - view: A view the touch is relative to, typically the window calling `sendEvent(_:)`
  func update(with touch: UITouch, relativeTo view: UIView) {
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
  
  /// Animates the visual touch out to disappear from view
  /// Removes itself from the superview after the animation complete
  func disappear() {
    UIView.animate(withDuration: 0.2, delay: ShowTime.disappearDelay, options: [], animations: { [weak self] in
      self?.alpha = 0
      self?.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
      }, completion: { [weak self] _ in
        self?.removeFromSuperview()
    })
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
    guard ShowTime.shouldEnable else { return }
    event.allTouches?.forEach {
      if ShowTime.shouldIgnoreApplePencilEvents && $0.isApplePencil { return }
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
    touchView.update(with: touch, relativeTo: self)
  }
  
  private func touchEnded(_ touch: UITouch) {
    guard let touchView = UIWindow.touches[touch.hashValue] else { return }
    touchView.disappear()
    UIWindow.touches[touch.hashValue] = nil
  }
  
}

fileprivate extension UITouch {
  
  /// Normalizes the level of force betwenn 0 and 1 regardless of device.
  /// Will always be 0 for devices that don't support 3D Touch
  var normalizedForce: CGFloat {
    if #available(iOS 9.0, *), maximumPossibleForce > 0 {
      return force / maximumPossibleForce
    }
    return 0
  }
  
  /// Whether the touch event is from an Apple Pencil (i.e. type `.stylus`)
  var isApplePencil: Bool {
    if #available(iOS 9.1, *) {
      return type == .stylus
    }
    return false
  }
  
}
