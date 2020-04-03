//
//  ResultsCoordinator.swift
//  PixelTest
//
//  Created by Kane Cheshire on 23/07/2018.
//

import XCTest

/// Coordinates handling results and turning them into something useful, like a web page.
final class ResultsCoordinator: NSObject {

    // MARK: - Properties -
    // MARK: Internal
    
    static let shared = ResultsCoordinator()
    
    // MARK: Private
    
    private var failingFiles: Set<String> = []
    private let fileCoordinator = FileCoordinator()
    
    // MARK: - Init -
    // MARK: Overrides
    
    override init() {
        super.init()
        XCTestObservationCenter.shared.addTestObserver(self)
    }
    
}

extension ResultsCoordinator: XCTestObservation {
    
    func testCase(_ testCase: XCTestCase, didFailWithDescription description: String, inFile filePath: String?, atLine lineNumber: Int) {
        guard let filePath = filePath, let testCase = testCase as? PixelTestCase else { return }
        switch testCase.mode {
            case .test:
                switch testCase.testError {
                    case .imagesAreDifferent?: failingFiles.insert(filePath)
                    case .unableToCreateSnapshot?, .unableToGetRecordedImage?, .unableToGetRecordedImageData?, .none: break
                }
            case .record: break
        }
    }
    
    func testBundleDidFinish(_ testBundle: Bundle) {
        guard !failingFiles.isEmpty else { return }
        let failedURLs = Set(failingFiles.map { URL(fileURLWithPath: $0).deletingLastPathComponent() })
        guard let commonPath = fileCoordinator.commonPath(from: failedURLs) else { return }
        let htmlDir = URL(fileURLWithPath: commonPath)
        let allHTML = generateHTMLFileString(withBody: htmlStrings(forFailedURLs: failedURLs, htmlDir: htmlDir).joined() + footerHTML(), failureCount: failingFiles.count)
        let filename = htmlDir.appendingPathComponent("pixeltest_failures.html")
        try? fileCoordinator.write(Data(allHTML.utf8), to: filename)
        failingFiles.removeAll()
    }
    
}

extension ResultsCoordinator {
    
    private func htmlStrings(forFailedURLs failedURLs: Set<URL>, htmlDir: URL) -> [String] {
        return failedURLs.compactMap { fileURL in
            let enumerator = FileManager.default.enumerator(atPath: fileURL.path)
            let diffURLs: [URL] = enumerator!.compactMap { thing in
                guard let path = thing as? String else { return nil }
                let url = fileURL.appendingPathComponent(path)
                guard url.pathComponents.contains("Diff"), url.pathExtension == "png" else { return nil }
                return url
            }
            return generateHTMLString(for: diffURLs, htmlDir: htmlDir)
        }
    }
    
    private func generateHTMLString(for diffURLs: [URL], htmlDir: URL) -> String {
        return diffURLs.map { diffURL in
            let diffPath = diffURL.path
            let failurePath = diffPath.replacingOccurrences(of: ImageType.diff.rawValue, with: ImageType.failure.rawValue)
            let referencePath = diffPath.replacingOccurrences(of: ImageType.diff.rawValue, with: ImageType.reference.rawValue)
            let pixelTestComponentComponent = diffURL.pathComponents.firstIndex(where: { $0 == ".pixeltest" })!
            let heading = diffURL.pathComponents.dropFirst(pixelTestComponentComponent + 1).joined(separator: "/").replacingOccurrences(of: "/\(ImageType.diff.rawValue)", with: "")
            return """
            <section>
            <h2>\(heading)</h2>
            <h3>Failed</h3>
            <h3>Original</h3>
            <h3>Overlay split</h3>
            <div class='snapshot-container'>
                <img src=\(failurePath) width='100%' />
            </div>
            <div class='snapshot-container'>
                <img src=\(referencePath) width='100%' />
            </div>
            <div class='snapshot-container' onmousemove="mouseMoved(event, this)" onmouseenter="mouseEntered(event,this)" onmouseleave="mouseLeft(event, this)">
                <img src=\(referencePath) width='100%' />
                <div class='split-overlay'>
                    <img src=\(failurePath) />
                </div>
            <div class='separator'></div>
            </section>
            """
            }.joined()
    }
    
