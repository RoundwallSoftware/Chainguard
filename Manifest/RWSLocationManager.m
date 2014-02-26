
//
//  RWSLocationManager.m
//  Manifest
//
//  Created by Samuel Goodwin on 01-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSLocationManager.h"

NSString *const RWSAutoLocationEnabled = @"AYIAutoLocationEnabled";

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
        id<RWSLocationManagerDelegate> delegate = self.delegate;
        if(!placemarks){
            self.placemark = nil;
            [delegate locationManagerDidFailToDetermineLocation:self];
        }else{
            self.placemark = [placemarks firstObject];
            [delegate locationManagerDidDetermineLocation:self];
        }
    }];

    self.geocoder = geocoder;
}

+ (BOOL)isAutoLocationEnabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:RWSAutoLocationEnabled];
}

- (void)enableAutoUpdates
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:RWSAutoLocationEnabled];
}

@end
