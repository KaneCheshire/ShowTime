//
//  ShowTime.swift
//  ShowTime
//
//  Created by Kane Cheshire on 11/11/2016.
//  Copyright © 2016 Kane Cheshire. All rights reserved.
//

import UIKit

/// ShowTime displays your taps and swipes when you're presenting or demoing.
/// Change the options to customise ShowTime.
public struct ShowTime {
  
  /// Defines if and when ShowTime should be enabled.
  ///
  /// - always:    ShowTime is always enabled.
  /// - never:     ShowTime is never enabled.
  /// - debugOnly: ShowTime is enabled while the `DEBUG` flag is set and enabled.
  public enum Enabled {
    case always
    case never
    case debugOnly
  }
  
  /// Defines a style of animation.
  ///
  /// - standard: The standard type of animation will be used.
  /// - scaleDown: The animation has a scale down effect.
  /// - scaleUp: The animation has a scale up effect.
  public enum Animation {
    case standard
    case scaleDown
    case scaleUp
  }
  
  /// Whether ShowTime is enabled.
  /// Since Swift 4, it is no longer possible for ShowTime
  /// to automatically enable itself.
  ///(`.never` by default)
  public static var enabled: ShowTime.Enabled = .never {
    didSet {
      UIWindow.swizzle()
    }
  }
  
  /// The fill (background) colour of the visual touches. (Twitter Blue with 50% alpha by default)
  public static var fillColor = UIColor(red:0.21, green:0.61, blue:0.92, alpha:0.5)
  /// The colour of the stroke (outline) of the visual touches. (Twitter Blue by default)
  public static var strokeColor = UIColor(red:0.21, green:0.61, blue:0.92, alpha:1)
  /// The width (thickness) of the stroke around the visual touches. (3pt by default)
  public static var strokeWidth: CGFloat = 3
  /// The size of the touch circles. (44pt x 44pt by default)
  public static var size = CGSize(width: 44, height: 44)
  /// The style of animation to use when hiding a visual touch. (`.standard` by default)
  public static var disappearAnimation: ShowTime.Animation = .standard
  /// The delay, in seconds, before the visual touch disappears after a touch ends. (0.1s by default)
  public static var disappearDelay: TimeInterval = 0.1
  /// Whether the visual touches should indicate a multiple tap (i.e. show a number 2 for a double tap). (false by default)
  public static var shouldShowMultipleTapCount = false
  /// The colour of the text to use when showing multiple tap counts. (black by default)
  public static var multipleTapCountTextColor: UIColor = .black
  /// Whether the visual touch should visually show how much force is applied. (true by default)
  public static var shouldShowForce = true
  /// Whether touch events from Apple Pencil are ignored. (true by default)
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

class TouchView: UILabel {
  
  /// Creates a new instance representing a touch to visually display.
  ///
  /// - Parameters:
  ///   - touch: A `UITouch` instance the visual touch represents.
  ///   - view: A view the touch is relative to, typically the window calling `sendEvent(_:)`.
  convenience init(touch: UITouch, relativeTo view: UIView) {
    let location = touch.location(in: view)
    self.init(frame: CGRect(x: location.x - ShowTime.size.width / 2, y: location.y - ShowTime.size.height / 2, width: ShowTime.size.width, height: ShowTime.size.height))
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
  
  /// Updates the position and force level of a visual touch.
  ///
  /// - Parameters:
  ///   - touch: A `UITouch` instance the visual touch represents.
  ///   - view: A view the touch is relative to, typically the window calling `sendEvent(_:)`.
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
  
  /// Animates the visual touch out to disappear from view.
  /// Removes itself from the superview after the animation complete.
  func disappear() {
    UIView.animate(withDuration: 0.2, delay: ShowTime.disappearDelay, options: [.beginFromCurrentState], animations: { [weak self] in
      switch ShowTime.disappearAnimation {
      case .standard: self?.standard()
      case .scaleDown: self?.scaleDown()
      case .scaleUp: self?.animateScaleUp()
      }
      }, completion: { [weak self] _ in
        self?.removeFromSuperview()
    })
  }
  
  private func standard() {
    alpha = 0
    transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
  }
  
  private func scaleDown() {
    transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
  }
  
  private func animateScaleUp() {
    alpha = 0
    transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
  }
  
}

internal var _touches = [UITouch : TouchView]()

extension UIWindow {

  fileprivate class func swizzle() { // `initialize()` removed in Swift 4
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
      case .began: touchBegan($0)
      case .moved, .stationary: touchMoved($0)
      case .cancelled, .ended: touchEnded($0)
      }
    }
  }
  
  private func touchBegan(_ touch: UITouch) {
    let touchView = TouchView(touch: touch, relativeTo: self)
    self.addSubview(touchView)
    _touches[touch] = touchView
  }
  
  private func touchMoved(_ touch: UITouch) {
    guard let touchView = _touches[touch] else { return }
    touchView.update(with: touch, relativeTo: self)
  }
  
  private func touchEnded(_ touch: UITouch) {
    guard let touchView = _touches[touch] else { return }
    touchView.disappear()
    _touches[touch] = nil
  }
  
}

fileprivate extension UITouch {
  
  /// Normalizes the level of force betwenn 0 and 1 regardless of device.
  /// Will always be 0 for devices that don't support 3D Touch.
  var normalizedForce: CGFloat {
    guard #available(iOS 9.0, *), maximumPossibleForce > 0 else { return 0 }
    return force / maximumPossibleForce
  }
  
  /// Whether the touch event is from an Apple Pencil (i.e. type `.stylus`).
  var isApplePencil: Bool {
    guard #available(iOS 9.1, *) else { return false }
    return type == .stylus
  }
  
}
