//
//  JSSlidingViewController.h
//  JSSlidingViewControllerSample
//
//  Created by Jared Sinclair on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JSSlidingViewControllerDelegate;

@interface JSSlidingViewController : UIViewController

@property (nonatomic, readonly) BOOL animating;
@property (nonatomic, readonly) BOOL isOpen;
@property (nonatomic, assign) BOOL locked;
@property (nonatomic, assign) BOOL frontViewControllerHasOpenCloseNavigationBarButton; // Defaults to YES.
@property (nonatomic, readonly) UIViewController *frontViewController;
@property (nonatomic, readonly) UIViewController *backViewController;
@property (nonatomic, weak) id <JSSlidingViewControllerDelegate> delegate;
@property (nonatomic, assign) BOOL allowManualSliding;

- (id)initWithFrontViewController:(UIViewController *)frontVC backViewController:(UIViewController *)backVC;
- (void)closeSlider:(BOOL)animated completion:(void (^)(void))completion __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);
- (void)openSlider:(BOOL)animated completion:(void (^)(void))completion __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);
- (void)setFrontViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);
- (void)setBackViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);
- (void)setWidthOfVisiblePortionOfFrontViewControllerWhenSliderIsOpen:(CGFloat)width;

@end

// Note: These delegate methods are called *after* any completion blocks have been performed.

@protocol JSSlidingViewControllerDelegate <NSObject>

@optional

- (void)slidingViewControllerWillOpen:(JSSlidingViewController *)viewController;
- (void)slidingViewControllerWillClose:(JSSlidingViewController *)viewController;
- (void)slidingViewControllerDidOpen:(JSSlidingViewController *)viewController;
- (void)slidingViewControllerDidClose:(JSSlidingViewController *)viewController;

@end