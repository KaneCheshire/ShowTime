//
//  AppDelegate.swift
//  ShowTime
//
//  Created by kanecheshire on 04/27/2017.
//  Copyright (c) 2017 kanecheshire. All rights reserved.
//

import UIKit
import ShowTime

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    ShowTime.enabled = .always
    
//     Uncomment to modify ShowTime display settings
//     See ObjCViewController.m for Objective-C support
    
//    ShowTime.shouldIgnoreApplePencilEvents = false
//    ShowTime.disappearDelay = 0
//    ShowTime.shouldShowMultipleTapCount = true
//    ShowTime.multipleTapCountTextFont = .italicSystemFont(ofSize: 20)
//    ShowTime.disappearAnimation = .scaleDown
//    ShowTime.disappearAnimation = .custom { view in
//        view.alpha = 0
//        view.transform = CGAffineTransform(scaleX: 2, y: 2)
//    }
//    ShowTime.multipleTapCountTextColor = .white
//    ShowTime.fillColor = .black
//    ShowTime.strokeColor = .red
//    ShowTime.strokeWidth = 1
//    ShowTime.size = CGSize(width: 20, height: 20)
    
    return true
  }
  
}

