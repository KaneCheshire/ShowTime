//
//  PixelTestFileCoordinator.swift
//  PixelTest
//
//  Created by Kane Cheshire on 16/04/2018.
//

import Foundation

/// Coordinates manipulating files.
struct FileCoordinator: FileCoordinatorType {
    
    // MARK: - Properties -
    // MARK: Private
    
    private let fileManager: FileManagerType
    private let targetBaseDirectoryCoordinator: TargetBaseDirectoryCoordinatorType
    private let pixelTestBaseDirectory: String
    
    // MARK: - Initializers -
    // MARK: Internal
    
    init(fileManager: FileManagerType = FileManager.default,
         targetBaseDirectoryCoordinator: TargetBaseDirectoryCoordinatorType = TargetBaseDirectoryCoordinator(),
         pixelTestBaseDirectory: String = ProcessInfo.processInfo.environment["PIXELTEST_BASE_DIR"] ?? "") {
        self.fileManager = fileManager
        self.targetBaseDirectoryCoordinator = targetBaseDirectoryCoordinator
        self.pixelTestBaseDirectory = pixelTestBaseDirectory
    }
    
    // MARK: - Functions -
    // MARK: Internal
    
    /// Attempts to create a full file URL.
    /// Ensure PIXELTEST_BASE_DIR is set in your scheme before calling this function.
    ///
    /// - Parameters:
    ///   - testCase: The test case used to construct the file URL.
    ///   - function: The function used to construct the file URL.
    ///   - scale: The scale used to to construct the file URL.
    ///   - imageType: The image type used to construct the file URL.
    ///   - layoutStyle: The layout style used to construct the file URL.
    /// - Returns: A full file URL, or nil if a URL could not be created.
    func fileURL(for testCase: PixelTestCase,
                 forFunction function: StaticString,
                 scale: Scale,
                 imageType: ImageType,
                 layoutStyle: LayoutStyle) -> URL? {
        let baseDirectory = baseDirectoryURL(with: imageType, for: testCase)
        return fullFileURL(baseDirectory: baseDirectory, for: testCase, function: function, scale: scale, layoutStyle: layoutStyle)
    }
    
    /// Returns the base directory for a test case and specific image type, creating the directory if needed.
    ///
    /// - Parameters:
    ///   - imageType: The image type of the directory to return.
    ///   - testCase: The test case for the directory to return.
    /// - Returns: The base directory for the image type and test case.
    func baseDirectoryURL(with imageType: ImageType, for testCase: PixelTestCase) -> URL {
        let url = snapshotsDirectory(for: testCase.module).appendingPathComponent(imageType.rawValue).appendingPathComponent(testCase.className)
        createDirectoryIfNecessary(url)
        return url
    }
    
    /// Returns the directory snapshots are stored for the module.
    ///
    /// - Parameter module: The module whose snapshots directory you want to return.
    /// - Returns: The directory snapshots are stored for the module.
    func snapshotsDirectory(for module: Module) -> URL {
        guard !pixelTestBaseDirectory.isEmpty else {
            fatalError("Please set `PIXELTEST_BASE_DIR` as an environment variable. See README.md for more info.")
        }
        guard let baseURL = targetBaseDirectoryCoordinator.targetBaseDirectory(for: module, pixelTestBaseDirectory: pixelTestBaseDirectory) else {
            fatalError("Could not find base URL for test target")
        }
        return baseURL.appendingPathComponent("\(module.name)Snapshots")
    }
    
    /// Writes data to a file URL.
    ///
    /// - Parameters:
    ///   - data: The data to write.
    ///   - url: The file URL to write to.
    func write(_ data: Data, to url: URL) throws {
         try data.write(to: url, options: .atomic)
    }
    
    /// Reads the data at a file URL.
    ///
    /// - Parameter url: The file URL to read data from.
    /// - Returns: The data at the given URL.
    func data(at url: URL) throws -> Data {
        return try Data(contentsOf: url, options: .uncached)
    }
    
    /// Stores diff and failure images on-disk.
    ///
    /// - Parameters:
    ///   - diffImage: The diff image to store.
    ///   - failedImage: The failed image to store.
    ///   - pixelTestCase: The test case requesting the store.
    ///   - function: The function the images were created with.
    ///   - scale: The scale the images were created with.
    ///   - layoutStyle: The style of layout the images were created with.
    func storeDiffImage(_ diffImage: UIImage, failedImage: UIImage, for pixelTestCase: PixelTestCase, function: StaticString, scale: Scale, layoutStyle: LayoutStyle) {
        if let url = fileURL(for: pixelTestCase, forFunction: function, scale: scale, imageType: .diff, layoutStyle: layoutStyle), let data = UIImagePNGRepresentation(diffImage) {
            try? write(data, to: url)
        }
        if let url = fileURL(for: pixelTestCase, forFunction: function, scale: scale, imageType: .failure, layoutStyle: layoutStyle), let data = UIImagePNGRepresentation(failedImage) {
            try? write(data, to: url)
        }
    }
    
    /// Removes diff and failure images from disk (if they exist).
    ///
    /// - Parameters:
    ///   - pixelTestCase: The test case requesting the removal.
    ///   - function: The function the diff and failure images were originally for.
    ///   - scale: The scale the diff and failure images were originally created in.
    ///   - layoutStyle: The style of layout the images were created with.
    func removeDiffAndFailureImages(for pixelTestCase: PixelTestCase, function: StaticString, scale: Scale, layoutStyle: LayoutStyle) {
        if let url = fileURL(for: pixelTestCase, forFunction: function, scale: scale, imageType: .diff, layoutStyle: layoutStyle) {
            try? fileManager.removeItem(at: url)
        }
        if let url = fileURL(for: pixelTestCase, forFunction: function, scale: scale, imageType: .failure, layoutStyle: layoutStyle) {
            try? fileManager.removeItem(at: url)
        }
    }
    
    // MARK: Private
    
    private func fullFileURL(baseDirectory: URL, for testCase: PixelTestCase, function: StaticString, scale: Scale, layoutStyle: LayoutStyle) -> URL? {
        var functionWithParenthesisRemoved = "\(function)".trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        if let range = functionWithParenthesisRemoved.range(of: "test_") {
            functionWithParenthesisRemoved.removeSubrange(range)
        } else if let range = functionWithParenthesisRemoved.range(of: "test") {
            functionWithParenthesisRemoved.removeSubrange(range)
        }
        return baseDirectory.appendingPathComponent("\(functionWithParenthesisRemoved)_\(layoutStyle.fileValue)@\(scale.explicitOrScreenNativeValue)x.png")
    }
    
    private func createDirectoryIfNecessary(_ url: URL) {
        guard !fileManager.fileExists(atPath: url.absoluteString) else { return }
        try? fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    }
    
}
