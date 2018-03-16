//
//  TodayViewController.swift
//  ShowTimeTodayExtension
//
//  Created by Kane Cheshire on 16/03/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import UIKit
import NotificationCenter
import ShowTime

class TodayViewController: UIViewController, NCWidgetProviding {
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
}
