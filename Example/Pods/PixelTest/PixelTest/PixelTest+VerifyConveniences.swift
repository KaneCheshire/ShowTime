//
//  PixelTest+VerifyConveniences.swift
//  PixelTest
//
//  Created by Kane Cheshire on 21/10/2019.
//

import UIKit

public extension PixelTestCase {
    
    /// Verifies a `UITableViewCell'`s `contentView`.
    /// - See also: verify(_ view: UIView, layoutStyle: LayoutStyle)
    func verify(_ cell: UITableViewCell, layoutStyle: LayoutStyle,
                scale: Scale = .native, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        verify(cell.contentView, layoutStyle: layoutStyle, scale: scale, file: file, function: function, line: line)
    }
    
    /// Verifies a `UICollectionViewCell'`s `contentView`.
    /// - See also: verify(_ view: UIView, layoutStyle: LayoutStyle)
    func verify(_ cell: UICollectionViewCell, layoutStyle: LayoutStyle,
                scale: Scale = .native, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        verify(cell.contentView, layoutStyle: layoutStyle, scale: scale, file: file, function: function, line: line)
    }
    
    /// Verifies a `UIViewController'`s `view`.
    /// - See also: verify(_ view: UIView, layoutStyle: LayoutStyle)
    func verify(_ controller: UIViewController, layoutStyle: LayoutStyle,
                scale: Scale = .native, file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        verify(controller.view, layoutStyle: layoutStyle, scale: scale, file: file, function: function, line: line)
    }
    
}
