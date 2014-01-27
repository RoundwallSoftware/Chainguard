//
//  RWSCoreDataControllerTests.m
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

@import XCTest;
#import "RWSCoreDataController.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface RWSCoreDataControllerTests : XCTestCase{
    RWSCoreDataController *controller;
}

@end

@implementation RWSCoreDataControllerTests

- (void)setUp
{
    [super setUp];

    controller = [[RWSCoreDataController alloc] init];
}

- (void)testControllerGeneratesValidMainContext
{
    NSManagedObjectContext *context = [controller mainContext];
    assertThat(context, notNilValue());

    NSPersistentStoreCoordinator *coordinator = [context persistentStoreCoordinator];
    assertThat(coordinator, notNilValue());

    assertThat(@([[coordinator persistentStores] count]), greaterThanOrEqualTo(@1));
}

@end
