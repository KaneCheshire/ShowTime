//
//  FileManagerType.swift
//  PixelTest
//
//  Created by Kane Cheshire on 19/03/2018.
//

import Foundation

protocol FileManagerType {
    
    func fileExists(atPath path: String) -> Bool
    func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool, attributes: [FileAttributeKey : Any]?) throws
    
}

extension FileManager: FileManagerType {}
