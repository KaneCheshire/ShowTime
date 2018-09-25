//
//  LayoutCoordinator.swift
//  PixelTest
//
//  Created by Kane Cheshire on 16/04/2018.
//

import Foundation

/// Coordinates laying out a view.
struct LayoutCoordinator: LayoutCoordinatorType {
    
    // MARK: - Properties -
    // MARK: Private
    
    private let constraintIdentifier = "PixelTest.LayoutCoordinator"
    
    // MARK: - Functions -
    // MARK: Internal
    
    /// Lays out a view with a specified layout style.
    /// This handles embedding in a parent view and enforcing a layout pass.
    ///
    /// - Parameters:
    ///   - view: The view to lay out.
    ///   - layoutStyle: The style of layout.
    func layOut(_ view: UIView, with layoutStyle: LayoutStyle) {
        view.translatesAutoresizingMaskIntoConstraints = false
        removeExistingConstraints(from: view)
        switch layoutStyle {
        case .dynamicWidth(fixedHeight: let height):
            let heightConstraint = view.heightAnchor.constraint(equalToConstant: height)
            heightConstraint.identifier = constraintIdentifier
            heightConstraint.isActive = true
        case .dynamicHeight(fixedWidth: let width):
            let widthConstraint = view.widthAnchor.constraint(equalToConstant: width)
            widthConstraint.identifier = constraintIdentifier
            widthConstraint.isActive = true
        case .fixed(width: let width, height: let height):
            let widthConstraint = view.widthAnchor.constraint(equalToConstant: width)
            widthConstraint.identifier = constraintIdentifier
            widthConstraint.isActive = true
            let heightConstraint = view.heightAnchor.constraint(equalToConstant: height)
            heightConstraint.identifier = constraintIdentifier
            heightConstraint.isActive = true
        case .dynamicWidthHeight: break
        }
        embed(view)
    }
    
    // MARK: Private
    
    private func removeExistingConstraints(from view: UIView) {
        let constraintsToRemove = view.constraints.filter { $0.identifier == constraintIdentifier }
        view.removeConstraints(constraintsToRemove)
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
    
}
