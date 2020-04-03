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
    
    // MARK: - Initializers -
    // MARK: Internal
    
    init(fileManager: FileManagerType = FileManager.default) {
        self.fileManager = fileManager
    }
    
    // MARK: - Functions -
    // MARK: Internal
    
    /// Attempts to create a full file URL.
    /// - Returns: A full file URL, or nil if a URL could not be created.
    func fileURL(for config: Config, imageType: ImageType) -> URL {
        let url = directoryURL(for: config, imageType: imageType)
        createDirectoryIfNecessary(url)
        return url.appendingPathComponent("\(config.layoutStyle.fileValue)@\(config.scale.explicitOrScreenNativeValue)x.png")
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
    func store(diffImage: UIImage, failedImage: UIImage, config: Config) {
        let diffUrl = fileURL(for: config, imageType: .diff)
        if let diffData = diffImage.pngData() {
            try? write(diffData, to: diffUrl)
        }
        let url = fileURL(for: config, imageType: .failure)
        if let failedData = failedImage.pngData() {
            try? write(failedData, to: url)
        }
    }
    
    /// Removes diff and failure images from disk (if they exist).
    func removeDiffAndFailureImages(config: Config) { // TODO: Delete test images for tests that no longer exist
        let diffURL = fileURL(for: config, imageType: .diff)
        try? fileManager.removeItem(at: diffURL)
        let failureUrl = fileURL(for: config, imageType: .failure)
        try? fileManager.removeItem(at: failureUrl)
    }
    
    /// Attempts to find the common path from a set of URLs.
    /// For example, the common path between these urls:
    ///
    /// `/a/b/c`
    /// `/a/b/c/d`
    /// `/a/b`
    ///
    /// Would return `"/a/b"`
    func commonPath(from urls: Set<URL>) -> String? {
        let allUniqueComponents = urls.map { $0.pathComponents }
        guard var smallestComponentsCount = allUniqueComponents.min(by: { $0.count < $1.count })?.count else { return nil }
        var unique = Set(allUniqueComponents.map { $0[..<smallestComponentsCount] })
        while unique.count > 1 {
            smallestComponentsCount -= 1
            unique = Set(unique.map { $0[..<smallestComponentsCount] })
        }
        guard var components = unique.first, let url = URL(string: components.removeFirst()) else { return nil }
        return components.reduce(into: url, { $0.appendPathComponent($1) }).path
    }
    
    // MARK: Private
    
    private func createDirectoryIfNecessary(_ url: URL) {
        guard !fileManager.fileExists(atPath: url.absoluteString) else { return }
        try? fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil) // TODO: Catch error somewhere?
    }
    
    private func directoryURL(for config: Config, imageType: ImageType) -> URL {
        let fullFileURL = URL(fileURLWithPath: "\(config.file)")
        var alphaNumericFunctionName = "\(config.function)".strippingNonAlphaNumerics
        alphaNumericFunctionName.remove(firstOccurenceOf: "test_")
        alphaNumericFunctionName.remove(firstOccurenceOf: "test")
        let directoryName = fullFileURL.deletingPathExtension().lastPathComponent
        return fullFileURL
            .deletingLastPathComponent()
            .appendingPathComponent(".pixeltest")
            .appendingPathComponent(directoryName)
            .appendingPathComponent(alphaNumericFunctionName)
            .appendingPathComponent(imageType.rawValue)
    }
    
}

private extension String {
    
    var strippingNonAlphaNumerics: String {
        return replacingOccurrences(of: "\\W+", with: "", options: .regularExpression)
    }
    
    mutating func remove(firstOccurenceOf string: String) {
        guard let range = range(of: string) else { return }
        return removeSubrange(range)
    }
    
}
