//
//  ObjCViewController.m
//  ShowTime_Example
//
//  Created by Kane Cheshire on 26/01/2018.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

#import "ObjCViewController.h"
@import ShowTime;

@interface ObjCViewController ()

@end

@implementation ObjCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ShowTime also supports Objective-C projects:
    
    ShowTime.enabled = EnabledAlways;
    
//    ShowTime.shouldIgnoreApplePencilEvents = NO;
//    ShowTime.disappearDelay = 0;
//    ShowTime.shouldShowMultipleTapCount = YES;
//    ShowTime.multipleTapCountTextColor = UIColor.whiteColor;
//    ShowTime.fillColor = UIColor.blackColor;
//    ShowTime.strokeColor = UIColor.redColor;
//    ShowTime.strokeWidth = 1;
//    ShowTime.size = CGSizeMake(20, 20);
}

@end
