// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ShowTime",
    platforms: [.iOS("9.0")],
    products: [.library(name: "ShowTime", targets: ["ShowTime"])],
    targets: [.target(name: "ShowTime"), .testTarget(name: "ShowTimeTests", dependencies: ["ShowTime"])],
    swiftLanguageVersions: [.v5]
)
