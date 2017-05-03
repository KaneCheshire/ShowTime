# It's ShowTime 🎥

ShowTime displays all your taps and gestures on screen, perfect for that demo, presentation or video.

One file is all you need to turbo-boost your demos. ShowTime even **displays the level of force you're applying**, and can be configured to show the **actual number of taps performed**. Apple Pencil events are configurable and disabled by default.

ShowTime works with **single- and multi-window setups**, check out **[How it works](#how-it-works)**.

ShowTime works best when mirroring your screen or recording through QuickTime. By default the size of the visual touches are 44pt; this mirrors Apple's guidelines for minimim hit size for buttons on iOS. You're free to change this, of course!

Showing your gestures during demos helps give your audience a much clearer context on what's happening on your device. Consider trying ShowTime for your next demo!

![ShowTime](http://kanecheshire.com/images/github/showtime-demo-4.gif)

## Installation

There are two very easy ways to integrate ShowTime.

Using Cocoapods? Simply add the following to your podfile:
```ruby
pod 'ShowTime'
```
Update your pods with `pod update`, and that's it. You don't even have to `import ShowTime` into a file in your project, unless you want to change the defaults.

If you're not using Cocoapods:
- Step 1: Drop `ShowTime.swift` into your project or copy the contents of it where ever you like.
- Step 2: There is no step 2; you're ready to go.

**NOTE** If you're using Xcode 8.3.2 or newer you may get a warning about `initialize()` being unavailable in future versions of Swift. When this is removed by Apple, I have a decent workaround ready to implement, but may mean an extra step in the setup process.

## Usage

ShowTime works out of the box, but you can customise it to turn it on or off (you could use this to have a demo environment), change the colour and outline of the taps, and even choose whether to display the number of taps for multiple taps.

Here's a list of options:

```swift
// Defines when and if ShowTime is enabled
//
// Possible values are:
// - .always
// - .never
// - .debugOnly
//
// .always by default
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
ShowTime.shouldIgnoreApplePencilEvents

```

## <a name='how-it-works'></a>How it works

ShowTime is a **one-size-fits-all** solution to showing your taps and gestures while showing off your hard work in demos and videos. ShowTime works with both conventional **single-window apps**, as well as **multi-window apps**.

To achieve this, ShowTime uses _method swizzling_. [Method swizzling](http://nshipster.com/swift-objc-runtime/) is only possible with the Objective-C runtime, so will only work with Swift types that inherit from `NSObject`. That's okay, because `UIWindow` does inherit from `NSObject`, so ShowTime can hook into the `initialize()` method and do some swizzlin'.

Swizzling is just a friendly term used for swapping out the default implementation of a method and replacing it with your own (which calls the default implementation, a bit like calling a `super` implementation of a `class`), so that you have more control over what happens with that method without having to subclass. The benefit – but also danger – of this is that **_all_** objects instantiated will use the new implementation, so swizzling should be used wisely and sparingly, especially in production code.

ShowTime swizzles the `sendEvent(_:)` method on `UIWindow`, intercepts the event and then lets `UIWindow` carry on with sending the event. By intercepting that event and extracting the `UITouch`es out of it, ShowTime displays those touches visually on whatever window is receiving `sendEvent(_:)`.

## Useful info

### Can I use this in production?
In theory, yes. You could easily set up  a configuration that disables ShowTime by setting `ShowTime.itsShowTime` to `false` (check out [configen](https://github.com/theappbusiness/ConfigGenerator) for easily having different configrations based on Xcode schemes), however ShowTime is new and hasn't been stress tested, so do so at your own risk.

What I would suggest doing instead, is having a `demo` branch that you have `ShowTime` installed in, and merge your changes into that branch whenever you want to demo something. Because there is so little setup to `ShowTime`, you should rarely get any conflicts.

### Is there really only one step to installing ShowTime?
Yes! Thanks to method Swizzling and Swift extensions all you have to do is include the code somewhere in your project. ShowTime works out of the box, but is quite customizable.

### Why would I want to show the number of multiple taps?
The thing to remember here is that people watching a demo of your app don't know exactly what your fingers are doing, which is why ShowTime exists.

Double tapping makes sense if you're watching someone's hands, but often this can be easily missed if you're watching it on a screen. Showing the number of multiple taps by setting `ShowTime.shouldShowMultipleTapCount` to `true` shows a number inside the tap itself, clearly demonstrating to your audience that you just tapped twice (or more) in succession in the same place.




### Can I have a different colour tap per-screen rather than per-app?
This is possible, you'd just need to set the colour in `viewDidLoad` or `viewDidAppear(_:)` in the screens you want to change the colour of the taps on. It adds a small layer of complexity, but certainly possible.
