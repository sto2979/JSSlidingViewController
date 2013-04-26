JSSlidingViewController
=======================
by Jared Sinclair  -  http://www.jaredsinclair.com




## What is JSSlidingViewController ?

JSSlidingViewController is an easy way to add "slide-to-reveal" style navigation to an iPhone, iPad, or iPod Touch app. This is similar to the kind of navigation found in Facebook.app, Path.app, and many others. It's a subclass of UIViewController that uses the view controller containment methods available in iOS 5.0 or later.


## What Does it Support ?

* **iOS**: 5 and 6
* **Devices**: iPhone, iPad, and iPod Touch
* **Orientations**: All 4 interface orientations !


## What's so Great About JSSlidingViewController ?

Unlike other attempts at "slide-to-reveal" navigation, JSSlidingViewController uses a UIScrollView to track touches. Other solutions track touches manually, which results in jaggy scrolling, unexpected behaviors, and poor flick-open/flick-closed behavior. JSSlidingViewController is much more responsive. It uses Apple's great work with scroll views to track touches closely, update views quickly, and recognize gestures more accurately. 


## Known Issues

- There is a difficult-to-reproduce bug with nesting a UITableViewController's view inside of a UINavigationController with the navigation bar hidden. See the .h file for an extended discussion.


## How do I use JSSlidingViewController ?

Include the following four files in your project:

```
JSSlidingViewController.h
JSSlidingViewController.m
frontViewControllerDropShadow.png
frontViewControllerDropShadow@2x.png
```

You create a JSSlidingViewController by calling:

```
- (id)initWithFrontViewController:backViewController:
```

The frontViewController and backViewController properties are self-explanatory. Just pass in the view controllers you wish to use in that init method. You can also change them later with optional fade animations using the following methods:

```
- (void)setFrontViewController:animated:completion:
- (void)setBackViewController:animated:completion:
```

JSSlidingViewController automatically adds drop shadows next to the front view controller, to add depth. Rather than draw them programmatically, the drop shadow is rendered with an image view. This results in much better visual performance at the expense of a trivial amount of memory.




## Opening and Closing The Slider

You can let the user open and close the sliding scroll view manually, or you can control it programmatically. The programmatic methods take optional completion blocks:

```
- (void)closeSlider:completion:
- (void)openSlider:completion:
```


## Options

###Locking the Slider

You can temporarily disable all opening or closing (either via touches or programmatically) by setting the following property:

```
BOOL locked;
```

You can disable just manual sliding with:

```
BOOL allowManualSliding;
```

###Visible Portion of the Front View Controller

You can set the width of the visible portion of the front view controller that is seen when the sliding scroll view is all the way open. It defaults to 58 points, but you can change it with:

```
-(void)setWidthOfVisiblePortionOfFrontViewControllerWhenSliderIsOpen:
```

###Animation Styles: Bouncy or Not?

By default, JSSlidingViewController uses a “bouncy” animation style when the slider is opened/closed programmatically. You can turn this off in favor of a smooth animation style via the following:

```
BOOL useBouncyAnimations
```


## Delegate Protocol

###Opening and Closing Events

JSSlidingViewController also supports the following optional delegate methods, which are called whether or not the opening/closing was performed manually or programmatically:

```
- slidingViewControllerWillOpen:
- slidingViewControllerWillClose:
- slidingViewControllerDidOpen:
- slidingViewControllerDidClose:
```

## NSNotifications

There are also NSNotifications that are posted for certain events. These are handy when using the delegate protocol would be infeasible:

```
JSSlidingViewControllerWillOpenNotification;
JSSlidingViewControllerWillCloseNotification;
JSSlidingViewControllerDidOpenNotification;
JSSlidingViewControllerDidCloseNotification;
JSSlidingViewControllerWillBeginDraggingNotification;
```

## Removing the Back View When It’s Not Needed

You can optionally set JSSlidingViewController to remove the backViewController’s view from the view hierarchy whenever it’s closed:

```
BOOL shouldTemporarilyRemoveBackViewControllerWhenClosed
```

