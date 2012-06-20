//
//  FrontViewController.h
//  JSSlidingViewControllerSample
//
//  Created by Jared Sinclair on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MenuButtonDelegate;

@interface FrontViewController : UIViewController

@property (nonatomic, weak) id <MenuButtonDelegate> delegate;

@end

@protocol MenuButtonDelegate <NSObject>

- (void)menuButtonPressed:(id)sender;
- (void)lockSlider;
- (void)unlockSlider;

@end