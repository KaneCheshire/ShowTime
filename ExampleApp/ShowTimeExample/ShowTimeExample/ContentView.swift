//
//  ContentView.swift
//  ShowTimeExample
//
//  Created by Kane Cheshire on 14/01/2023.
//

import SwiftUI
import ShowTime

// ShowTime automatically works with SwiftUI, even in in previews :)
// Of course, ShowTime also works with UIKit automatically as well.
// You don't even need to `import ShowTime` to get going, but if you want to
// change any options you can just `import ShowTime` and have some fun with it.

private let numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 2
    return formatter
}()

struct ContentView: View {
    @State
    private var enabled: ShowTime.Enabled = ShowTime.enabled
    @State
    private var disappearAnimation: Animation = .init(ShowTime.disappearAnimation)
    @State
    private var disappearDelay: Double = ShowTime.disappearDelay
    @State
    private var strokeColor: CGColor = ShowTime.strokeColor.cgColor
    @State
    private var strokeWidth: CGFloat = ShowTime.strokeWidth
    @State
    private var fillColor: CGColor = ShowTime.fillColor.cgColor
    @State
    private var size: CGFloat = ShowTime.size.width
    @State
    private var showMultipleTapCount: Bool = ShowTime.shouldShowMultipleTapCount
    @State
    private var multipleTapCountTextColor: CGColor = ShowTime.multipleTapCountTextColor.cgColor
    @State
    private var ignoreApplePencilEvents: Bool = ShowTime.shouldIgnoreApplePencilEvents
    @State
    private var copied: Bool = false
    @State
    private var workItem: DispatchWorkItem? {
        willSet {
            workItem?.cancel()
        }
    }
    
    var body: some View {
        ScrollView {
            Text("ShowTime works with SwiftUI and UIKit, you don't even need to import ShowTime if you're happy with the default options!")
                .bold()
            VStack(alignment: .leading) {
                Row(
                    title: "Enabled",
                    description: "When and if ShowTime is enabled.",
                    codeExample: "ShowTime.enabled = \(enabled.stringValue)"
                ) {
                    Picker("\(enabled.stringValue)", selection: $enabled) {
                        ForEach(ShowTime.Enabled.allCases, id: \.self) { enabled in
                            Button(enabled.stringValue) { self.enabled = enabled }
                        }
                    }
                }

                Row(
                    title: "Animation",
                    description: "The animation to perform to hide touch indicators.",
                    codeExample: "ShowTime.animation = \(disappearAnimation.stringValue)"
                ) {
                    Picker("\(disappearAnimation.stringValue)", selection: $disappearAnimation) {
                        ForEach(Animation.allCases, id: \.self) { animation in
                            Button(animation.stringValue) { disappearAnimation = animation }
                        }
                    }
                }

                Row(
                    title: "Animation delay",
                    description: "The delay until the disappearing animation is performed.",
                    codeExample: "ShowTime.disappearDelay = \(numberFormatter.string(from: disappearDelay as NSNumber)!)"
                ) {
                    VStack(alignment: .trailing) {
                        Text(disappearDelay, format: .number)
                        Stepper("\(disappearDelay)", value: $disappearDelay, in: 0 ... 10, step: 0.1)
                    }
                }

                Row(
                    title: "Stroke color",
                    description: "The color of the stroke around touch indicators.",
                    codeExample: "ShowTime.strokeColor = \(strokeColor.uicolorCodeExample)"
                ) {
                    ColorPicker("", selection: $strokeColor, supportsOpacity: true)
                }

                Row(
                    title: "Stroke width",
                    description: "The width of the stroke around touch indicators.",
                    codeExample: "ShowTime.strokeWidth = \(numberFormatter.string(from: strokeWidth as NSNumber)!)"
                ) {
                    VStack(alignment: .trailing) {
                        Text(strokeWidth, format: .number)
                        Stepper("\(strokeWidth)", value: $strokeWidth, in: 0 ... 100, step: 1)
                    }
                }

                Row(
                    title: UIColor(cgColor: fillColor) == .auto ? "Fill color (auto)" : "Fill color (explicit)",
                    description: "The fill color of touch indicators. When set to .auto (the default) then the fill color is dervied from the stroke color.",
                    codeExample: "ShowTime.fillColor = \(fillColor.uicolorCodeExample)"
                ) {
                    ColorPicker("", selection: $fillColor, supportsOpacity: true)
                }

                Row(
                    title: "Size",
                    description: "The size of touch indicators.",
                    codeExample: "ShowTime.size = CGSize(width: \(Int(size)), height: \(Int(size)))"
                ) {
                    VStack(alignment: .trailing) {
                        Text(size, format: .number)
                        Stepper("\(size)", value: $size, in: 0 ... 100, step: 1)
                    }
                }

                Row(
                    title: "Multiple tap count",
                    description: "Whether the number of taps is shown in touch indicators when tapping multiple times in one place (like a double tap).",
                    codeExample: "ShowTime.shouldShowMultipleTapCount = \(showMultipleTapCount)"
                ) {
                    Toggle(isOn: $showMultipleTapCount) {
                        Text("")
                    }
                }

                Row(
                    title: "Multiple tap text color",
                    description: "The text color of the text to use when multiple taps is shown.",
                    codeExample: "ShowTime.multipleTapCountTextColor = \(multipleTapCountTextColor.uicolorCodeExample)"
                ) {
                    ColorPicker("", selection: $multipleTapCountTextColor, supportsOpacity: true)
                }

                Row(
                    title: "Ignore Apple Pencil events",
                    description: "Whether touch indicators should be hidden for Apple Pencil events.",
                    codeExample: "ShowTime.shouldIgnoreApplePencilEvents = \(ignoreApplePencilEvents)"
                ) {
                    Toggle(isOn: $ignoreApplePencilEvents) { Text("") }
                }
            }
            .padding()
        }
        .onChange(of: enabled) { ShowTime.enabled = $0 }
        .onChange(of: disappearAnimation) { ShowTime.disappearAnimation = $0.mapped }
        .onChange(of: disappearDelay) { ShowTime.disappearDelay = $0 }
        .onChange(of: strokeColor) { ShowTime.strokeColor = UIColor(cgColor: $0) }
        .onChange(of: strokeWidth) { ShowTime.strokeWidth = $0 }
        .onChange(of: fillColor) { ShowTime.fillColor = UIColor(cgColor: $0) }
        .onChange(of: size) { ShowTime.size = .init(width: $0, height: $0) }
        .onChange(of: showMultipleTapCount) { ShowTime.shouldShowMultipleTapCount = $0 }
        .onChange(of: multipleTapCountTextColor) { ShowTime.multipleTapCountTextColor = UIColor(cgColor: $0) }
        .onChange(of: ignoreApplePencilEvents) { ShowTime.shouldIgnoreApplePencilEvents = $0 }
        .onReceive(NotificationCenter.default.publisher(for: .init("ShowTime.AddedToPasteboard"))) { _ in
            withAnimation {
                copied = true
            }
            let item = DispatchWorkItem {
                withAnimation {
                    copied = false
                }
            }
            workItem = item
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: item)
        }
        .overlay {
            Text("Copied to clipboard!")
                .frame(width: 200)
                .padding()
                .foregroundColor(Color.white)
                .background(Color.gray)
                .cornerRadius(16)
                .shadow(radius: 10)
                .opacity(copied ? 1 : 0)
        }
    }
}

