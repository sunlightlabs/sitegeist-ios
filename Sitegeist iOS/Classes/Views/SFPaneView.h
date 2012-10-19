//
//  SFPaneView.h
//  Sitegeist iOS
//
//  Created by Jeremy Carbaugh on 9/26/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFPaneView : UIWebView

@property (nonatomic, assign) BOOL hasLoadedPage;

- (void)fadeOut;
- (void)fadeIn;

@end
