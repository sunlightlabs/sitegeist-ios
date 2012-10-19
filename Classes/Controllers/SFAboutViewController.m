//
//  SFAboutViewController.m
//  Sitegeist iOS
//
//  Created by Jeremy Carbaugh on 10/19/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFAboutViewController.h"

@interface SFAboutViewController ()

@property (nonatomic, retain) UIView *aboutView;
@property (nonatomic, retain) UIButton *closeButton;

@end

@implementation SFAboutViewController

@synthesize aboutView = _aboutView;
@synthesize closeButton = _closeButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _aboutView = [[UIView alloc] init];
        [_aboutView setBackgroundColor:[UIColor colorWithRed:0.30f green:0.29f blue:0.29f alpha:1.0f]];
        
        _closeButton = [[UIButton alloc] init];
        [_closeButton setBackgroundColor:[UIColor lightGrayColor]];
        [_closeButton setFrame:CGRectMake(10.0, 220.0, 300.0, 40.0)];
        [_closeButton setTitle:@"Close About" forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeAbout) forControlEvents:UIControlEventTouchUpInside];
        [_aboutView addSubview:_closeButton];
        
        [self setView:_aboutView];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeAbout
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
