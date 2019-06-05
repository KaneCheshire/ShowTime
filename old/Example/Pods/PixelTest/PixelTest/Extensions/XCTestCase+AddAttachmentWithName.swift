//
//  XCTestCase+AddAttachmentWithName.swift
//  PixelTest
//
//  Created by Kane Cheshire on 24/04/2018.
//

import XCTest

extension XCTestCase {
    
    func addAttachment(named name: String, image: UIImage) {
        let attachment = XCTAttachment(image: image)
        attachment.name = name
        add(attachment)
    }
    
}
