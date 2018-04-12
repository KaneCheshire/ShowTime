//
//  PixelTestCase.swift
//  PixelTest
//
//  Created by Kane Cheshire on 13/09/2017.
//  Copyright © 2017 Kane Cheshire. All rights reserved.
//

import UIKit
import XCTest
import xcproj
import PathKit

/// Subclass `PixelTestCase` after `import PixelTest`
open class PixelTestCase: XCTestCase {
    
    /// Represents an error that could occur specific to `PixelTestCase`.
    ///
    /// - viewHasNoWidth: The view provided has no width so cannot be verified.
    /// - viewHasNoHeight: The view provided has no height so canot be verified.
    /// - unableToCreateImage: The test case was unable to create an image for recording or testing.
    /// - noKeyWindow: The tests were unable to find a key window for the shared application, which is needed for snapshotting.
    /// - unableToCreateFileURL: The tests were unable to create a file URL required for testing.
    public enum Error: Swift.Error {
        case viewHasNoWidth
        case viewHasNoHeight
        case unableToCreateImage
        case unableToCreateFileURL
    }
    
    // MARK: - Properties -
    // MARK: Public
    
    public var mode: Mode = .test
    
    // MARK: - Functions -
    // MARK: Public
    
    /// Verifies a view.
    /// If this is called while in record mode, a new snapshot are recorded, overwriting any existing recorded snapshot.
    /// If this is called while in test mode, a new snapshot is created and compared to a previously recorded snapshot.
    /// If tests fail while in test mode, a failure and diff image are stored locally, which you can find in the same directory as the snapshot recording. This should show up in your git changes.
    /// If tests succeed after diffs and failures have been stored, PixelTest will automatically remove them so you don't have to clear them from git yourself.
    ///
    /// - Parameters:
    ///   - view: The view to verify.
    ///   - layoutStyle: The layout style to verify the view with.
    ///   - scale: The scale to record/test the snapshot with.
    public func verify(_ view: UIView, layoutStyle: LayoutStyle, scale: Scale = .native, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) throws {
        layOut(view, with: layoutStyle)
        guard view.bounds.width != 0 else { throw Error.viewHasNoWidth }
        guard view.bounds.height != 0 else { throw Error.viewHasNoHeight }
        switch mode {
        case .record: try record(view, scale: scale, file: file, function: function, line: line, layoutStyle: layoutStyle)
        case .test: try test(view, scale: scale, file: file, function: function, line: line, layoutStyle: layoutStyle)
        }
    }
    
}


extension PixelTestCase {
    
    // MARK: Internal
    
    func fileURL(forFunction function: StaticString, scale: Scale, imageType: ImageType, layoutStyle: LayoutStyle, fileManager: FileManagerType = FileManager.default) throws -> URL {
        let baseDirectory = baseDirectoryURL(with: imageType)
        try createBaseDirectoryIfNecessary(baseDirectory, fileManager: fileManager)
        return fullFileURL(withBaseDirectoryURL: baseDirectory, function: function, scale: scale, layoutStyle: layoutStyle)
    }
    
    // MARK: Private
    
    private func layOut(_ view: UIView, with layoutStyle: LayoutStyle) {
        view.translatesAutoresizingMaskIntoConstraints = false
        switch layoutStyle {
        case .dynamicHeight(fixedWidth: let width):
            view.widthAnchor.constraint(equalToConstant: width).isActive = true
        case .dynamicWidth(fixedHeight: let height):
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
        case .fixed(width: let width, height: let height):
            view.widthAnchor.constraint(equalToConstant: width).isActive = true
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
        case .dynamicWidthHeight: break
        }
        embed(view)
    }
    
