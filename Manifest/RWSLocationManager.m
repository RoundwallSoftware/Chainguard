
//
//  RWSLocationManager.m
//  Manifest
//
//  Created by Samuel Goodwin on 01-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSLocationManager.h"

@interface RWSLocationManager()
@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) CLPlacemark *placemark;
@end

@implementation RWSLocationManager

- (void)updateLocation
{
    CLLocationManager *manager = [[CLLocationManager alloc] init];
    manager.activityType = CLActivityTypeOther;
    manager.desiredAccuracy = 500.0;
    
    manager.delegate = self;
    self.manager = manager;

    [manager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];

    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        self.placemark = [placemarks firstObject];

        [self.delegate locationManagerDidDetermineLocation:self];
    }];

    self.geocoder = geocoder;
}

@end