    private func generateHTMLFileString(withBody body: String, failureCount: Int) -> String {
        let checkerboardImageData = UIImage.checkerboard.pngData()?.base64EncodedString() ?? ""
        return """
        <html>
            <head>
                <title>\(failureCount) \(failureCount == 1 ? "failure" : "failures") | PixelTest</title>
                <script>
                    function mouseMoved(e, element) {
                        e.offsetX, element.children[1].style["width"] = e.offsetX + "px"
                        e.offsetX, element.children[2].style["left"] = (e.offsetX + 1) + "px"
                    }
                    function mouseEntered(e, element) {
                        e.offsetX, element.children[2].style["visibility"] = "hidden"
                    }
                    function mouseLeft(e, element) {
                        e.offsetX, element.children[2].style["visibility"] = "visible"
                    }
                </script>
                <style>
                    html, body { background: black; color: white; margin:0; padding:0; font-family: "Helvetica Neue", Helvetica, Arial, sans-serif; }
                    a { color: grey; }
                    section { border-radius: 5pt; background: rgba(20, 20, 20, 1); margin: 32pt; padding: 0pt 16pt 0pt; }
                    h2 { padding: 16pt 0; position: -webkit-sticky; top: 0; -webkit-backdrop-filter: blur(2px); z-index: 100; border-bottom: 1px rgba(20, 20, 20, 1) solid; }
                    .snapshot-container { width: 33%; display: inline-block; vertical-align: top; margin: 0pt 0pt 16pt; position:relative; }
                    h3 { width: 33%; display: inline-block; margin: 0 0 16pt; }
                    .split-overlay { position: absolute; top: 0; left: 0; width: 50%; height: 100%; overflow: hidden; pointer-events: none; }
                    .split-overlay > img { width: calc(33vw - 32pt); max-height: 100%; }
                    .separator { margin-left: -1pt; position: absolute; left: 50%; top: 0; height: 100%; width: 2pt; background: red; pointer-events: none; }
                    .snapshot-container img { background-image: url("data:image/png;base64,\(checkerboardImageData)"); }
                    footer { color: grey; text-align: center; padding: 0 32pt 32pt; }
                    footer div { padding: 8pt; }
                </style>
            </head>
            <body>
                \(body)
            </body>
        </html>
        """
    }
    
    private func footerHTML() -> String {
        return "<footer><div><a href='https://github.com/KaneCheshire/PixelTest' target='_blank'><img src='data:image/png;base64,\(UIImage.pixelTestIconBase64String)' height='32' /></a></div><div><a href='https://github.com/KaneCheshire/PixelTest' target='_blank'>PixelTest</a> by <a href='https://twitter.com/kanecheshire' target='_blank'>Kane Cheshire</a></div></footer>"
    }
    
}

private extension UIImage {
    
    static let checkerboard: UIImage = {
        let size = CGSize(width: 16, height: 16)
        UIGraphicsBeginImageContextWithOptions(size, false, 2)
        guard let context = UIGraphicsGetCurrentContext() else { return UIImage() }
        context.saveGState()
        UIColor(white: 0.96, alpha: 1).setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        context.restoreGState()
        context.saveGState()
        UIColor(white: 0.9, alpha: 1).setFill()
        let topLeft = CGRect(x: 0, y: 0, width: size.width / 2, height: size.width / 2)
        UIRectFill(topLeft)
        let bottomRight = CGRect(x: size.width / 2, y: size.width / 2, width: size.width / 2, height: size.width / 2)
        UIRectFill(bottomRight)
        context.restoreGState()
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return UIImage() }
        UIGraphicsEndImageContext()
        return image
    }()
    
    static let pixelTestIconBase64String = "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"
    
}
