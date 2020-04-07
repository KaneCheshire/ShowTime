[![CI Status](http://img.shields.io/travis/KaneCheshire/ShowTime.svg?style=flat)](https://travis-ci.org/KaneCheshire/ShowTime)
[![Version](https://img.shields.io/cocoapods/v/ShowTime.svg?style=flat)](http://cocoapods.org/pods/ShowTime)
[![License](https://img.shields.io/cocoapods/l/ShowTime.svg?style=flat)](http://cocoapods.org/pods/ShowTime)
[![Platform](https://img.shields.io/cocoapods/p/ShowTime.svg?style=flat)](http://cocoapods.org/pods/ShowTime)
[![Awesome](https://cdn.rawgit.com/sindresorhus/awesome/d7305f38d29fed78fa85652e3a63e154dd8e8829/media/badge.svg)](https://github.com/matteocrippa/awesome-swift)

# It's ShowTime 🎥

- [Installation](#installation)
    - [Cocoapods](#cocoapods)
    - [Manual](#manual)
- [Usage](#usage)
- [How it works](#how-it-works)
- [Useful info](#useful-info)
- [Author](#author)
- [License](#license)

ShowTime is the simplest and best way to display all your taps and gestures on screen. Perfect for that demo, presentation or video.

One file (or pod install) is all you need to add that extra polish your demos. ShowTime even **displays the level of force you're applying**, and can be configured to show the **actual number of taps performed**. Apple Pencil events are configurable and disabled by default.

ShowTime works as soon as your app runs with no setup required, but is also highly configurable if you don't like the defaults.

ShowTime works with **single- and multi-window setups**, as well as in **iOS widgets**, and works with any Swift or Objective-C project.

Check out **[How it works](#how-it-works)**.

It takes less than a minute to install ShowTime, consider using it when you're sharing or recording your screen through QuickTime or AirPlay.

By default, the size of the visual touches are 44pt; this mirrors Apple's guidelines for minimum hit size for buttons on iOS. You're free to change this, of course!

Showing your gestures during demos gives your audience a much clearer context on what's happening on your device. Try ShowTime for your next demo, it's insanely easy to set up!

**ADDED BONUS:** Adding ShowTime as a pod to your app in debug mode will show taps
and gestures in your XCUI automation tests while the tests run!

![ShowTime](http://kanecheshire.com/images/github/showtime-demo-4.gif)

## Installation

### Cocoapods

- Step 1: Add `pod 'ShowTime'` to your Podfile and run `pod update` in Terminal.
- Step 2: There is no step 2, ShowTime works as soon as you launch your app, but you can [configure](#usage) it if you wish!

### Manual

- Step 1: Drop [`ShowTime.swift`](https://raw.githubusercontent.com/KaneCheshire/ShowTime/master/Sources/ShowTime/ShowTime.swift) into your project or copy the contents of it where ever you like.

### Swift Package Manager

- Step 1: In Xcode 11+, add `https://github.com/KaneCheshire/ShowTime.git` to the list of Swift Package dependencies, [see here](https://developer.apple.com/documentation/xcode/adding_package_dependencies_to_your_app) for more information.
- Step 2: There is no step 2, ShowTime works as soon as you launch your app, but you can [configure](#usage) it if you wish!

## Usage

ShowTime works out of the box (you don't even need to import the framework anywhere), but you can customise it to turn it on or off, change the colour of the taps, and even choose whether to display the number of taps for multiple taps.

There's lots of options to play with which helps ShowTime work with your app's character during demos.

Here's a list of options:

```swift
// Defines when and if ShowTime is enabled.
//
// Possible values are:
// - .always
// - .never
// - .debugOnly
//
// `.always` by default,
ShowTime.enabled: ShowTime.Enabled


// The fill (background) color of a visual touch.
// When set to `.auto`, ShowTime automatically uses the stroke color with a 50% alpha.
// This makes it super quick to change ShowTime to fit in better with your brand.
// `.auto` by default.
ShowTime.fillColor: UIColor

// The colour of the stroke (outline) of a visual touch.
// "Twitter blue" by default.
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
// - .custom (Provide your own custom animation block)
//
// `.standard` by default.
ShowTime.disappearAnimation: ShowTime.Animation

// The delay, in seconds, before the visual touch disappears after a touch ends.
// `0.2` by default.
ShowTime.disappearDelay: TimeInterval

// Whether visual touches should indicate a multiple tap (i.e. show a number 2 for a double tap).
// `false` by default.
ShowTime.shouldShowMultipleTapCount: Bool

// The colour of the text to use when showing multiple tap counts.
// `.black` by default.
ShowTime.multipleTapCountTextColor: UIColor

// The font of the text to use when showing multiple tap counts.
// `.systemFont(ofSize: 17, weight: .bold)` by default.
ShowTime.multipleTapCountTextFont: UIFont

// Whether visual touches should visually show how much force is applied.
// `true` by default (show off that amazing tech!).
ShowTime.shouldShowForce: Bool

// Whether touch events from Apple Pencil are ignored.
// `true` by default.
ShowTime.shouldIgnoreApplePencilEvents: Bool

```

## How it works

ShowTime is a **one-size-fits-all** solution to showing your taps and gestures while showing off your hard work in demos and videos. ShowTime works with both conventional **single-window apps**, as well as **multi-window apps**.

To achieve this, ShowTime uses _method swizzling_. [Method swizzling](http://nshipster.com/swift-objc-runtime/) is only possible with the Objective-C runtime, so will only work with Swift types that inherit from `NSObject`. That's okay, because `UIWindow` does inherit from `NSObject`, so ShowTime can swizzle the `sendEvent(_:)` method.

Swizzling is just a friendly term used for swapping out the default implementation of a method and replacing it with your own (which calls the default implementation, a bit like calling a `super` implementation of a `class`), so that you have more control over what happens with that method without having to subclass. The benefit – but also danger – of this is that **_all_** objects instantiated will use the new implementation, so swizzling should be used wisely and sparingly, especially in production code.

ShowTime swizzles the `sendEvent(_:)` method on `UIWindow`, intercepts the event and then lets `UIWindow` carry on with sending the event. By intercepting that event and extracting the `UITouch`es out of it, ShowTime displays those touches visually on whatever window is receiving `sendEvent(_:)`.

## Useful info

### Why don't I need to import ShowTime to get it to work?
ShowTime automatically swizzles functions which doesn't require the framework to be imported with `import ShowTime`, so after install the cocoapod, ShowTime is automagically enabled. The only time you'll need to import the framework is if you want to play around with the configuration.

### Can I use this in production?
Yes, I've never seen any weird crashes but it's never been stress tested, so to do so is at your own risk.

### Why would I want to show the number of multiple taps?
People watching a demo of your app don't know exactly what your fingers are doing, so showing how many times you've tapped on a specific part of the screen really helps people understand the gestures you're carrying out.

Double tapping makes sense if you're watching someone's hands, but often this can be easily missed if you're watching it on a screen. Showing the number of multiple taps by setting `ShowTime.shouldShowMultipleTapCount` to `true` shows a number inside the tap itself, clearly demonstrating to your audience that you just tapped twice (or more) in succession in the same place.

### Why don't Apple Pencil events show by default?
I'm guessing that most of the time, if you're demoing using an Apple Pencil then you're demoing drawing or something similar, so you wouldn't want a touch to display at that location. You can easily disable this behaviour if you need touch events to show for Apple Pencil interactions.

### Can I have a different colour tap per-screen rather than per-app?
This is possible, you'd just need to set the colour in `viewDidLoad` or `viewDidAppear(_:)` in the screens you want to change the colour of the taps on. It adds a small layer of complexity, but certainly possible.

## Author

Kane Cheshire, @KaneCheshire

## License

ShowTime is available under the MIT license. See the LICENSE file for more info.
