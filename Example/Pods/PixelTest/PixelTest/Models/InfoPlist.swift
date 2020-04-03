//
//  InfoPlist.swift
//  PixelTest
//
//  Created by Kane Cheshire on 09/10/2019.
//

import Foundation

struct InfoPlist {
    
    let recordAll: Bool
    
    init(bundle: Bundle) {
        recordAll = bundle.infoDictionary?[.recordAll] as? Bool ?? false
    }
    
}

extension ProcessInfo {
    
    static let recordAll: Bool = {
        guard let value = ProcessInfo.processInfo.environment[.recordAll] else { return false }
        return value == "true" || value == "1" || value == "YES"
    }()
    
}

private extension String {
    
    static let recordAll = "PTRecordAll"
    
}