private enum Animation: Hashable, CaseIterable {
    case standard, scaleDown, scaleUp
    
    var mapped: ShowTime.Animation {
        switch self {
        case .standard:
            return .standard
        case .scaleDown:
            return .scaleDown
        case .scaleUp:
            return .scaleUp
        }
    }
    
    var stringValue: String {
        switch self {
        case .standard: return ".standard"
        case .scaleDown: return ".scaleDown"
        case .scaleUp: return ".scaleUp"
        }
    }
    
    init(_ animation: ShowTime.Animation) {
        switch animation {
        case .standard, .custom: self = .standard
        case .scaleDown: self = .scaleDown
        case .scaleUp: self = .scaleUp
        }
    }
}

private extension ShowTime.Enabled {
    var stringValue: String {
        switch self {
        case .never: return ".never"
        case .always: return ".always"
        case .debugOnly: return ".debugOnly"
        }
    }
}

private extension CGColor {
    var rgba: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        let color = UIColor(cgColor: self)
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        let rP: UnsafeMutablePointer<CGFloat> = withUnsafeMutablePointer(to: &r) { $0 }
        let gP: UnsafeMutablePointer<CGFloat> = withUnsafeMutablePointer(to: &g) { $0 }
        let bP: UnsafeMutablePointer<CGFloat> = withUnsafeMutablePointer(to: &b) { $0 }
        let aP: UnsafeMutablePointer<CGFloat> = withUnsafeMutablePointer(to: &a) { $0 }

        assert(color.getRed(rP, green: gP, blue: bP, alpha: aP))
        return (r, g, b, a)
    }
    
    var uicolorCodeExample: String {
        let color = UIColor(cgColor: self)
        if color == .auto {
            return ".auto"
        } else {
            let computedRGBA = rgba
            let formattedR = numberFormatter.string(from: computedRGBA.r as NSNumber)!
            let formattedG = numberFormatter.string(from: computedRGBA.g as NSNumber)!
            let formattedB = numberFormatter.string(from: computedRGBA.b as NSNumber)!
            let formattedA = numberFormatter.string(from: computedRGBA.a as NSNumber)!
            return "UIColor(red: \(formattedR), green: \(formattedG), blue: \(formattedB), alpha: \(formattedA))"
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
