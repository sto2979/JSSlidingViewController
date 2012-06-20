//
//  JSSlidingViewController.m
//  JSSlidingViewControllerSample
//
//  Created by Jared Sinclair on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "JSSlidingViewController.h"

@interface SlidingScrollView : UIScrollView

@end

@implementation SlidingScrollView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO; // So that dropshadow along the lefthand side of the frontViewController still appears when the slider is open.
        self.backgroundColor = [UIColor clearColor];
        self.pagingEnabled = YES;
        self.bounces = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.delaysContentTouches = NO;
        self.canCancelContentTouches = YES;
    }
    return self;
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    BOOL shouldCancel = NO;
    if ([view isKindOfClass:[UIView class]]) {
        shouldCancel = YES;
    }
    return shouldCancel;
}

@end

@interface JSSlidingViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *slidingScrollView;
@property (nonatomic, strong) UIButton *invisibleCloseSliderButton;
@property (nonatomic, assign) CGFloat sliderOpeningWidth;

- (void)setupSlidingScrollView;
- (void)addInvisibleButton;

@end

@implementation JSSlidingViewController

@synthesize animating = _animating;
@synthesize dragging = _dragging;
@synthesize tracking = _tracking;
@synthesize decelerating = _decelerating;
@synthesize isOpen = _isOpen;
@synthesize locked = _locked;
@synthesize frontViewControllerHasOpenCloseNavigationBarButton = _frontViewControllerHasOpenCloseNavigationBarButton;
@synthesize frontViewController = _frontViewController;
@synthesize backViewController = _backViewController;
@synthesize slidingScrollView = _slidingScrollView;
@synthesize invisibleCloseSliderButton = _invisibleCloseSliderButton;
@synthesize delegate;
@synthesize sliderOpeningWidth = _sliderOpeningWidth;

#define kDefaultVisiblePortion 58.0f

#pragma mark - View Lifecycle

- (id)initWithFrontViewController:(UIViewController *)frontVC backViewController:(UIViewController *)backVC {
    NSAssert(frontVC, @"JSSlidingViewController requires both a front and a back view controller");
    NSAssert(backVC, @"JSSlidingViewController requires both a front and a back view controller");
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        [self setupSlidingScrollView];
        [self setFrontViewController:frontVC animated:NO completion:nil];
        [self setBackViewController:backVC animated:NO completion:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Controlling the Slider

- (void)closeSlider:(BOOL)animated completion:(void (^)(void))completion __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0) {
    if (_animating == NO && _isOpen) {
        if ([self.delegate respondsToSelector:@selector(slidingViewControllerWillClose:)]) {
            [self.delegate slidingViewControllerWillClose:self];
        }
        _isOpen = NO; // Needs to be here to prevent bugs
        CGFloat duration1 = 0.0f;
        CGFloat duration2 = 0.0f;
        if (animated) {
            duration1 = 0.18f;
            duration2 = 0.1f;
        }
        [UIView animateWithDuration: duration1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                 CGRect rect = _slidingScrollView.frame;
                 rect.origin.x = -10.0f;
                 _slidingScrollView.frame = rect;
             } completion:^(BOOL finished) {
                 [UIView animateWithDuration: duration2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                          CGRect rect = _slidingScrollView.frame;
                          rect.origin.x = 0;
                          _slidingScrollView.frame = rect;
                      } completion:^(BOOL finished) {
                          if (self.invisibleCloseSliderButton) {
                              [self.invisibleCloseSliderButton removeFromSuperview];
                              self.invisibleCloseSliderButton = nil;
                          }
                          _animating = NO;
                          self.view.userInteractionEnabled = YES;
                          if (completion) {
                              dispatch_async(dispatch_get_main_queue(), completion);
                          }
                          if ([self.delegate respondsToSelector:@selector(slidingViewControllerDidClose:)]) {
                              [self.delegate slidingViewControllerDidClose:self];
                          }
                      }];  
             }];
    }
}

