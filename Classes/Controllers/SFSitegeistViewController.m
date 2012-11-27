//
//  SFPrimaryViewController.m
//  Sitegeist iOS
//
//  Created by Jeremy Carbaugh on 9/26/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFLoadingView.h"
#import "SFPaneView.h"
#import "SFAboutViewController.h"
#import "SFLocationViewController.h"
#import "SFRadarViewController.h"
#import "SFSitegeistViewController.h"
#import "AFNetworking.h"
#import <MessageUI/MessageUI.h>
#import <QuartzCore/CAAnimation.h>
#import <QuartzCore/CAMediaTimingFunction.h>
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>

@interface SFSitegeistViewController ()

@property (nonatomic, retain) SFLoadingView *loadingView;
@property (nonatomic, retain) UIActionSheet *sharingSheet;
@property (nonatomic, retain) NSUserDefaults *defaults;
@property (nonatomic, retain) NSArray *paneSlugs;

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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] init];
    [httpClient setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            SFAboutViewController *popup = [[SFAboutViewController alloc] init];
            [self presentViewController:popup animated:YES completion:nil];
        } else {
            
        }
    }];
}

- (void)viewDidLoad
{

    [super viewDidLoad];
    
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    _controllerIndex = 0;
    _isSliding = NO;
    
    UIButton *sunlightButton = [[UIButton alloc] init];
    [sunlightButton setImage:[UIImage imageNamed:@"42-info"] forState:UIControlStateNormal];
    [sunlightButton addTarget:self action:@selector(showAboutView) forControlEvents:UIControlEventTouchUpInside];
    [sunlightButton setFrame:CGRectMake(0, 0, 27, 27)];
    
    UIButton *locationButton = [[UIButton alloc] init];
    [locationButton setImage:[UIImage imageNamed:@"74-location"] forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(showLocationView) forControlEvents:UIControlEventTouchUpInside];
    [locationButton setFrame:CGRectMake(0, 0, 27, 27)];

    self.navigationItem.title = @"Sitegeist";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sunlightButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:locationButton];
    
    CGRect contentFrame = self.view.frame;
    
    /*
     * radar controller
     */
    