    private func embed(_ view: UIView) {
        let parentView = UIView()
        parentView.translatesAutoresizingMaskIntoConstraints = false
        parentView.addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: parentView.topAnchor),
            view.leftAnchor.constraint(equalTo: parentView.leftAnchor),
            view.rightAnchor.constraint(equalTo: parentView.rightAnchor),
            view.bottomAnchor.constraint(equalTo: parentView.bottomAnchor),
            ])
        parentView.setNeedsLayout()
        parentView.layoutIfNeeded()
    }
    
    private func record(_ view: UIView, scale: Scale, file: StaticString, function: StaticString, line: UInt, layoutStyle: LayoutStyle) throws {
        let url = try fileURL(forFunction: function, scale: scale, imageType: .reference, layoutStyle: layoutStyle)
        guard let image = view.image(withScale: scale), let data = UIImagePNGRepresentation(image) else { throw Error.unableToCreateImage }
        try data.write(to: url, options: .atomic)
        addAttachment(named: "Recorded image", image: image)
        XCTFail("Snapshot recorded (see recorded image in logs), disable record mode and re-run tests to verify.", file: file, line: line)
    }
    
    private func test(_ view: UIView, scale: Scale, file: StaticString, function: StaticString, line: UInt, layoutStyle: LayoutStyle) throws {
        let url = try fileURL(forFunction: function, scale: scale, imageType: .reference, layoutStyle: layoutStyle)
        guard let testImage = view.image(withScale: scale) else { throw Error.unableToCreateImage }
        let data = try Data(contentsOf: url, options: .uncached)
        let recordedImage = UIImage(data: data, scale: scale.explicitOrScreenNativeValue)!
        if !testImage.equalTo(recordedImage) {
            try storeDiffAndFailureImages(from: testImage, recordedImage: recordedImage, function: function, scale: scale, layoutStyle: layoutStyle)
            XCTFail("Snapshots do not match (see diff image in logs)", file: file, line: line)
        } else {
            removeDiffAndFailureImages(function: function, scale: scale, layoutStyle: layoutStyle)
        }
    }
    
    private func storeDiffAndFailureImages(from failedImage: UIImage, recordedImage: UIImage, function: StaticString, scale: Scale, layoutStyle: LayoutStyle) throws {
        if let diffImage = failedImage.diff(with: recordedImage), let url = try? fileURL(forFunction: function, scale: scale, imageType: .diff, layoutStyle: layoutStyle) {
            addAttachment(named: "Diff image", image: diffImage)
            let data = UIImagePNGRepresentation(diffImage)
            try data?.write(to: url, options: .atomic)
        }
        if let url = try? fileURL(forFunction: function, scale: scale, imageType: .failure, layoutStyle: layoutStyle) {
            addAttachment(named: "Failed image", image: failedImage)
            addAttachment(named: "Original image", image: recordedImage)
            let data = UIImagePNGRepresentation(failedImage)
            try data?.write(to: url, options: .atomic)
        }
    }
    
    private func addAttachment(named name: String, image: UIImage) {
        let attachment = XCTAttachment(image: image)
        attachment.name = name
        add(attachment)
    }
    
    private func removeDiffAndFailureImages(function: StaticString, scale: Scale, layoutStyle: LayoutStyle) {
        if let url = try? fileURL(forFunction: function, scale: scale, imageType: .diff, layoutStyle: layoutStyle) {
            try? FileManager.default.removeItem(at: url)
        }
        if let url = try? fileURL(forFunction: function, scale: scale, imageType: .failure, layoutStyle: layoutStyle) {
            try? FileManager.default.removeItem(at: url)
        }
    }
    
    private func baseDirectoryURL(with imageType: ImageType) -> URL {
        guard let baseURL = targetBaseDirectory() else { fatalError("Could not find base URL for test target") }
        let typeComponents = String(reflecting: type(of: self)).components(separatedBy: ".")
        let className = typeComponents[safe: 1] ?? "Unknown"
        return baseURL.appendingPathComponent("\(moduleName())Snapshots").appendingPathComponent(imageType.rawValue).appendingPathComponent(className)
    }
    
    private func createBaseDirectoryIfNecessary(_ baseDirectoryURL: URL, fileManager: FileManagerType = FileManager.default) throws {
        guard !fileManager.fileExists(atPath: baseDirectoryURL.absoluteString) else { return }
        try fileManager.createDirectory(at: baseDirectoryURL, withIntermediateDirectories: true, attributes: nil)
    }
    
    private func fullFileURL(withBaseDirectoryURL baseDirectoryURL: URL, function: StaticString, scale: Scale, layoutStyle: LayoutStyle) -> URL {
        var functionWithParenthesisRemoved = "\(function)".trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if let range = functionWithParenthesisRemoved.range(of: "test_") {
            functionWithParenthesisRemoved.removeSubrange(range)
        } else if let range = functionWithParenthesisRemoved.range(of: "test") {
            functionWithParenthesisRemoved.removeSubrange(range)
        }
        return baseDirectoryURL.appendingPathComponent("\(functionWithParenthesisRemoved)_\(layoutStyle.fileValue)@\(scale.explicitOrScreenNativeValue)x.png")
    }
    
    private func targetBaseDirectory() -> URL? {
        guard let baseDirectory = ProcessInfo.processInfo.environment["PIXELTEST_BASE_DIR"] else { fatalError("Please set `PIXELTEST_BASE_DIR` as an environment variable") }
        guard let enumerator = FileManager.default.enumerator(atPath: baseDirectory) else { return nil }
        for fileOrDir in enumerator  {
            guard let fileOrDir = fileOrDir as? String else { continue }
            guard fileOrDir.contains(".xcodeproj") else { continue }
            let projectPath = "\(baseDirectory)/\(fileOrDir)"
            guard let project = try? XcodeProj(path: Path(projectPath)) else { continue }
            let targets = project.pbxproj.objects.nativeTargets.map { $0.value.name }
            guard targets.contains(moduleName()) else { continue }
            return URL(fileURLWithPath: projectPath).deletingLastPathComponent()
        }
        return nil
    }
    
    private func moduleName() -> String {
        let typeComponents = String(reflecting: type(of: self)).components(separatedBy: ".")
        return typeComponents[safe: 0] ?? "Unknown"
    }
    
}