- (void)openSlider:(BOOL)animated completion:(void (^)(void))completion __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0) {
    if (_animating == NO && _isOpen == NO) {
        if ([self.delegate respondsToSelector:@selector(slidingViewControllerWillOpen:)]) {
            [self.delegate slidingViewControllerWillOpen:self];
        }
        _isOpen = YES; // Needs to be here to prevent bugs
        CGFloat duration1 = 0.0f;
        CGFloat duration2 = 0.0f;
        if (animated) {
            duration1 = 0.18f;
            duration2 = 0.1f;
        }
        [UIView animateWithDuration:duration1  delay:0 options:UIViewAnimationOptionCurveEaseOut  animations:^{
            CGRect rect = _slidingScrollView.frame;
            rect.origin.x = _sliderOpeningWidth + 10;
            _slidingScrollView.frame = rect;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:duration2  delay:0 options:UIViewAnimationOptionCurveEaseIn  animations:^{
                  CGRect rect = _slidingScrollView.frame;
                  rect.origin.x = _sliderOpeningWidth;
                  _slidingScrollView.frame = rect;
              } completion:^(BOOL finished) {
                  if (self.invisibleCloseSliderButton == nil) {
                      [self addInvisibleButton];
                  }
                  _animating = NO;
                  self.view.userInteractionEnabled = YES; 
                  if (completion) {
                      dispatch_async(dispatch_get_main_queue(), completion);
                  }
                  if ([self.delegate respondsToSelector:@selector(slidingViewControllerDidOpen:)]) {
                      [self.delegate slidingViewControllerDidOpen:self];
                  }
              }]; 
        }];
    }
}

- (void)setFrontViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0) {
    NSAssert(viewController, @"JSSlidingViewController requires both a front and a back view controller");
    UIViewController *newFrontViewController = viewController;
    CGRect frame = self.view.bounds;
    newFrontViewController.view.frame = CGRectMake(_sliderOpeningWidth, frame.origin.y, frame.size.width, frame.size.height);
    newFrontViewController.view.alpha = 0.0f;
    [self addChildViewController:newFrontViewController];
    [_slidingScrollView addSubview:newFrontViewController.view];
    CGFloat duration = 0.0f;
    if (animated) {
        duration = 0.25f;
    }
    [UIView animateWithDuration:duration animations:^{
        newFrontViewController.view.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [_frontViewController willMoveToParentViewController:nil];
        [_frontViewController.view removeFromSuperview];
        [_frontViewController removeFromParentViewController];
        [newFrontViewController didMoveToParentViewController:self];
        _frontViewController = newFrontViewController;
    }];
}

- (void)setBackViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^)(void))completion __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0) {
    NSAssert(viewController, @"JSSlidingViewController requires both a front and a back view controller");
    UIViewController *newBackViewController = viewController;
    newBackViewController.view.frame = self.view.bounds;
    [self addChildViewController:newBackViewController];
    [self.view insertSubview:newBackViewController.view atIndex:0];
    CGFloat duration = 0.0f;
    if (animated) {
        duration = 0.25f;
    }
    [UIView animateWithDuration:duration animations:^{
        _backViewController.view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [_backViewController willMoveToParentViewController:nil];
        [_backViewController.view removeFromSuperview];
        [_backViewController removeFromParentViewController];
        [newBackViewController didMoveToParentViewController:self];
        _backViewController = newBackViewController;
    }];
}

#pragma mark - Scroll View Delegate for the Sliding Scroll View

