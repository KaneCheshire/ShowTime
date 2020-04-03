//
//  PlaceholderImageGenerator.swift
//  PixelTest
//
//  Created by Kane Cheshire on 19/10/2019.
//

import Foundation

final class PlaceholderImageGenerator {
    
    private enum Shape {
        
        case square
        
        enum Triangle {
            case bottomRight
            case bottomLeft
            case topLeft
            case topRight
        }
        
        case triangle(Triangle)
        
    }
    
    private typealias ShapeComponent = (coord: (x: CGFloat, y: CGFloat), shape: Shape)
    
    private let pinks = [
        UIColor(red: 0.97, green: 0.34, blue: 0.91, alpha: 1.00),
        UIColor(red: 0.59, green: 0.07, blue: 0.55, alpha: 1.00),
        UIColor(red: 0.49, green: 0.05, blue: 0.45, alpha: 1.00),
        UIColor(red: 0.49, green: 0.08, blue: 0.45, alpha: 1.00),
        UIColor(red: 0.78, green: 0.18, blue: 0.73, alpha: 1.00),
        UIColor(red: 0.65, green: 0.18, blue: 0.61, alpha: 1.00),
        UIColor(red: 0.78, green: 0.18, blue: 0.73, alpha: 1.00),
        UIColor(red: 0.56, green: 0.05, blue: 0.52, alpha: 1.00),
        UIColor(red: 0.78, green: 0.18, blue: 0.73, alpha: 1.00)
        
    ]
    
    private let teals = [
        UIColor(red: 0.11, green: 0.85, blue: 0.87, alpha: 1.00),
        UIColor(red: 0.09, green: 0.77, blue: 0.79, alpha: 1.00),
        UIColor(red: 0.12, green: 0.87, blue: 0.90, alpha: 1.00),
        UIColor(red: 0.04, green: 0.70, blue: 0.72, alpha: 1.00),
        UIColor(red: 0.39, green: 0.91, blue: 0.92, alpha: 1.00),
        UIColor(red: 0.06, green: 0.77, blue: 0.79, alpha: 1.00)
    ]
    
    private var cache: [CGSize: UIImage] = [:]
    
    func generate(_ size: CGSize) -> UIImage {
        if let cached = cache[size] { return cached }
        let new = generateNew(size)
        cache[size] = new
        return new
    }
    
    private func generateNew(_ size: CGSize) -> UIImage {
        let componentWidth = min(size.width / 8, size.height / 8)
        let xOffset = ((size.width / componentWidth) - 4) / 2
        let yOffset = ((size.height / componentWidth) - 6) / 2
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        UIColor(white: 0.96, alpha: 1).setFill()
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.fill(CGRect(origin: .zero, size: size))
        paint([
            ((0 + xOffset, 1 + yOffset), .triangle(.bottomRight)),
            ((1 + xOffset, 1 + yOffset), .square),
            ((2 + xOffset, 1 + yOffset), .triangle(.bottomLeft)),
            ((0 + xOffset, 2 + yOffset), .square),
            ((2 + xOffset, 2 + yOffset), .square),
            ((0 + xOffset, 3 + yOffset), .square),
            ((1 + xOffset, 3 + yOffset), .square),
            ((2 + xOffset, 3 + yOffset), .triangle(.topLeft)),
            ((0 + xOffset, 4 + yOffset), .triangle(.topRight))
        ], colors: pinks, componentWidth: componentWidth)
        paint([
            ((1 + xOffset, 3 + yOffset), .triangle(.topRight)),
            ((2 + xOffset, 3 + yOffset), .triangle(.bottomRight)),
            ((3 + xOffset, 3 + yOffset), .square),
            ((2 + xOffset, 4 + yOffset), .square),
            ((2 + xOffset, 5 + yOffset), .square),
            ((2 + xOffset, 6 + yOffset), .triangle(.topRight)),
        ], colors: teals, componentWidth: componentWidth)
        let img = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return img
    }
    
    private func paint(_ components: [ShapeComponent], colors: [UIColor], componentWidth: CGFloat) {
        let ctx = UIGraphicsGetCurrentContext()
        components.enumerated().forEach { (index, component) in
            let point = CGPoint(x: componentWidth * component.coord.x, y: componentWidth * component.coord.y)
            let color = colors[index]
            switch component.shape {
                case .square: ctx?.paintSquare(at: point, color: color, width: componentWidth)
                case .triangle(let triangle):
                    switch triangle {
                        case .bottomRight: ctx?.paintBottomRightTriangle(at: point, color: color, width: componentWidth)
                        case .bottomLeft: ctx?.paintBottomLeftTriangle(at: point, color: color, width: componentWidth)
                        case .topLeft: ctx?.paintTopLeftTriangle(at: point, color: color, width: componentWidth)
                        case .topRight: ctx?.paintTopRightTriangle(at: point, color: color, width: componentWidth)
                }
            }
        }
    }
    
}

extension CGContext {
    
    func paintSquare(at start: CGPoint, color: UIColor, width: CGFloat) {
        saveGState()
        move(to: start)
        addLine(to: CGPoint(x: start.x, y: start.y - width))
        addLine(to: CGPoint(x: start.x + width, y: start.y - width))
        addLine(to: CGPoint(x: start.x + width, y: start.y))
        addLine(to: start)
        color.setFill()
        fillPath()
        restoreGState()
    }
    
    func paintBottomRightTriangle(at start: CGPoint, color: UIColor, width: CGFloat) {
        saveGState()
        move(to: start)
        addLine(to: CGPoint(x: start.x + width, y: start.y - width))
        addLine(to: CGPoint(x: start.x + width, y: start.y))
        addLine(to: start)
        color.setFill()
        fillPath()
        restoreGState()
    }
    
    func paintBottomLeftTriangle(at start: CGPoint, color: UIColor, width: CGFloat) {
        saveGState()
        move(to: start)
        addLine(to: CGPoint(x: start.x, y: start.y - width))
        addLine(to: CGPoint(x: start.x + width, y: start.y))
        addLine(to: start)
        color.setFill()
        fillPath()
        restoreGState()
    }
    
    func paintTopLeftTriangle(at start: CGPoint, color: UIColor, width: CGFloat) {
        saveGState()
        move(to: start)
        addLine(to: CGPoint(x: start.x, y: start.y - width))
        addLine(to: CGPoint(x: start.x + width, y: start.y - width))
        addLine(to: start)
        color.setFill()
        fillPath()
        restoreGState()
    }
    
    func paintTopRightTriangle(at start: CGPoint, color: UIColor, width: CGFloat) {
        saveGState()
        move(to: CGPoint(x: start.x, y: start.y - width))
        addLine(to: CGPoint(x: start.x + width, y: start.y - width))
        addLine(to: CGPoint(x: start.x + width, y: start.y))
        addLine(to: CGPoint(x: start.x, y: start.y - width))
        color.setFill()
        fillPath()
        restoreGState()
    }
    
}

extension CGSize: Hashable {
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(width)
        hasher.combine(height)
    }
    
}
