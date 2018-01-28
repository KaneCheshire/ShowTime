[![CI Status](http://img.shields.io/travis/KaneCheshire/ShowTime.svg?style=flat)](https://travis-ci.org/KaneCheshire/Communicator)
[![Version](https://img.shields.io/cocoapods/v/ShowTime.svg?style=flat)](http://cocoapods.org/pods/ShowTime)
[![License](https://img.shields.io/cocoapods/l/ShowTime.svg?style=flat)](http://cocoapods.org/pods/ShowTime)
[![Platform](https://img.shields.io/cocoapods/p/ShowTime.svg?style=flat)](http://cocoapods.org/pods/ShowTime)

# It's ShowTime 🎥

- [Installation (Swift 4)](#installation-swift-4)
    - [Cocoapods](#cocoapods)
    - [Manual](#manual)
- [Installation (Swift 3)](#installation-swift-3)
    - [Cocoapods](#cocoapods-1)
    - [Manual](#manual-1)
- [Usage](#usage)
- [How it works](#how-it-works)
- [Useful info](#useful-info)
- [Author](#author)
- [License](#license)

ShowTime is the simplest and best way to display all your taps and gestures on screen. Perfect for that demo, presentation or video.

One file is all you need to add that extra polish your demos. ShowTime even **displays the level of force you're applying**, and can be configured to show the **actual number of taps performed**. Apple Pencil events are configurable and disabled by default.

ShowTime works with **single- and multi-window setups**, as well as in iOS widgets, and works with any Swift or Objective-C project.

Check out **[How it works](#how-it-works)**.

Consider using ShowTime when you're sharing or recording your screen through QuickTime or AirPlay. By default, the size of the visual touches are 44pt; this mirrors Apple's guidelines for minimum hit size for buttons on iOS. You're free to change this, of course!

Showing your gestures during demos gives your audience a much clearer context on what's happening on your device. Try ShowTime for your next demo, it's insanely easy to set up!

![ShowTime](http://kanecheshire.com/images/github/showtime-demo-4.gif)

## Installation (Swift 4)

Integrating ShowTime with Swift 4 takes one extra step unfortunately, due to removal of a required function ShowTime uses for swizzling.

### Cocoapods

- Step 1: Add `pod 'ShowTime', '2.1.0'` to your Podfile and run `pod update` in Terminal.
- Step 2: Enable ShowTime somewhere (like your `AppDelegate`) :

```
// Swift:

ShowTime.enabled = .always
ShowTime.enabled = .debugOnly

// Objective-C:

ShowTime.enabled = EnabledAlways;
ShowTime.enabled = EnabledDebugOnly;

```

That's all you need to do, but you're free to change some of the many options!

### Manual

- Step 1: Drop [`ShowTime.swift`](https://raw.githubusercontent.com/KaneCheshire/ShowTime/2.0.1/ShowTime.swift) into your project or copy the contents of it where ever you like.
- Step 2: Enable ShowTime somewhere (like your `AppDelegate`) :

```
// Swift:

ShowTime.enabled = .always
ShowTime.enabled = .debugOnly

// Objective-C:

ShowTime.enabled = EnabledAlways;
ShowTime.enabled = EnabledDebugOnly;
```

That's all you need to do, but you're free to change some of the many options!

## Installation (Swift 3)

### Cocoapods

- Step 1: Add `pod 'ShowTime', '1.0.1'` to your Podfile and run `pod update` in Terminal. You don't need to do anything else, ShowTime can automatically enable itself with Swift 3.

### Manual

- Step 1: [Switch to tag/branch `1.0.1`](https://github.com/KaneCheshire/ShowTime/tree/1.0.1) and drop [`ShowTime.swift`](https://raw.githubusercontent.com/KaneCheshire/ShowTime/1.0.1/ShowTime.swift) into your project, or copy the contents of it where ever you like.
- Step 2: There is no step 2; you're ready to go.

**Note: If you use the latest version of ShowTime without switching to [`1.0.1`](https://github.com/KaneCheshire/ShowTime/tree/1.0.1) you'll end up with the Swift 4 version and will have to enable it manually**

## Usage

ShowTime works pretty much out of the box, but you can customise it to turn it on or off (you could use this to have a demo environment), change the colour and outline of the taps, and even choose whether to display the number of taps for multiple taps.

Here's a list of options:

```swift
// Defines when and if ShowTime is enabled.
//
// Possible values are:
// - .always
// - .never
// - .debugOnly
//
// `.never` by default,
// so set to `.always` or `.debugOnly`
// somewhere like your AppDelegate.
ShowTime.enabled: ShowTime.Enabled


// The fill (background) color of a visual touch.
// Twitter blue with 50% opacity by default.
ShowTime.fillColor: UIColor

// The colour of the stroke (outline) of a visual touch.
// Twitter blue by default.
ShowTime.strokeColor: UIColor

// The width (thickness) of the stroke around a visual touch.
// 3pt by default.
ShowTime.strokeWidth: CGFloat

// The size of a visual touch.
// 44x44pt by default.
ShowTime.size: CGSize

// The style of animation  to use when a visual touch disappears.
//
// Possible values are:
// - .standard (Slightly scaled down and faded out)
// - .scaleDown (Completely scaled down with no fade)
// - .scaleUp (Scaled up and faded out)
//
// `.standard` by default.
ShowTime.disappearAnimation: ShowTime.Animation

// The delay, in seconds, before the visual touch disappears after a touch ends.
// `0.1` by default.
ShowTime.disappearDelay: TimeInterval

// Whether visual touches should indicate a multiple tap (i.e. show a number 2 for a double tap).
// `false` by default.
ShowTime.shouldShowMultipleTapCount: Bool

// The colour of the text to use when showing multiple tap counts.
// `.black` by default.
ShowTime.multipleTapCountTextColor: UIColor

// Whether visual touches should visually show how much force is applied.
// `true` by default (show off that amazing tech!).
ShowTime.shouldShowForce: Bool

// Whether touch events from Apple Pencil are ignored.
// `true` by default.
ShowTime.shouldIgnoreApplePencilEvents: Bool

```

## How it works

ShowTime is a **one-size-fits-all** solution to showing your taps and gestures while showing off your hard work in demos and videos. ShowTime works with both conventional **single-window apps**, as well as **multi-window apps**.

To achieve this, ShowTime uses _method swizzling_. [Method swizzling](http://nshipster.com/swift-objc-runtime/) is only possible with the Objective-C runtime, so will only work with Swift types that inherit from `NSObject`. That's okay, because `UIWindow` does inherit from `NSObject`, so ShowTime can hook into the `initialize()` method and do some swizzlin'. (In Swift 4, `initialize()` is no longer allowed to be used so you must enable ShowTime manually)

Swizzling is just a friendly term used for swapping out the default implementation of a method and replacing it with your own (which calls the default implementation, a bit like calling a `super` implementation of a `class`), so that you have more control over what happens with that method without having to subclass. The benefit – but also danger – of this is that **_all_** objects instantiated will use the new implementation, so swizzling should be used wisely and sparingly, especially in production code.

ShowTime swizzles the `sendEvent(_:)` method on `UIWindow`, intercepts the event and then lets `UIWindow` carry on with sending the event. By intercepting that event and extracting the `UITouch`es out of it, ShowTime displays those touches visually on whatever window is receiving `sendEvent(_:)`.

## Useful info

### Can I use this in production?
Yes, I've never seen any weird crashes but it's never been stress tested, so to do so is at your own risk.

### Why do I need to enable ShowTime now?
In Swift 3, it was possible to automatically swizzle `UIWindow` without doing anything at start up. In Swift 4 that ability was removed which means one extra step is needed to kick off the swizzling to enable ShowTime. I figured the best place to do this is when you actually set ShowTime to be enabled, so as soon as you set `ShowTime.enabled` to either `.always` or  `.debugOnly`, ShowTime will do a one-time swizzle of `UIWindow` under the hood. 

### Why would I want to show the number of multiple taps?
The thing to remember here is that people watching a demo of your app don't know exactly what your fingers are doing, which is why ShowTime exists.

Double tapping makes sense if you're watching someone's hands, but often this can be easily missed if you're watching it on a screen. Showing the number of multiple taps by setting `ShowTime.shouldShowMultipleTapCount` to `true` shows a number inside the tap itself, clearly demonstrating to your audience that you just tapped twice (or more) in succession in the same place.

### Can I have a different colour tap per-screen rather than per-app?
This is possible, you'd just need to set the colour in `viewDidLoad` or `viewDidAppear(_:)` in the screens you want to change the colour of the taps on. It adds a small layer of complexity, but certainly possible.

## Author

Kane Cheshire, @KaneCheshire

## License

ShowTime is available under the MIT license. See the LICENSE file for more info.
