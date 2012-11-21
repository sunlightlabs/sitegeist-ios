//
//  SFAboutViewController.m
//  Sitegeist iOS
//
//  Created by Jeremy Carbaugh on 10/19/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFAboutViewController.h"

@interface SFAboutViewController ()
@end

@implementation SFAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        UIImage *aboutImg = [UIImage imageNamed:@"about"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:aboutImg];
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [scrollView addSubview:imageView];
        [scrollView setContentSize:aboutImg.size];
        [scrollView setScrollEnabled:YES];
        [scrollView setScrollsToTop:YES];
        [self setView:scrollView];

        // close button
        
        UIButton *closeButton = [[UIButton alloc] init];
        [closeButton setImage:[UIImage imageNamed:@"298-circlex"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeAbout) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setFrame:CGRectMake(288, 8, 27, 27)];
        [scrollView addSubview:closeButton];
        
        // more information
        
        UIButton *moreButton = [[UIButton alloc] init];
        [moreButton setFrame:CGRectMake(97.0, 290.0, 121.0, 40.0)];
        [moreButton addTarget:self action:@selector(openMore) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:moreButton];
        
        // Sunlight Foundation
        
        UIButton *sunlightButton = [[UIButton alloc] init];
        [sunlightButton setFrame:CGRectMake(69.0, 366.0, 179.0, 70.0)];
        [sunlightButton addTarget:self action:@selector(openSunlightFoundation) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:sunlightButton];
        
        UIButton *sunlightLink = [[UIButton alloc] init];
        [sunlightLink setFrame:CGRectMake(20.0, 215.0, 134.0, 18.0)];
        [sunlightLink addTarget:self action:@selector(openSunlightFoundation) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:sunlightLink];
        
        
        // Knight Foundation
        
        UIButton *knightButton = [[UIButton alloc] init];
        [knightButton setFrame:CGRectMake(13.0, 486.0, 161.0, 49.0)];
        [knightButton addTarget:self action:@selector(openKnightFoundation) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:knightButton];
        
        UIButton *knightLink1 = [[UIButton alloc] init];
        [knightLink1 setFrame:CGRectMake(154.0, 235.0, 133.0, 20.0)];
        [knightLink1 addTarget:self action:@selector(openKnightFoundation) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:knightLink1];
        
        UIButton *knightLink2 = [[UIButton alloc] init];
        [knightLink2 setFrame:CGRectMake(21.0, 251.0, 121.0, 20.0)];
        [knightLink2 addTarget:self action:@selector(openKnightFoundation) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:knightLink2];
        
        // IDEO
        
        UIButton *ideoButton = [[UIButton alloc] init];
        [ideoButton setFrame:CGRectMake(185.0, 497.0, 121.0, 38.0)];
        [ideoButton addTarget:self action:@selector(openIDEO) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:ideoButton];
        
        UIButton *ideoLink = [[UIButton alloc] init];
        [ideoLink setFrame:CGRectMake(244.0, 215.0, 38.0, 18.0)];
        [ideoLink addTarget:self action:@selector(openIDEO) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:ideoLink];
        
        
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)openSunlightFoundation
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://sunlightfoundation.com/"]];
}

- (void)openKnightFoundation
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.knightfoundation.org/"]];
}

- (void)openIDEO
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.ideo.com/"]];
}

- (void)openMore
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://sitegeist.sunlightfoundation.com/about/"]];
}

@end
