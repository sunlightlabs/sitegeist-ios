//
//  SFPaneViewController.h
//  Sitegeist iOS
//
//  Created by Jeremy Carbaugh on 9/27/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFPaneView.h"
#import <UIKit/UIKit.h>

@interface SFPaneViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong, readonly) SFPaneView *paneView;
@property (nonatomic, assign) NSString *endpoint;
@property (nonatomic, assign) UIColor *backgroundColor;

- (void)setEndpoint:(NSString *)urlString;
- (void)setEndpointAndLoad:(NSString *)urlString;

- (void)loadURL:(NSString *)urlString;
- (void)webViewDidFinishLoad:(UIWebView *)webView;

- (void)reloadData;
- (void)reloadPane;

- (void)fakeIt:(NSString *)mock;

@end
