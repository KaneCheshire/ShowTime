//
//  AppDelegate.swift
//  ShowTime
//
//  Created by kanecheshire on 04/27/2017.
//  Copyright (c) 2017 kanecheshire. All rights reserved.
//

import UIKit
// You only need to import this if changing any default values
// ShowTime v1 will work without having to import!
import ShowTime

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
  
/* Uncomment to disable ShowTime */
    
    // ShowTime.enabled = .never
    
    
    
    
/* Uncomment to modify ShowTime display settings */
    
    // ShowTime.disappearAnimation = .scaleDown
    // ShowTime.shouldIgnoreApplePencilEvents = false
    // ShowTime.disappearDelay = 0
    // ShowTime.shouldShowMultipleTapCount = true
    // ShowTime.multipleTapCountTextColor = .white
    // ShowTime.fillColor = .black
    // ShowTime.strokeColor = .red
    // ShowTime.strokeWidth = 1
    // ShowTime.size = CGSize(width: 20, height: 20)
    
    return true
  }
  
}

