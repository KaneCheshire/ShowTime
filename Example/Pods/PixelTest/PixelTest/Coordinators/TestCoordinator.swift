//
//  TestCoordinator.swift
//  PixelTest
//
//  Created by Kane Cheshire on 16/04/2018.
//

import XCTest

/// Coordinates testing.
struct TestCoordinator: TestCoordinatorType {
    
    // MARK: - Properties -
    // MARK: Private
    
    private let fileCoordinator: FileCoordinatorType
    
    // MARK: - Initializers -
    // MARK: Internal
    
    init(fileCoordinator: FileCoordinatorType = FileCoordinator()) {
        self.fileCoordinator = fileCoordinator
    }
    
    // MARK: - Functions -
    // MARK: Internal
    
    /// Records a snapshot of a view and writes it to disk.
    ///
    /// - Parameters:
    ///   - view: The view to record.
    ///   - layoutStyle: The layout style to use to lay out the view.
    ///   - scale: The scale to use when creating an image of the view.
    ///   - testCase: The test case requesting the recording.
    ///   - function: The function called when requesting the recording.
    /// - Returns: A result with either an image for success or failure message.
    func record(_ view: UIView,
                layoutStyle: LayoutStyle,
                scale: Scale,
                testCase: PixelTestCase,
                function: StaticString) -> Result<UIImage, String> {
        guard let url = fileCoordinator.fileURL(for: testCase, forFunction: function, scale: scale, imageType: .reference, layoutStyle: layoutStyle) else {
            return .fail("Unable to get URL")
        }
        guard let image = view.image(withScale: scale) else {
            return .fail("Unable to create snapshot")
        }
        guard let data = UIImagePNGRepresentation(image) else {
            return .fail("Unable to create image data")
        }
        do {
            try fileCoordinator.write(data, to: url)
            return .success(image)
        } catch {
            return .fail("Unable to write image data to disk")
        }
    }
    
    /// Tests a snapshot of a view, assuming a previously recorded snapshot exists for comparison.
    ///
    /// - Parameters:
    ///   - view: The view to test.
    ///   - layoutStyle: The layout style to use to lay out the view.
    ///   - scale: The scale to use when creating an image of the view.
    ///   - testCase: The test case requesting the test.
    ///   - function: The function called when requesting the test.
    /// - Returns: A result with an image for success, or message with failed images for failure.
    func test(_ view: UIView,
              layoutStyle: LayoutStyle,
              scale: Scale,
              testCase: PixelTestCase,
              function: StaticString) -> Result<UIImage, (oracle: UIImage?, test: UIImage?, message: String)> {
        guard let url = fileCoordinator.fileURL(for: testCase, forFunction: function, scale: scale, imageType: .reference, layoutStyle: layoutStyle) else {
            return .fail((nil, nil, "Unable to get URL"))
        }
        guard let testImage = view.image(withScale: scale) else {
            return .fail((nil, nil, "Unable to create snapshot"))
        }
        guard let data = try? fileCoordinator.data(at: url) else {
            return .fail((nil, nil, "Unable to get recorded image data"))
        }
        guard let recordedImage = UIImage(data: data, scale: scale.explicitOrScreenNativeValue) else {
            return .fail((nil, nil, "Unable to get recorded image"))
        }
        if !testImage.equalTo(recordedImage) {
            return .fail((recordedImage, testImage, "Snapshot test failed, images are different"))
        } else {
            return .success(testImage)
        }
    }
    
}
