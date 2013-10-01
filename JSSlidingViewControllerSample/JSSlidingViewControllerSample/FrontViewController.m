//
//  FrontViewController.m
//  JSSlidingViewControllerSample
//
//  Created by Jared Sinclair on 6/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FrontViewController.h"
#import "DetailViewController.h"

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

@property (nonatomic, strong) IBOutlet UITableView *myTableView;

@end

@implementation FrontViewController

@synthesize delegate;
@synthesize myTableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.myTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        self.myTableView.separatorInset = UIEdgeInsetsZero;
    }
    self.navigationItem.title = @"Front View Controller";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Front" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonPressed)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Burger" style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonPressed:)];
    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.995 blue:0.990 alpha:1.0];
}

- (void)backButtonPressed {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)menuButtonPressed:(id)sender {
    [self.delegate menuButtonPressed:sender];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.delegate unlockSlider];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)lockButtonPressed:(id)sender {
    [self.delegate lockSlider];
}

- (IBAction)unlockButtonPressed:(id)sender {
    [self.delegate unlockSlider];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:@"dualLabelCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"dualLabelCell"];
        cell.backgroundColor = [UIColor colorWithRed:1.0 green:0.995 blue:0.990 alpha:1.0];
        cell.backgroundView = [[UIView alloc] init];
        cell.backgroundView.backgroundColor = [UIColor colorWithRed:1.0 green:0.995 blue:0.990 alpha:1.0];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"Detail Row %i", indexPath.row + 1];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {    
    return 66.0f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController *dvc = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    [self.navigationController pushViewController:dvc animated:YES];
    [self.delegate lockSlider];
}

@end








