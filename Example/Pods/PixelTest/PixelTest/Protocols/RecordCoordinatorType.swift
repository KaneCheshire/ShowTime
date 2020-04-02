//
//  RecordCoordinatorType.swift
//  PixelTest
//
//  Created by Kane Cheshire on 16/10/2019.
//

import Foundation

protocol RecordCoordinatorType {
    
    func record(_ view: UIView, config: Config) throws -> UIImage
    
}
