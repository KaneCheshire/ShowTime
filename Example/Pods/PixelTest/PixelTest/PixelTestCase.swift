//
//  PixelTestCase.swift
//  PixelTest
//
//  Created by Kane Cheshire on 13/09/2017.
//  Copyright © 2017 Kane Cheshire. All rights reserved.
//

import UIKit
import XCTest

/// Subclass `PixelTestCase` after `import PixelTest`
open class PixelTestCase: XCTestCase {
    
    // MARK: - Properties -
    // MARK: Open
    
    /// The current mode of the test case. Set to `.record` when setting up or recording tests.
    /// If you have set a global override in the Xcode scheme, or in the test target's Info.plist, this value is ignored.
    ///
    /// To override this globally and re-record every test target (i.e. when moving to a new simulator or iOS version),
    /// simply add an environment variable to the Xcode scheme called `PTRecordAll` with a value of `YES`.
    ///
    /// To override this globally for an individual test target (i.e. when changing a theme), simply add
    /// an entry into the **test target's** Info.plist called `PTRecordAll`, type `Boolean ` with a value of `YES`.
    ///
    /// Defaults to `.test`, unless a global override is present.
    open var mode: Mode = .test
    
    // MARK: Internal
    
    private(set) var testError: Errors.Test?
    
    // MARK: Private
    
    private let resultsCoordinator: ResultsCoordinator = .shared
    private var layoutCoordinator: LayoutCoordinatorType = LayoutCoordinator()
    private var recordCoordinator: RecordCoordinatorType = RecordCoordinator()
    private var testCoordinator: TestCoordinatorType = TestCoordinator()
    private var fileCoordinator: FileCoordinatorType = FileCoordinator()
    private var verifyHasBeenCalled = false
    private var actualMode: Mode { return ProcessInfo.recordAll || testTargetInfoPlist.recordAll ? .record : mode }
    
    // MARK: - Init -
    // MARK: Internal
    
    convenience init(layoutCoordinator: LayoutCoordinatorType = LayoutCoordinator(), recordCoordinator: RecordCoordinatorType = RecordCoordinator(), testCoordinator: TestCoordinatorType = TestCoordinator(), fileCoordinator: FileCoordinatorType = FileCoordinator()) {
        self.init(selector: #selector(setUp))
        self.layoutCoordinator = layoutCoordinator
        self.recordCoordinator = recordCoordinator
        self.testCoordinator = testCoordinator
        self.fileCoordinator = fileCoordinator
    }
    
    // MARK: - Functions -
    // MARK: Open
    
    /// Verifies a view.
    /// If this is called while in record mode, a new snapshot are recorded, overwriting any existing recorded snapshot.
    /// If this is called while in test mode, a new snapshot is created and compared to a previously recorded snapshot.
    /// If tests fail while in test mode, a failure and diff image are stored locally, which you can find in the same directory as the snapshot recording. This should show up in your git changes.
    /// If tests succeed after diffs and failures have been stored, PixelTest will automatically remove them so you don't have to clear them from git yourself.
    ///
    /// You must call this at least once in your test function (although you can call it multiple times with different layout styles if you want).
    ///
    /// - Parameters:
    ///   - view: The view to verify.
    ///   - layoutStyle: The layout style to verify the view with.
    ///   - scale: The scale to record/test the snapshot with.
    open func verify(_ view: UIView, layoutStyle: LayoutStyle,
                     scale: Scale = .native, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        verifyHasBeenCalled = true
        layoutCoordinator.layOut(view, with: layoutStyle)
        XCTAssertTrue(view.bounds.width > 0, "View has no width after layout", file: file, line: line)
        XCTAssertTrue(view.bounds.height > 0, "View has no height after layout", file: file, line: line)
        let config = Config(function: function, file: file, line: line, scale: scale, layoutStyle: layoutStyle)
        switch actualMode {
            case .record: record(view, config: config)
            case .test: test(view, config: config)
        }
    }
    
}

extension PixelTestCase {
    
    open override func tearDown() {
        super.tearDown()
        if !verifyHasBeenCalled {
            XCTFail("`verify` was not called before tearDown, did you forget to add a call to`verify` a view?")
        }
    }
    
}

private extension PixelTestCase {
    
    func record(_ view: UIView, config: Config) {
        do {
            let image = try recordCoordinator.record(view, config: config)
            addAttachment(named: "Recorded image", image: image)
            fileCoordinator.removeDiffAndFailureImages(config: config)
            XCTFail("Snapshot recorded (see attached image in logs), disable record mode and re-run tests to verify.", file: config.file, line: config.line)
        } catch let error as Errors.Record {
            XCTFail(error.localizedDescription, file: config.file, line: config.line)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func test(_ view: UIView, config: Config) {
        do {
            try testCoordinator.test(view, config: config)
            fileCoordinator.removeDiffAndFailureImages(config: config)
        } catch let error as Errors.Test {
            handle(error, config: config)
        } catch {
            XCTFail("Unexpected error: \(error.localizedDescription)")
        }
    }
    
    func handle(_ error: Errors.Test, config: Config) {
        testError = error
        switch error {
            case .imagesAreDifferent(let referenceImage, let failedImage):
                storeDiffAndFailureImages(from: failedImage, recordedImage: referenceImage, config: config)
            case .unableToCreateSnapshot, .unableToGetRecordedImage, .unableToGetRecordedImageData: break
        }
        XCTFail(error.localizedDescription, file: config.file, line: config.line)
    }
    
    func storeDiffAndFailureImages(from failedImage: UIImage, recordedImage: UIImage, config: Config) {
        addAttachment(named: "Failed image", image: failedImage)
        addAttachment(named: "Original image", image: recordedImage)
        if let diffImage = failedImage.diff(with: recordedImage) {
            fileCoordinator.store(diffImage: diffImage, failedImage: failedImage, config: config)
            addAttachment(named: "Diff image", image: diffImage)
        }
    }
    
}
