//
//  MapPinAnnotation.h
//  Sitegeist iOS
//
//  Created by Jeremy Carbaugh on 10/3/12.
//  Copyright (c) 2012 Sunlight Foundation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapPinAnnotation : NSObject <MKAnnotation> {

    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *subtitle;

}

@end