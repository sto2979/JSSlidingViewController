JSSlidingViewController
by Jared Sinclair  -  http://www.jaredsinclair.com




What is JSSlidingViewController ?
=================================

JSSlidingViewController is a easy way to add "slide-to-reveal" style navigation to an iPhone or iPod Touch app. This is similar to the kind of navigation found in Facebook.app, Path.app, and many others. It's a subclass of UIViewController that uses the view controller containment methods available in iOS 5.0 or later. 




What's so Great About JSSlidingViewController ?
===============================================

Unlike other attempts at "slide-to-reveal" navigation, JSSlidingViewController uses a UIScrollView to track touches. Other solutions track touches manually, which results in jaggy scrolling, unexpected behaviors, and poor flick-open/flick-closed behavior. This makes JSSlidingViewController super easy to implement. 




How do I use JSSlidingViewController ?
===============================================

Include the following four files in your project:

- JSSlidingViewController.h
- JSSlidingViewController.m
- frontViewControllerDropShadow.png
- frontViewControllerDropShadow@2x.png

You create a JSSlidingViewController by calling:

- (id)initWithFrontViewController:backViewController:

The frontViewController and backViewController properties are self-explanatory. Just pass in the view controllers you wish to use in that init method. You can also change them later with optional fade animations using the following methods:

- (void)setFrontViewController:animated:completion:
- (void)setBackViewController:animated:completion:

JSSlidingViewController automatically adds a drop shadow next to the front view controller, to add depth. Rather than draw it programmatically, the drop shadow is rendered with an image view. This results in much better visual performance.

You can let the user open and close the sliding scroll view manually, or you can control it programmatically. The programmatic methods take optional completion blocks:

- (void)closeSlider:completion:
- (void)openSlider:completion:

You can even disable manual sliding with:

BOOL allowManualSliding;

JSSlidingViewController also supports the following optional delegate methods, which are called whether or not the opening/closing was performed manually or programmatically:

- slidingViewControllerWillOpen:
- slidingViewControllerWillClose:
- slidingViewControllerDidOpen:
- slidingViewControllerDidClose:

You can set the width of the visible portion of the front view controller that is seen when the sliding scroll view is all the way open. It defaults to 58 points, but you can change it with:

- (void)setWidthOfVisiblePortionOfFrontViewControllerWhenSliderIsOpen:

You can also temporarily disable all opening or closing by setting the following property:

BOOL locked;





License Agreement
=================

Check the end of this doc for the license agreement. But you can use, modify, or share this pretty much as you see fit. Just include attribution in your credits!




License Agreement for Source Code provided by Jared Sinclair
===========================================================

This software is supplied to you by Jared Sinclair in consideration of your agreement to the following terms, and your use, installation, modification or redistribution of this software constitutes acceptance of these terms. If you do not agree with these terms, please do not use, install, modify or redistribute this software.

In consideration of your agreement to abide by the following terms, and subject to these terms, Jared Sinclair grants you a personal, non-exclusive license, to use, reproduce, modify and redistribute the software, with or without modifications, in source and/or binary forms; provided that if you redistribute the software in its entirety and without modifications, you must retain this notice and the following text and disclaimers in all such redistributions of the software, and that in all cases attribution of Jared Sinclair as the original author of the source code shall be included in all such resulting software products or distributions. Neither the name, trademarks, service marks or logos of Jared Sinclair may be used to endorse or promote products derived from the software without specific prior written permission from Jared Sinclair. Except as expressly stated in this notice, no other rights or licenses, express or implied, are granted by Jared Sinclair herein, including but not limited to any patent rights that may be infringed by your derivative works or by other works in which the software may be incorporated.

The software is provided by Jared Sinclair on an "AS IS" basis. JARED SINCLAIR MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE, REGARDING THE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.

IN NO EVENT SHALL JARED SINCLAIR BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION OF THE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF JARED SINCLAIR HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.