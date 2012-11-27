//
//  WildcardGestureRecognizer.h
//  Sitegeist iOS
//
//  Created by Jeremy Carbaugh on 11/27/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TouchesEventBlock)(NSSet *touches, UIEvent *event);

@interface WildcardGestureRecognizer : UIGestureRecognizer {
    TouchesEventBlock touchesBeganCallback;
}
@property(copy) TouchesEventBlock touchesBeganCallback;

@end
