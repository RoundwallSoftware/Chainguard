//
//  RWSLocationManagerTests.m
//  Manifest
//
//  Created by Samuel Goodwin on 01-02-14.
//
//

#import <XCTest/XCTest.h>
@import CoreLocation;
#import "RWSLocationManager.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface RWSLocationManagerTests : XCTestCase{
    RWSLocationManager *manager;
}

@end

@implementation RWSLocationManagerTests

- (void)setUp
{
    [super setUp];

    manager = [[RWSLocationManager alloc] init];
}

- (void)testLocationManagerRespondsToCoreLocation
{
    id<RWSLocationManagerDelegate> delegate = mockProtocol(@protocol(RWSLocationManagerDelegate));

    [manager locationManager:nil didUpdateLocations:nil];

    [verifyCount(delegate, never()) locationManagerDidDetermineLocation:manager];
}

@end