Setting this property to YES will cause JSSlidingViewController to remove the backViewController’s view just after closing, and to reinsert it just before it opens again (whether or not these actions were triggered programmatically or by touch gestures). *The backViewController’s view is not released, it’s just removed from the view hierarchy, although UIKit may unload it under memory pressure.*

Removing the backViewController’s view helps reduce the total number of views in the view hierarchy, and fixes bugs with apps that support **VoiceOver** accessibility.

## Autorotation

Lastly, you can control the interface orientation methods via two additional delegate methods (one for i0S 5 and the other for iOS 6) that are self-explanatory:

```
-(NSUInteger)supportedInterfaceOrientationsForSlidingViewController:
-(BOOL)slidingViewController:shouldAutorotateToInterfaceOrientation:
```


## In-Depth Discussion
 
### Nota Bene

Some of these scroll view delegate method implementations may look quite strange, but it has to do with the peculiarities of the timing and circumstances of UIScrollViewDelegate callbacks. Numerous bugs and unusual edge cases have been accounted for via rigorous testing. Edit these with extreme care!!!
 
###How It Works:
 
1. The slidingScrollView is a container for the frontmost content. The back-most content is not a part of the slidingScrollView's hierarchy. The slidingScrollView has a clear background color, which masks the technique I'm using. To make it easier to see what's happening, try temporarily setting it's background color to a semi-translucent color in the *setupSlidingScrollView* method.
 
2. When the slider is closed and at rest, the scroll view's frame fills the display.
 
3. When the slider is open and at rest, the scroll view's frame is snapped over to the right, starting at an x origin of 262.
 
4. When the slider is being opened or closed and is tracking a dragging touch, the scroll view's frame fills the display.

5. When the slider has finished animating/decelerating to either the closed or open position, the UIScrollView delegate callbacks are used to determine what to do next. If the slider has come to rest in the open position, the scroll view's frame's x origin is set to the value in #3, and an "invisible button" is added over the visible portion of the main content to catch touch events and trigger a close action. If the slider has come to rest in the closed position, the invisible button is removed, and the scroll view's frame once again fills the display.
 
6. Numerous edge cases were solved for, most of them related to what happens when touches/drags begin or end before the slider has finished decelerating (in either direction).

7. Changes to the scroll view frame or the invisible button are also triggered by UIView touch event methods like touchesBegan and touchesEnded. Since not every touch sequence turns into a drag, responses to these touch events must perform some of the same functions as responses to scroll view delegate methods. This explains why there is some overlap between the two kinds of sequences.
 
### Summary:

By combining UIScrollViewDelegate methods and UIView touch event methods, I am able to mimic the slide-to-reveal navigation that is currently in-vogue, but without having to manually track touches and calculate dragging & decelerating animations. Apple's own implementation of UIScrollView touch tracking is infinitely smoother and richer than any third party library.



## License Agreement

Check the end of this doc for the license agreement. But you can use, modify, or share this pretty much as you see fit. Just include attribution in your credits!




## License Agreement for Source Code provided by Jared Sinclair

This software is supplied to you by Jared Sinclair in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this software constitutes acceptance of these terms. If you do not agree with these terms, please do not use, install, modify or redistribute this software.

In consideration of your agreement to abide by the following terms, and subject to these terms, Jared Sinclair grants you a personal, non-exclusive license, to use, reproduce, modify and redistribute the software, with or without modifications, in source and/or binary forms; provided that if you redistribute the software in its entirety and without modifications, you must retain this notice and the following text and disclaimers in all such redistributions of the software, and that in all cases attribution of Jared Sinclair as the original author of the source code shall be included in all such resulting software products or distributions. Neither the name, trademarks, service marks or logos of Jared Sinclair may be used to endorse or promote products derived from the software without specific prior written permission from Jared Sinclair. Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted by Jared Sinclair herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the software may be incorporated.

The software is provided by Jared Sinclair on an "AS IS" basis. JARED SINCLAIR MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL JARED SINCLAIR BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF JARED SINCLAIR HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
