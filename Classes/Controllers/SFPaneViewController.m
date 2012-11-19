//
//  SFPaneViewController.m
//  Sitegeist iOS
//
//  Created by Jeremy Carbaugh on 9/27/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFPaneView.h"
#import "SFPaneViewController.h"

@interface SFPaneViewController ()

@end

@implementation SFPaneViewController

@synthesize backgroundColor = _backgroundColor;
@synthesize endpoint = _endpoint;
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

- (void)setEndpoint:(NSString *)urlString
{
    _endpoint = urlString;
}

- (void)setEndpointAndLoad:(NSString *)urlString
{
    [self setEndpoint:urlString];
    [self loadURL:urlString];
}

- (void)loadURL:(NSString *)urlString
{
    [_paneView fadeOut];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSArray *cll = [userDefaults arrayForKey:@"cll"];
    if (!cll) {
        // default to the Sunlight office
        cll = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:38.906956], [NSNumber numberWithFloat:-77.042883], nil];
    }
    
    urlString = [urlString stringByAppendingString:@"?"];
    urlString = [urlString stringByAppendingFormat:@"cll=%@,%@&", cll[0], cll[1]];
    urlString = [urlString stringByAppendingString:@"highres=1&"];
    
    NSLog(@"Loading URL: %@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_paneView loadRequest:request];
    [_paneView updateConstraints];
    _paneView.hasLoadedPage = YES;
    
    [_paneView fadeIn];
    
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
    [self loadURL:_endpoint];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [_paneView fadeIn];
}

@end
