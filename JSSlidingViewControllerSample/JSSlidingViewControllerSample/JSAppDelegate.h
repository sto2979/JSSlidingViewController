//
//  JSAppDelegate.h
//  JSSlidingViewControllerSample
//
//  Created by Jared Sinclair on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JSSlidingViewController;

@interface JSAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) JSSlidingViewController *viewController;

@end