//    _radarController = [[SFRadarViewController alloc] init];
//    [_radarController.view setFrame:contentFrame];
//    [self addChildViewController:_radarController];

    /*
     * create pane controllers
     */
    
    NSString *host = @"sitegeist.sunlightfoundation.com";
    self.paneSlugs = [NSArray arrayWithObjects:@"people", @"housing", @"fun", @"environment", @"history", nil];

    _censusController = [[SFPaneViewController alloc] init];
    [_censusController.view setFrame:contentFrame];
    [_censusController setEndpointAndLoad:[NSString stringWithFormat:@"http://%@/api/people/", host]];
    [self addChildViewController:_censusController];
    
    _housingController = [[SFPaneViewController alloc] init];
    [_housingController.view setFrame:contentFrame];
    [_housingController setEndpointAndLoad:[NSString stringWithFormat:@"http://%@/api/housing/", host]];
    [self addChildViewController:_housingController];
    
    _cultureController = [[SFPaneViewController alloc] init];
    [_cultureController.view setFrame:contentFrame];
    [_cultureController setEndpointAndLoad:[NSString stringWithFormat:@"http://%@/api/fun/", host]];
    [self addChildViewController:_cultureController];
    
    _environmentController = [[SFPaneViewController alloc] init];
    [_environmentController.view setFrame:contentFrame];
    [_environmentController setEndpointAndLoad:[NSString stringWithFormat:@"http://%@/api/environment/", host]];
    [self addChildViewController:_environmentController];
    
    _historyController = [[SFPaneViewController alloc] init];
    [_historyController.view setFrame:contentFrame];
    [_historyController setEndpointAndLoad:[NSString stringWithFormat:@"http://%@/api/history/", host]];
    [self addChildViewController:_historyController];
    
    _currentController = [self.childViewControllers objectAtIndex:_controllerIndex];
    _currentController.view.frame = self.navigationController.view.frame;
    
    [self.view addSubview:_currentController.view];
    [_currentController didMoveToParentViewController:self];
    
    /*
     * page indicator control
     */
    
    _pageControl = [[UIPageControl alloc] init];
    [_pageControl setBackgroundColor:[UIColor colorWithRed:0.25f green:0.25f blue:0.24f alpha:0.5f]];
    [_pageControl setFrame:CGRectMake(0.0, contentFrame.size.height - 8, self.view.frame.size.width, 30.0)];
    [_pageControl setNumberOfPages:[self.childViewControllers count]];
    [_pageControl addTarget:self action:@selector(paginate:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.view addSubview:_pageControl];
    
    [_pageControl setCurrentPage:_controllerIndex];
    
    /*
     * refresh button
     */
    
    UIButton *refreshButton = [[UIButton alloc] init];
    [refreshButton setImage:[UIImage imageNamed:@"01-refresh"] forState:UIControlStateNormal];
    [refreshButton addTarget:self action:@selector(reloadCurrentThenOtherPanes) forControlEvents:UIControlEventTouchUpInside];
    [refreshButton setFrame:CGRectMake(290, contentFrame.size.height - 2, 27, 18)];
    [self.navigationController.view addSubview:refreshButton];
    
    /*
     * share button and sharing sheet
     */
    
    UIButton *shareButton = [[UIButton alloc] init];
    [shareButton setImage:[UIImage imageNamed:@"212-action2"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [shareButton setFrame:CGRectMake(5, contentFrame.size.height - 2, 27, 18)];
    [self.navigationController.view addSubview:shareButton];
    
    self.sharingSheet = [[UIActionSheet alloc] initWithTitle:@"Share Sitegeist" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [self.sharingSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        [self.sharingSheet addButtonWithTitle:@"Twitter"];
    }
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        [self.sharingSheet addButtonWithTitle:@"Facebook"];
    }
    if ([MFMailComposeViewController canSendMail]) {
        [self.sharingSheet addButtonWithTitle:@"Email"];
    }
    [self.sharingSheet addButtonWithTitle:@"Cancel"];
    self.sharingSheet.cancelButtonIndex = self.sharingSheet.numberOfButtons - 1;
    
    /*
     * other stuff
     */
    
    [self createGestureRecognizer];
    
    self.loadingView = [[SFLoadingView alloc] initWithFrame:contentFrame];
    [self.loadingView setBackgroundColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.95]];
    
    [_currentController reloadData];
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *cll = [self.defaults arrayForKey:@"cll"];
    NSLog(@"Initial CLL: %@", cll);
    if (!cll) {
        [self showLocationView];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)share
{
    [self.sharingSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [self.sharingSheet buttonTitleAtIndex:buttonIndex];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *cll = [userDefaults arrayForKey:@"cll"];
 
    UIImage *screenshot = [self screenshot];
    NSString *url = [NSString stringWithFormat:@"http://sitegeist.sunlightfoundation.com/share/?cll=%@,%@&p=%@",
                        cll[0], cll[1], [self.paneSlugs objectAtIndex:_controllerIndex]];
    
    if ([buttonTitle isEqualToString:@"Twitter"]) {
    
        SLComposeViewController *composer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [composer setInitialText:@"Discover what's around you with Sitegeist from @sunfoundation"];
        [composer addURL:[NSURL URLWithString:url]];
        [composer addImage:screenshot];
        [self presentViewController:composer animated:YES completion:nil];
        
    } else if ([buttonTitle isEqualToString:@"Facebook"]) {
    
        SLComposeViewController *composer = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [composer setInitialText:@"Discover what's around you with Sitegeist from Sunlight Foundation."];
        [composer addURL:[NSURL URLWithString:url]];
        [composer addImage:screenshot];
        [self presentViewController:composer animated:YES completion:nil];
        
    } else if ([buttonTitle isEqualToString:@"Email"]) {
    
        NSString *body = url;
    
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"Discover what's around you with Sitegeist"];
        [mailer addAttachmentData:UIImageJPEGRepresentation(screenshot, 0.8f) mimeType:@"image/jpeg" fileName:@"sitegeist"];
        [mailer setMessageBody:body isHTML:NO];
        [self presentViewController:mailer animated:YES completion:nil];
        
    }
}

- (void)showLoadingMessage:(NSString *)message
{
    [self.loadingView.messageLabel setText:message];
    [self.parentViewController.view addSubview:self.loadingView];
}

- (void)showLocationView
{
    SFLocationViewController *locController = [[SFLocationViewController alloc] init];
    [self presentViewController:locController animated:YES completion:nil];
}

- (void)showAboutView
{
    [self presentViewController:[[SFAboutViewController alloc] init] animated:YES completion:nil];
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
    [_currentController reloadPane];
}

- (void)reloadCurrentThenOtherPanes
{
    [self reloadCurrentPane];
    for (id paneController in self.childViewControllers) {
        if ([paneController class] == [SFPaneViewController class]) {
            if (paneController != _currentController) {
                NSLog(@"Reloading other pane: %@", paneController);
                [paneController reloadPane];
            }
        }
    }
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

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)screenshot
{
    UIGraphicsBeginImageContext(_currentController.view.frame.size);
    [_currentController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *ss = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return ss;
}

@end
