//
//  RWSLocationManager.h
//  Manifest
//
//  Created by Samuel Goodwin on 01-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

@import CoreLocation;

extern NSString *const RWSAutoLocationEnabled;

@protocol RWSLocationManagerDelegate;
@interface RWSLocationManager : NSObject<CLLocationManagerDelegate>
@property (nonatomic, strong, readonly) CLPlacemark *placemark;
@property (nonatomic, weak) IBOutlet id<RWSLocationManagerDelegate> delegate;

- (void)updateLocation;
+ (BOOL)isAutoLocationEnabled;
- (void)enableAutoUpdates;
- (BOOL)canGetLocations;
@end

@protocol RWSLocationManagerDelegate <NSObject>
- (void)locationManagerDidDetermineLocation:(RWSLocationManager *)manager;
- (void)locationManagerDidFailToDetermineLocation:(RWSLocationManager *)manager;
@end
