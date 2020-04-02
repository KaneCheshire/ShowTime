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
    
    /// Tests a snapshot of a view, assuming a previously recorded snapshot exists for comparison.
    func test(_ view: UIView, config: Config) throws {
        guard let testImage = view.image(withScale: config.scale) else {
            throw Errors.Test.unableToCreateSnapshot
        }
        let referenceURL = fileCoordinator.fileURL(for: config, imageType: .reference)
        guard let data = try? fileCoordinator.data(at: referenceURL) else {
            throw Errors.Test.unableToGetRecordedImageData
        }
        guard let recordedImage = UIImage(data: data, scale: config.scale.explicitOrScreenNativeValue) else {
            throw Errors.Test.unableToGetRecordedImage
        }
        guard testImage.equalTo(recordedImage) else {
            throw Errors.Test.imagesAreDifferent(reference: recordedImage, failed: testImage)
        }
    }
    
}
