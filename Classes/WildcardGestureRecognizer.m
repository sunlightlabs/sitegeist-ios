//
//  WildcardGestureRecognizer.m
//  Sitegeist iOS
//
//  Created by Jeremy Carbaugh on 11/27/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "WildcardGestureRecognizer.h"

@implementation WildcardGestureRecognizer
@synthesize touchesBeganCallback;

- (id)init
{
    if (self = [super init]) {
        self.cancelsTouchesInView = NO;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (touchesBeganCallback)
        touchesBeganCallback(touches, event);
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)reset
{
}

- (void)ignoreTouch:(UITouch *)touch forEvent:(UIEvent *)event
{
}

- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer
{
    return NO;
}

- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer
{
    return NO;
}


@end
