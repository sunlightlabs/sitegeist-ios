//
//  SFPrimaryViewController.m
//  Sitegeist iOS
//
//  Created by Jeremy Carbaugh on 9/26/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFLoadingView.h"
#import "SFPaneView.h"
#import "SFLocationViewController.h"
#import "SFRadarViewController.h"
#import "SFSitegeistViewController.h"
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAMediaTimingFunction.h>

@interface SFSitegeistViewController ()

@property (nonatomic, retain) SFLoadingView *loadingView;

@end

@implementation SFSitegeistViewController

@synthesize radarController = _radarController;
@synthesize censusController = _censusController;
@synthesize housingController = _housingController;
@synthesize cultureController = _cultureController;
@synthesize environmentController = _environmentController;
@synthesize historyController = _historyController;

@synthesize currentController = _currentController;

@synthesize pageControl = _pageControl;

@synthesize controllerIndex = _controllerIndex;
@synthesize isSliding = _isSliding;

- (void)viewDidLoad
{

    [super viewDidLoad];
    
    _controllerIndex = 1;
    _isSliding = NO;
    
    UIButton *sunlightButton = [[UIButton alloc] init];
    [sunlightButton setImage:[UIImage imageNamed:@"61-sunlight"] forState:UIControlStateNormal];
    [sunlightButton addTarget:self action:@selector(about) forControlEvents:UIControlEventTouchUpInside];
    [sunlightButton setFrame:CGRectMake(0, 0, 27, 27)];
    
    UIButton *locationButton = [[UIButton alloc] init];
    [locationButton setImage:[UIImage imageNamed:@"74-location"] forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(locate) forControlEvents:UIControlEventTouchUpInside];
    [locationButton setFrame:CGRectMake(0, 0, 27, 27)];
    
//    UIBarButtonItem *sunlightButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"61-sunlight"]
//                                                                       style:UIBarButtonItemStyleBordered
//                                                                      target:self
//                                                                      action:@selector(about)];
//
//    UIBarButtonItem *locationButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"74-location"]
//                                                                       style:UIBarButtonItemStyleBordered
//                                                                      target:self
//                                                                      action:@selector(locate)];

    self.navigationItem.title = @"Sitegeist";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sunlightButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:locationButton];
    
    CGRect contentFrame = self.view.frame;
    
    _radarController = [[SFRadarViewController alloc] init];
    [_radarController.view setFrame:contentFrame];

    _censusController = [[SFPaneViewController alloc] init];
    [_censusController.view setFrame:contentFrame];
    [_censusController loadURL:@"http://sitegeist.s3.amazonaws.com/census.html"];
    [_censusController fakeIt:@"people.jpg"];
    
    _housingController = [[SFPaneViewController alloc] init];
    [_housingController.view setFrame:contentFrame];
    [_housingController fakeIt:@"housing.jpg"];
    
    _cultureController = [[SFPaneViewController alloc] init];
    [_cultureController.view setFrame:contentFrame];
    [_cultureController loadURL:@"http://sitegeist.s3.amazonaws.com/culture.html"];
    [_cultureController fakeIt:@"fun.jpg"];
    
    _environmentController = [[SFPaneViewController alloc] init];
    [_environmentController.view setFrame:contentFrame];
    [_environmentController loadURL:@"http://sitegeist.s3.amazonaws.com/environment.html"];
    [_environmentController fakeIt:@"environment.jpg"];
    
    _historyController = [[SFPaneViewController alloc] init];
    [_historyController.view setFrame:contentFrame];
    [_historyController fakeIt:@"history.jpg"];

    [self addChildViewController:_radarController];
    [self addChildViewController:_censusController];
    [self addChildViewController:_housingController];
    [self addChildViewController:_cultureController];
    [self addChildViewController:_environmentController];
    [self addChildViewController:_historyController];
    
    _currentController = [self.childViewControllers objectAtIndex:_controllerIndex];
    _currentController.view.frame = self.navigationController.view.frame;
    
    [self.view addSubview:_currentController.view];
    [_currentController didMoveToParentViewController:self];
    
    _pageControl = [[UIPageControl alloc] init];
    [_pageControl setFrame:CGRectMake(0.0, contentFrame.size.height, self.view.frame.size.width, 20.0)];
    [_pageControl setNumberOfPages:[self.childViewControllers count]];
    [_pageControl addTarget:self action:@selector(paginate:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:_pageControl];
    
    NSLog(@"Current page: %d", _controllerIndex);
    [_pageControl setCurrentPage:_controllerIndex];
    
    [self createGestureRecognizer];
    
    self.loadingView = [[SFLoadingView alloc] initWithFrame:contentFrame];
    [self.loadingView setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.95]];
    
    [_currentController reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showLoadingMessage:(NSString *)message
{
    [self.loadingView.messageLabel setText:message];
    [self.parentViewController.view addSubview:self.loadingView];
}

- (void)locate
{
    [self presentModalViewController:[[SFLocationViewController alloc] init] animated:YES];
}

- (void)about
{
    [self showLoadingMessage:@"Refreshing data"];
//    [self presentModalViewController:[[SFRadarViewController alloc] init] animated:YES];
}

- (void)paginate:(id)sender forEvent:(UIEvent *)event
{
    NSLog(@"paginate: %d to %d", _controllerIndex, _pageControl.currentPage);
    if (_pageControl.currentPage > _controllerIndex) {
        [self nextPane];
    } else if (_pageControl.currentPage < _controllerIndex) {
        [self previousPane];
    }
}

- (void)reloadCurrentPane
{

}

- (void)nextPane
{
    NSLog(@"next pane");
    if (_controllerIndex < self.childViewControllers.count - 1 && !_isSliding) {
        _controllerIndex += 1;
        SFPaneViewController *next = [self.childViewControllers objectAtIndex:_controllerIndex];
        [self transitionPane:next direction:SFPaneDirectionRight];
    }
}

- (void)previousPane
{
    NSLog(@"previous pane");
    if (_controllerIndex > 0 && !_isSliding) {
        _controllerIndex -= 1;
        SFPaneViewController *next = [self.childViewControllers objectAtIndex:_controllerIndex];
        [self transitionPane:next direction:SFPaneDirectionLeft];
    }
}

- (void)transitionPane:(SFPaneViewController *)next direction:(SFPaneDirection)dir
{
    
    if (!_isSliding) {
    
        _isSliding = YES;
        
        CGRect nextFrame = self.view.frame;
        if (dir == SFPaneDirectionRight) {
            nextFrame.origin.x = CGRectGetMaxX(nextFrame);
        } else if (dir == SFPaneDirectionLeft) {
            nextFrame.origin.x = -CGRectGetMaxX(nextFrame);
        }
        next.view.frame = nextFrame;
        
        [self transitionFromViewController:_currentController
                          toViewController:next
                                  duration:0.2f
                                   options:UIViewAnimationOptionTransitionNone
                                animations:^{
                                    CGRect frame = self.view.frame;
                                    next.view.frame = frame;
                                    if (dir == SFPaneDirectionRight) {
                                        frame.origin.x -= frame.size.width;
                                    } else if (dir == SFPaneDirectionLeft) {
                                        frame.origin.x = frame.size.width;
                                    }
                                    _currentController.view.frame = frame;
                                }
                                completion:^(BOOL finished) {
                                        [next didMoveToParentViewController:self];
                                        [_pageControl setCurrentPage:_controllerIndex];
                                        _currentController = next;
                                        _isSliding = NO;
                                    }];
        
    }
    
}

- (void)createGestureRecognizer
{
    UISwipeGestureRecognizer *swipeLeftGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeLeftGR.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftGR];
    
    UISwipeGestureRecognizer *swipeRightGR = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    swipeRightGR.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeRightGR];
    
}

- (void)handleSwipe:(UISwipeGestureRecognizer *)swipeGR
{
    if (swipeGR.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"swipe left");
        [self nextPane];
    } else if (swipeGR.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"swipe right");
        [self previousPane];
    }
}

@end
