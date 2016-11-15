//
//  AppDelegate.swift
//  ShowTime
//
//  Created by Kane Cheshire on 11/11/2016.
//  Copyright © 2016 Kane Cheshire. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    /* Uncomment to disable ShowTime */
    
//    ShowTime.itsShowTime = false
    
    
    /* Uncomment to modify ShowTime display settings */
    
//    ShowTime.shouldIgnoreApplePencilEvents = false
//    ShowTime.disappearDelay = 0
//    ShowTime.shouldShowMultipleTapCount = true
//    ShowTime.multipleTapCountTextColor = .white
//    ShowTime.fillColor = .black
//    ShowTime.strokeColor = .red
//    ShowTime.strokeWidth = 1
//    ShowTime.size = CGSize(width: 20, height: 20)
    
    return true
  }


}

