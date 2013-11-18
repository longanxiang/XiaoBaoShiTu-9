//
//  AppDelegate.h
//  XiaoBaoShiTu
//
//  Created by longanxiang_iMac on 13-8-24.
//  Copyright (c) 2013年 tm. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RootViewController;
extern NSString *strZhi;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController * rootNav;
@property (strong, nonatomic) RootViewController * rootCtrl;

@end