/*
 
 SLIDING SCROLL VIEW DISCUSSION
 
 Nota Bene: 
 Some of these scroll view delegate method implementations may look quite strange, but 
 it has to do with the peculiarities of the timing and circumstances of UIScrollViewDelegate 
 callbacks. Numerous bugs and unusual edge cases have been accounted for via rigorous testing. 
 Edit these with extreme care!!!
 
 How It Works:
 
 1. The slidingScrollView is a container for the frontmost content. The backmost content is not a part of the slidingScrollView's hierarchy.
 The slidingScrollView has a clear background color, which masks the technique I'm using. To make it easier to see what's happening, 
 try temporarily setting it's background color to a semi-translucent color in the -(void)setupSlidingScrollView method.
 
 2. When the slider is closed and at rest, the scroll view's frame fills the display.
 
 3. When the slider is open and at rest, the scroll view's frame is snapped over to the right, 
 starting at an x origin of 262.
 
 4. When the slider is being opened or closed and is tracking a dragging touch, the scroll view's frame fills 
 the display. 
 
 5a. When the slider has finished animating/decelerating to either the closed or open position, the 
 UIScrollView delegate callbacks are used to determine what to do next.
 5b. If the slider has come to rest in the open position, the scroll view's frame's x origin is set to the value 
 in #3, and an "invisible button" is added over the visible portion of the main content 
 to catch touch events and trigger a close action.
 5c. If the slider has come to rest in the closed position, the invisible button is removed, and the 
 scroll view's frame once again fills the display.
 
 6. Numerous edge cases were solved for, most of them related to what happens when touches/drags 
 begin or end before the slider has finished decelerating (in either direction).
 
 7a. Changes to the scroll view frame or the invisible button are also triggered by UIView touch event 
 methods like touchesBegan and touchesEnded.
 7b. Since not every touch sequence turns into a drag, responses to these touch events must perform
 some of the same functions as responses to scroll view delegate methods. This explains why there is
 some overlap between the two kinds of sequences.
 
 Summary:
 
 By combining UIScrollViewDelegate methods and UIView touch event methods, I am able to mimic the slide-to-reveal 
 navigation that is currently in-vogue, but without having to manually track touches and calculate dragging & decelerating
 animations. Apple's own implementation of UIScrollView touch tracking is infinitely smoother and richer than any
 third party library.
 
 */

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (decelerate == YES) {
        // We'll handle the rest after it's done decelerating...
        self.view.userInteractionEnabled = NO;
    } else {
        CGPoint origin = self.frontViewController.view.frame.origin;
        origin = [_slidingScrollView convertPoint:origin toView:self.view];
        if ( (origin.x >= _sliderOpeningWidth) && (_animating == NO) ){
            if (self.invisibleCloseSliderButton == nil) {
                [self addInvisibleButton];
            }
            CGRect rect = _slidingScrollView.frame;
            rect.origin.x = _sliderOpeningWidth;
            _slidingScrollView.frame = rect;
            _slidingScrollView.contentOffset = CGPointMake(_sliderOpeningWidth, 0);
            _isOpen = YES;
        } else {
            if (self.invisibleCloseSliderButton) {
                [self.invisibleCloseSliderButton removeFromSuperview];
                self.invisibleCloseSliderButton = nil;
            }
            _isOpen = NO;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {    
    CGPoint origin = self.frontViewController.view.frame.origin;
    origin = [_slidingScrollView convertPoint:origin toView:self.view];
    if ( (origin.x >= _sliderOpeningWidth) && (scrollView.dragging == NO) ){
        if (self.invisibleCloseSliderButton == nil) {
            [self addInvisibleButton];
        }
        if (_animating == NO) { // prevents bug that kept the stylistic animation blocks in the open/close:animated: methods from rendering properly
            CGRect rect = _slidingScrollView.frame;
            rect.origin.x = _sliderOpeningWidth;
            _slidingScrollView.frame = rect;
            _slidingScrollView.contentOffset = CGPointMake(_sliderOpeningWidth, 0);
            _isOpen = YES;
        }
    } else {
        if (self.invisibleCloseSliderButton) {
            [self.invisibleCloseSliderButton removeFromSuperview];
            self.invisibleCloseSliderButton = nil;
        }
        _isOpen = NO;
    }
    self.view.userInteractionEnabled = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {  
    if (_isOpen == YES && _locked == NO) {
        CGRect rect = _slidingScrollView.frame;
        rect.origin.x = 0;
        _slidingScrollView.frame = rect;
        _slidingScrollView.contentOffset = CGPointMake(0, 0);
        if (self.invisibleCloseSliderButton) {
            [self.invisibleCloseSliderButton removeFromSuperview];
            self.invisibleCloseSliderButton = nil;
        }
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (_isOpen == YES && _locked == NO) {
        CGRect rect = _slidingScrollView.frame;
        rect.origin.x = 0;
        _slidingScrollView.frame = rect;
        _slidingScrollView.contentOffset = CGPointMake(0, 0);
        if (self.invisibleCloseSliderButton) {
            [self.invisibleCloseSliderButton removeFromSuperview];
            self.invisibleCloseSliderButton = nil;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {   
    if (_isOpen == YES && _locked == NO) {
        if (self.invisibleCloseSliderButton == nil) {
            [self addInvisibleButton];
        }
        CGRect rect = _slidingScrollView.frame;
        rect.origin.x = _sliderOpeningWidth;
        _slidingScrollView.frame = rect;
        _slidingScrollView.contentOffset = CGPointMake(_sliderOpeningWidth, 0);
    } 
    [super touchesEnded:touches withEvent:event];
}

#pragma mark - Setup

- (void)setupSlidingScrollView {
    CGRect frame = self.view.bounds;
    [self setWidthOfVisiblePortionOfFrontViewControllerWhenSliderIsOpen:kDefaultVisiblePortion];
    self.slidingScrollView = [[SlidingScrollView alloc] initWithFrame:frame];
    _slidingScrollView.contentOffset = CGPointMake(_sliderOpeningWidth, 0);
    _slidingScrollView.contentSize = CGSizeMake(frame.size.width + _sliderOpeningWidth, frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height);
    _slidingScrollView.delegate = self;
    [self.view insertSubview:_slidingScrollView atIndex:0];
    _isOpen = NO;
    _locked = NO;
    _animating = NO;
    _frontViewControllerHasOpenCloseNavigationBarButton = YES;
    UIImageView *frontViewControllerDropShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frontViewControllerDropShadow.png"]];
    frontViewControllerDropShadow.frame = CGRectMake(_sliderOpeningWidth - 20.0f, 0.0f, 20.0f, _slidingScrollView.bounds.size.height);
    [_slidingScrollView addSubview:frontViewControllerDropShadow];
}

#pragma mark - Convenience

- (void)addInvisibleButton {
    self.invisibleCloseSliderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.invisibleCloseSliderButton.showsTouchWhenHighlighted = NO;
    CGFloat yOrigin = 0.0f;
    if (_frontViewControllerHasOpenCloseNavigationBarButton) {
        yOrigin = 44.0f;
    }
    self.invisibleCloseSliderButton.frame = CGRectMake(self.frontViewController.view.frame.origin.x, yOrigin, self.view.frame.size.width - _sliderOpeningWidth, self.view.frame.size.height - yOrigin);
    self.invisibleCloseSliderButton.backgroundColor = [UIColor clearColor];
    [self.invisibleCloseSliderButton addTarget:self action:@selector(invisibleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [_slidingScrollView addSubview:self.invisibleCloseSliderButton];
}

- (void)invisibleButtonPressed {
    if (_locked == NO) {
        [self closeSlider:YES completion:nil];
    }
}

- (void)setWidthOfVisiblePortionOfFrontViewControllerWhenSliderIsOpen:(CGFloat)width {
    _sliderOpeningWidth = self.view.frame.size.width - width;
}

- (void)setLocked:(BOOL)locked {
    _locked = locked;
    _slidingScrollView.scrollEnabled = !_locked;
}

@end








