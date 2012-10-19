//
//  SFPrimaryViewController.h
//  Sitegeist iOS
//
//  Created by Jeremy Carbaugh on 9/26/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "SFPaneViewController.h"
#import "SFRadarViewController.h"
#import <UIKit/UIKit.h>

typedef enum {
    SFPaneDirectionLeft,
    SFPaneDirectionRight
} SFPaneDirection;

@interface SFSitegeistViewController : UIViewController

@property (nonatomic, retain) SFRadarViewController *radarController;
@property (nonatomic, retain) SFPaneViewController *censusController;
@property (nonatomic, retain) SFPaneViewController *housingController;
@property (nonatomic, retain) SFPaneViewController *cultureController;
@property (nonatomic, retain) SFPaneViewController *environmentController;
@property (nonatomic, retain) SFPaneViewController *historyController;

@property (nonatomic, retain) SFPaneViewController *currentController;

@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;

@property (nonatomic, assign) int controllerIndex;
@property (nonatomic, assign) BOOL isSliding;

- (void)reloadCurrentPane;

@end
