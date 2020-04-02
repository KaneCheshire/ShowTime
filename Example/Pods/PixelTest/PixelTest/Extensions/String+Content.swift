//
//  String+Content.swift
//  PixelTest
//
//  Created by Kane Cheshire on 12/04/2019.
//

import Foundation

public extension String {
    
    static let emptyContent = ""
    static let shortContent = """
Lorem ipsum
"""
    static let mediumContent = """
\(shortContent) dolor sit amet, ea vix alia persius.
"""
    static let longContent = """
\(mediumContent) Feugiat atomorum iudicabit vim an, vis at primis feugiat. Decore ubique nam ea. Ancillae officiis splendide cu vel, ius alterum lucilius eu. His sint nostrud id, et vix etiam oratio possit.
"""
    static let veryLongContent = """
\(longContent)
Vim eu omnis nonumy, cu alia imperdiet mel. Graece indoctum et pro, audire commodo electram te mei. In his dicat possit facilisi, cum ut eligendi sententiae. In integre salutatus molestiae vis, est scripta euismod philosophia no. Te numquam noluisse necessitatibus pro, mollis aperiam mei no.
"""
    
}
