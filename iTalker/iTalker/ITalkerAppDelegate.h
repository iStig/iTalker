//
//  ITalkerAppDelegate.h
//  iTalker
//
//  Created by tuyuanlin on 12-8-16.
//  Copyright (c) 2012年 cmcc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ITalkerUserManager;

@interface ITalkerAppDelegate : UIResponder <UIApplicationDelegate> {
    ITalkerUserManager * _userManager;
}

@property (strong, nonatomic) UIWindow *window;

@end
