//
//  SFPaneViewController.m
//  Sitegeist iOS
//
//  Created by Jeremy Carbaugh on 9/27/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFPaneView.h"
#import "SFPaneViewController.h"

@interface SFPaneViewController () <UIWebViewDelegate>

@property (nonatomic, retain) NSString* urlEndpoint;

@end

@implementation SFPaneViewController

@synthesize backgroundColor = _backgroundColor;
@synthesize paneView = _paneView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _paneView = [[SFPaneView alloc] init];
    [_paneView setDelegate:self];
    [_paneView setBackgroundColor:[UIColor colorWithRed:0.30f green:0.29f blue:0.29f alpha:1.0f]];
    self.view = _paneView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fakeIt:(NSString *)mock
{

    UIImage *img = [UIImage imageNamed:mock];
    UIImageView *mockView = [[UIImageView alloc] initWithImage:img];
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    [scrollView addSubview:mockView];
    [scrollView setContentSize:img.size];
    [scrollView setScrollEnabled:YES];
    [scrollView setScrollsToTop:YES];
    
    self.view = scrollView;
    
}

- (void)setEndpointAndLoad:(NSString *)urlString
{
    NSLog(@"Set endpoint: %@", urlString);
    self.urlEndpoint = urlString;
    [self loadURL:urlString];
}

- (void)loadURL:(NSString *)urlString
{
    [_paneView fadeOut];
    
    NSLog(@"Loading endpoint: %@", urlString);
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *cll = [userDefaults arrayForKey:@"cll"];
    if (!cll) {
        // default to the Sunlight office
        cll = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:38.906956], [NSNumber numberWithFloat:-77.042883], nil];
    }
    
    NSString *builder = [urlString stringByAppendingString:@"?"];
    builder = [builder stringByAppendingFormat:@"cll=%@,%@&", cll[0], cll[1]];
    builder = [builder stringByAppendingString:@"highres=1&"];
    
    NSLog(@"Loading URL: %@", builder);
    
    NSURL *url = [NSURL URLWithString:builder];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_paneView loadRequest:request];
    [_paneView updateConstraints];
    _paneView.hasLoadedPage = YES;
    
}

- (void)reloadData
{
    /* use AFNetworking to get JSON call to endpoint */
    NSString *jsonStr = @"{bbq: 'tastes good'}";
    NSString *js = [NSString stringWithFormat:@"console.log(%@);", jsonStr];
    [_paneView stringByEvaluatingJavaScriptFromString:js];
}

- (void)reloadPane
{
    NSLog(@"Reloading endpoint: %@", self.urlEndpoint);
    [self loadURL:self.urlEndpoint];
}


/*
 * UIWebViewDelegate methods
 */

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"Web view did finish loading");
    [_paneView fadeIn];
}

- (BOOL)webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if (inType == UIWebViewNavigationTypeLinkClicked) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }
    return YES;
}

@end
