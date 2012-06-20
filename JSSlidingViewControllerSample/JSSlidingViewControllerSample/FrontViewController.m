//
//  FrontViewController.m
//  JSSlidingViewControllerSample
//
//  Created by Jared Sinclair on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FrontViewController.h"

@interface UIButton (JSButtonEdgeInsets)

- (void)setEdgeInsets:(UIEdgeInsets)insets;

@end

@implementation UIButton (JSButtonEdgeInsets)

- (void)setEdgeInsets:(UIEdgeInsets)insets {
    [self setBackgroundImage:[[self backgroundImageForState:UIControlStateNormal] resizableImageWithCapInsets:insets]
                             forState:UIControlStateNormal];
    [self setBackgroundImage:[[self backgroundImageForState:UIControlStateHighlighted] resizableImageWithCapInsets:insets]
                             forState:UIControlStateHighlighted];
}

@end

@interface FrontViewController ()

@property (strong, nonatomic) IBOutlet UIButton *lockButton;
@property (strong, nonatomic) IBOutlet UIButton *unlockButon;

@end

@implementation FrontViewController

@synthesize lockButton;
@synthesize unlockButon;
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Front View C.";
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [customButton setBackgroundImage:[UIImage imageNamed:@"navigationBar_menuButton_normal.png"] forState:UIControlStateNormal];
    [customButton setBackgroundImage:[UIImage imageNamed:@"navigationBar_menuButton_highlighted.png"] forState:UIControlStateHighlighted];
    customButton.frame = CGRectMake(0, 0, 48, 30);
    [customButton addTarget:self action:@selector(menuButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"texture_creamPaper.png"]];
    [self.lockButton setEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
    [self.unlockButon setEdgeInsets:UIEdgeInsetsMake(0, 20, 0, 20)];
}

- (void)menuButtonPressed:(id)sender {
    [self.delegate menuButtonPressed:sender];
}

- (void)viewDidUnload
{
    [self setLockButton:nil];
    [self setUnlockButon:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
- (IBAction)lockButtonPressed:(id)sender {
    [self.delegate lockSlider];
}
- (IBAction)unlockButtonPressed:(id)sender {
    [self.delegate unlockSlider];
}

@end
