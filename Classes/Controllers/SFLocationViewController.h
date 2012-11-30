//
//  SFLocationViewController.h
//  Sitegeist iOS
//
//  Created by Jeremy Carbaugh on 10/2/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import "MapPinAnnotation.h"
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface SFLocationViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, retain) IBOutlet UIButton *cancelButton;
@property (nonatomic, retain) IBOutlet UIButton *homeButton;
@property (nonatomic, retain) IBOutlet UIButton *localButton;

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation;

@end
