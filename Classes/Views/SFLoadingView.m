//
//  SFLoadingView.m
//  Sitegeist iOS
//
//  Created by Jeremy Carbaugh on 10/19/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFLoadingView.h"

@implementation SFLoadingView

@synthesize closeButton = _closeButton;
@synthesize messageLabel = _messageLabel;
@synthesize spinner = _spinner;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    
        _messageLabel = [[UILabel alloc] init];
        [_messageLabel setBackgroundColor:[UIColor clearColor]];
        [_messageLabel setFont:[UIFont systemFontOfSize:18.0]];
        [_messageLabel setTextAlignment:NSTextAlignmentCenter];
        [_messageLabel setTextColor:[UIColor colorWithRed:0.96f green:0.96f blue:0.93f alpha:1.0f]];
        [_messageLabel setText:@""];
        [_messageLabel setFrame:CGRectMake(0, 150, 320, 50)];
        [self addSubview:_messageLabel];
        
        _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_spinner startAnimating];
        [_spinner setFrame:CGRectMake(0, 220, 320, 50)];
        [self addSubview:_spinner];
        
        _closeButton = [[UIButton alloc] init];
        [_closeButton setBackgroundColor:[UIColor grayColor]];
        [_closeButton setTitle:@"Close" forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(closeOverlay) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setFrame:CGRectMake(50, 300, 220, 30)];
        [self addSubview:_closeButton];
        
        [self setBackgroundColor:[UIColor blackColor]];
        [self setOpaque:NO];
        
    }
    return self;
}

- (void)closeOverlay
{
    [self removeFromSuperview];
}

@end
