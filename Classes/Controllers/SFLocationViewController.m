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
#import <MapKit/MapKit.h>

@interface SFLocationViewController ()

@property BOOL locationSelected;

@end

@implementation SFLocationViewController

@synthesize mapView = _mapView;
@synthesize mapPin = _mapPin;

@synthesize cancelButton = _cancelButton;
@synthesize homeButton = _homeButton;
@synthesize localButton = _localButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.locationSelected = NO;
        
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
        [_localButton setFrame:CGRectMake(10.0, 320.0, 300.0, 40.0)];
        [_localButton setTitle:@"Set Current Location" forState:UIControlStateNormal];
        [_localButton addTarget:self action:@selector(setCurrentLocation) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_localButton];
        
        
        if (cll) {
            
            _homeButton = [[UIButton alloc] init];
            [_homeButton setBackgroundColor:[UIColor colorWithRed:0.72f green:0.67f blue:0.76f alpha:1.0f]];
            [_homeButton setFrame:CGRectMake(10.0, 370.0, 300.0, 40.0)];
            [_homeButton setTitle:@"Set Home Location" forState:UIControlStateNormal];
            [_homeButton addTarget:self action:@selector(setHomeLocation) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_homeButton];
                        
            _cancelButton = [[UIButton alloc] init];
            [_cancelButton setBackgroundColor:[UIColor lightGrayColor]];
            [_cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
            [_cancelButton addTarget:self action:@selector(cancelLocation) forControlEvents:UIControlEventTouchUpInside];
            [_cancelButton setFrame:CGRectMake(10.0, 420.0, 300.0, 40.0)];
            [self.view addSubview:_cancelButton];
            
        }
        
        UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [gr setMinimumPressDuration:0.3];
        
        UILabel *howtoLabel = [[UILabel alloc] init];
        [howtoLabel setBackgroundColor:[UIColor clearColor]];
        [howtoLabel setFrame:CGRectMake(0, 285.0, 320.0, 15.0)];
        [howtoLabel setFont:[UIFont systemFontOfSize:11.0]];
        [howtoLabel setTextColor:[UIColor lightGrayColor]];
        [howtoLabel setTextAlignment:NSTextAlignmentCenter];
        [howtoLabel setText:@"Tap and hold to drop pin in new location"];
        [self.view addSubview:howtoLabel];
        
        _mapView = [[MKMapView alloc] init];
        [_mapView setFrame:CGRectMake(0.0, 0.0, 320.0, 280.0)];
        [_mapView setDelegate:self];
        [_mapView addGestureRecognizer:gr];
        [_mapView setShowsUserLocation:YES];
        [self.view addSubview:_mapView];
        
        if (_mapPin == nil) {
            _mapPin = [[MapPinAnnotation alloc] init];
            [_mapView addAnnotation:_mapPin];
        }
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setLocationForKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    CLLocationCoordinate2D loc = _mapView.centerCoordinate;
    NSArray *locArray = [[NSArray alloc] initWithObjects:[NSNumber numberWithDouble:loc.latitude], [NSNumber numberWithDouble:loc.longitude], nil];
    [userDefaults setObject:locArray forKey:key];
}

- (void)setHomeLocation
{
    [self setLocationForKey:@"hll"];
    [self cancelLocation]; // just to close the view controller
}

- (void)setCurrentLocation
{
    [self setLocationForKey:@"cll"];
    [self cancelLocation]; // just to close the view controller
}

- (void)cancelLocation
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *cll = [userDefaults arrayForKey:@"cll"];
    NSLog(@"Current cll value: %@", cll);
    if (!cll) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Where are you?!"
                                                        message:@"Sitegeist can't work without you selecting a location. Please do so."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        [self dismissViewControllerAnimated:YES completion:^(){
            [((SFSitegeistViewController *)[self parentViewController]) reloadAllPanes];
        }];
    }

}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (!self.locationSelected) {
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 2000.0, 2000.0);
        [mapView setRegion:region animated:TRUE];
        [_mapPin setCoordinate:userLocation.coordinate];
    }
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    self.locationSelected = YES;

    CGPoint touchPoint = [gestureRecognizer locationInView:_mapView];
    CLLocationCoordinate2D coord = [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];
    [_mapView setCenterCoordinate:coord animated:YES];
    [_mapPin setCoordinate:coord];
}

@end
