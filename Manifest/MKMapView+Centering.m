//
//  MKMapView+Centering.m
//  Manifest
//
//  Created by Samuel Goodwin on 12/25/12.
//  Copyright (c) 2012 Samuel Goodwin. All rights reserved.
//

#import "MKMapView+Centering.h"

@implementation MKMapView (Centering)

- (void)centerMapProperly
{
    if(![self.annotations count]){
        return;
    }
    
    CLLocationCoordinate2D maxCoordinate = CLLocationCoordinate2DMake(-90.0f, -180.0f);
    CLLocationCoordinate2D minCoordinate = CLLocationCoordinate2DMake(90.0f, 180.0f);
    
    for(id<MKAnnotation> annotation in self.annotations){
        CLLocationCoordinate2D comparisonCoordinate = annotation.coordinate;
        
        maxCoordinate.longitude = fmax(maxCoordinate.longitude, comparisonCoordinate.longitude);
        maxCoordinate.latitude = fmax(maxCoordinate.latitude, comparisonCoordinate.latitude);
        
        minCoordinate.longitude = fmin(minCoordinate.longitude, comparisonCoordinate.longitude);
        minCoordinate.latitude = fmin(minCoordinate.latitude, comparisonCoordinate.latitude);
    }
    
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake((minCoordinate.latitude + maxCoordinate.latitude)/2.0f, (minCoordinate.longitude + maxCoordinate.longitude)/2.0f);
    
    
    CLLocationDegrees spanPadding = 0.027;
    MKCoordinateSpan span = MKCoordinateSpanMake(fabs(maxCoordinate.latitude - minCoordinate.latitude)+spanPadding, fabs(maxCoordinate.longitude - minCoordinate.longitude)+spanPadding);
    
    MKCoordinateRegion region = [self regionThatFits:MKCoordinateRegionMake(centerCoordinate, span)];
    [self setRegion:region animated:YES];
}

@end
