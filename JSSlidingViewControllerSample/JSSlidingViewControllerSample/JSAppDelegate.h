//
//  JSAppDelegate.h
//  JSSlidingViewControllerSample
//
//  Created by Jared Sinclair on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrontViewController.h"
#import "JSSlidingViewController.h"

@class BackViewController;

@interface JSAppDelegate : UIResponder <UIApplicationDelegate, MenuButtonDelegate, JSSlidingViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) JSSlidingViewController *viewController;
@property (strong, nonatomic) BackViewController *backVC;
@property (strong, nonatomic) FrontViewController *frontVC;

@end
