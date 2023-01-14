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
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("ShowTime works with SwiftUI and UIKit, you don't even need to import ShowTime if you're happy with the default options!")
                    .bold()
                Divider()
                VStack(alignment: .leading) {
                    Row(title: "Enabled", description: "When and if ShowTime is enabled.") {
                        Menu("\(enabled.stringValue)") {
                            ForEach(ShowTime.Enabled.allCases, id: \.self) { enabled in
                                Button(enabled.stringValue) { ShowTime.enabled = enabled }
                            }
                        }
                    }
                    
                    Row(title: "Animation", description: "The animation to perform to hide touch indicators.") {
                        Menu("\(disappearAnimation.stringValue)") {
                            ForEach(Animation.allCases, id: \.self) { animation in
                                Button(animation.stringValue) { ShowTime.disappearAnimation = animation.mapped }
                            }
                        }
                    }
                    
                    Row(title: "Animation delay", description: "The delay until the disappearing animation is performed.") {
                        Picker("\(disappearDelay)", selection: $disappearDelay) {
                            ForEach([0.1, 0.2, 0.5, 1.0], id: \.self) {
                                Text("\($0)")
                            }
                        }
                    }
                    
                    Row(title: "Stroke color", description: "The color of the stroke around touch indicators.") {
                        ColorPicker("", selection: $strokeColor, supportsOpacity: true)
                    }
                    
                    Row(title: "Stroke width", description: "The width of the stroke around touch indicators.") {
                        Picker("\(strokeWidth)", selection: $strokeWidth) {
                            ForEach(0 ..< 51) {
                                Text("\($0)")
                            }
                        }
                    }
                    
                    Row(title: UIColor(cgColor: fillColor) == .auto ? "Fill color (auto)" : "Fill color (explicit)", description: "The fill color of touch indicators. When set to .auto (the default) then the fill color is dervied from the stroke color.") {
                        ColorPicker("", selection: $fillColor, supportsOpacity: true)
                    }
                    
                    Row(title: "Size", description: "The size of touch indicators.") {
                        Picker("\(size)", selection: $size) {
                            ForEach(1 ..< 101) {
                                Text("\($0)").tag($0)
                            }
                        }
                    }
                    
                    Row(title: "Multiple tap count", description: "Whether the number of taps is shown in touch indicators when tapping multiple times in one place (like a double tap).") {
                        Toggle(isOn: $showMultipleTapCount) {
                            Text("")
                        }
                    }
                    
                    Row(title: "Multiple tap text color", description: "The text color of the text to use when multiple taps is shown.") {
                        ColorPicker("", selection: $multipleTapCountTextColor, supportsOpacity: true)
                    }
                    
                    Row(title: "Ignore Apple Pencil events", description: "Whether touch indicators should be hidden for Apple Pencil events.") {
                        Toggle(isOn: $ignoreApplePencilEvents) { Text("") }
                    }
                }
            }
        }
        .padding()
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
