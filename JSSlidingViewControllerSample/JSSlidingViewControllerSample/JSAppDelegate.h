//
//  JSAppDelegate.h
//  JSSlidingViewControllerSample
//
//  Created by Jared Sinclair on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FrontViewController.h"

@class JSSlidingViewController, BackViewController;

@interface JSAppDelegate : UIResponder <UIApplicationDelegate, MenuButtonDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) JSSlidingViewController *viewController;
@property (strong, nonatomic) BackViewController *backVC;
@property (strong, nonatomic) FrontViewController *frontVC;

@end
