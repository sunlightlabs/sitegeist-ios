//
//  SFLocationViewController.m
//  ; iOS
//
//  Created by Jeremy Carbaugh on 10/2/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "MapPinAnnotation.h"
#import "SFLocationView.h"
#import "SFLocationViewController.h"
#import "SFSitegeistViewController.h"
#import "WildcardGestureRecognizer.h"
#import <MapKit/MapKit.h>

@interface SFLocationViewController ()

@property BOOL mapMoved;
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic, retain) MapPinAnnotation *mapPin;

@end

@implementation SFLocationViewController

@synthesize cancelButton = _cancelButton;
@synthesize homeButton = _homeButton;
@synthesize localButton = _localButton;

- (void)viewDidAppear:(BOOL)animated
{
    self.mapMoved = NO;
        
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *cll = [userDefaults objectForKey:@"cll"];
    if (!cll) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Welcome to Sitegeist!"
                                                        message:@"To start, we'll need you to select your current location. Swipe and pinch the map to move around. Tap and hold to drop a pin on your desired location."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }

    [self setView:[[SFLocationView alloc] init]];
    [self.view setBackgroundColor:[UIColor colorWithRed:0.30f green:0.29f blue:0.29f alpha:1.0f]];
    
    NSLog(@"location view frame: %@", NSStringFromCGRect(self.parentViewController.view.frame));
    
    _localButton = [[UIButton alloc] init];
    [_localButton setBackgroundColor:[UIColor colorWithRed:0.72f green:0.67f blue:0.76f alpha:1.0f]];
    [_localButton setFrame:CGRectMake(10.0, 360.0, 300.0, 40.0)];
    [_localButton setTitle:@"Set Current Location" forState:UIControlStateNormal];
    [_localButton addTarget:self action:@selector(setCurrentLocation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_localButton];
    
    
    if (cll) {
        
//            _homeButton = [[UIButton alloc] init];
//            [_homeButton setBackgroundColor:[UIColor colorWithRed:0.72f green:0.67f blue:0.76f alpha:1.0f]];
//            [_homeButton setFrame:CGRectMake(10.0, 370.0, 300.0, 40.0)];
//            [_homeButton setTitle:@"Set Home Location" forState:UIControlStateNormal];
//            [_homeButton addTarget:self action:@selector(setHomeLocation) forControlEvents:UIControlEventTouchUpInside];
//            [self.view addSubview:_homeButton];
        
        _cancelButton = [[UIButton alloc] init];
        [_cancelButton setBackgroundColor:[UIColor lightGrayColor]];
        [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelLocation) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setFrame:CGRectMake(10.0, 410.0, 300.0, 40.0)];
        [self.view addSubview:_cancelButton];
        
    }
    
    UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [longPressGr setMinimumPressDuration:0.3];
    

    WildcardGestureRecognizer *tapInterceptor = [[WildcardGestureRecognizer alloc] init];
    tapInterceptor.touchesBeganCallback = ^(NSSet * touches, UIEvent * event) {
        NSLog(@"touched map");
        self.mapMoved = YES;
    };
    
    UILabel *howtoLabel = [[UILabel alloc] init];
    [howtoLabel setBackgroundColor:[UIColor clearColor]];
    [howtoLabel setFrame:CGRectMake(0, 325.0, 320.0, 15.0)];
    [howtoLabel setFont:[UIFont systemFontOfSize:11.0]];
    [howtoLabel setTextColor:[UIColor lightGrayColor]];
    [howtoLabel setTextAlignment:NSTextAlignmentCenter];
    [howtoLabel setText:@"Tap and hold to drop pin in new location"];
    [self.view addSubview:howtoLabel];
    
    self.mapView = [[MKMapView alloc] init];
    [self.mapView setFrame:CGRectMake(0.0, 0.0, 320.0, 320.0)];
    [self.mapView setDelegate:self];
    [self.mapView addGestureRecognizer:longPressGr];
    [self.mapView addGestureRecognizer:tapInterceptor];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    [self.mapView setShowsUserLocation:YES];
    
    [self.view addSubview:self.mapView];
    
    if (self.mapPin == nil) {
        self.mapPin = [[MapPinAnnotation alloc] init];
        [self.mapView addAnnotation:self.mapPin];
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.mapView setShowsUserLocation:NO];
}

- (void)setLocationForKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    CLLocationCoordinate2D loc = self.mapView.centerCoordinate;
    NSArray *locArray = [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:loc.latitude], [NSNumber numberWithDouble:loc.longitude], nil];
    [userDefaults setObject:locArray forKey:key];
    [userDefaults synchronize];
}

- (void)setHomeLocation
{
    [self setLocationForKey:@"hll"];
    [self closeLocationAndReload:YES]; // just to close the view controller
}

- (void)setCurrentLocation
{
    [self setLocationForKey:@"cll"];
    [self closeLocationAndReload:YES]; // just to close the view controller
}

- (void)cancelLocation
{
    [self closeLocationAndReload:NO];
}

- (void)closeLocationAndReload:(BOOL)reload
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *cll = [userDefaults arrayForKey:@"cll"];
    if (!cll) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Where are you?!"
                                                        message:@"Sitegeist can't work without you selecting a location. Please do so."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        [self.mapView setUserTrackingMode:MKUserTrackingModeNone animated:NO];
        [self.mapView setShowsUserLocation:NO];
        
        SFSitegeistViewController *mainController = self.presentingViewController.childViewControllers[0];
        
        if (reload) {
            [self dismissViewControllerAnimated:YES completion:^(){
                [mainController reloadCurrentThenOtherPanes];
            }];
        } else {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }

}

#pragma mark - UIGestureRecognizer

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    self.mapMoved = YES;

    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D coord = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    [self.mapView setCenterCoordinate:coord animated:YES];
    [self.mapPin setCoordinate:coord];
}

#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (!self.mapMoved) {
//        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 2000.0, 2000.0);
//        [mapView setRegion:region animated:TRUE];
        [self.mapPin setCoordinate:userLocation.coordinate];
    }
}

@end
