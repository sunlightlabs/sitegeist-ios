//
//  SFLoadingView.h
//  Sitegeist iOS
//
//  Created by Jeremy Carbaugh on 10/19/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFLoadingView : UIView

@property (nonatomic, retain) UILabel *messageLabel;
@property (nonatomic, retain) UIActivityIndicatorView *spinner;
@property (nonatomic, retain) UIButton *closeButton;

@end
