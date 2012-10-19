//
//  SFRadarViewController.m
//  Sitegeist iOS
//
//  Created by Jeremy Carbaugh on 10/2/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFLoadingView.h"
#import "SFRadarViewController.h"

@interface SFRadarViewController ()

@end

@implementation SFRadarViewController

@synthesize cancelButton = _cancelButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    
        [self setView:[[SFLoadingView alloc] init]];
        [self.view setBackgroundColor:[UIColor colorWithRed:0.30f green:0.29f blue:0.29f alpha:1.0f]];
        
//        _cancelButton = [[UIButton alloc] init];
//        [_cancelButton setBackgroundColor:[UIColor lightGrayColor]];
//        [_cancelButton setFrame:CGRectMake(10.0, 220.0, 300.0, 40.0)];
//        [_cancelButton setTitle:@"Close Radar" forState:UIControlStateNormal];
//        [_cancelButton addTarget:self action:@selector(closeRadar) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_cancelButton];
        NSLog(@"%@", self.view);
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@", self.view);
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)closeRadar
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
