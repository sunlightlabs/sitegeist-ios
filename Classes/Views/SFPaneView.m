//
//  SFPaneView.m
//  Sitegeist iOS
//
//  Created by Jeremy Carbaugh on 9/26/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFPaneView.h"

@implementation SFPaneView

@synthesize hasLoadedPage = _hasLoadedPage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _hasLoadedPage = NO;
    }
    return self;
}

- (void)fadeOut
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    [self setAlpha:0.5f];
    [UIView commitAnimations];
}

- (void)fadeIn
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    [UIView setAnimationDelegate:self];
    [self setAlpha:1.0f];
    [UIView commitAnimations];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
