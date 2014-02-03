//
//  RWSMapViewControllerTests.m
//  Manifest
//
//  Created by Samuel Goodwin on 03-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RWSMapViewController.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface RWSMapViewControllerTests : XCTestCase{
    RWSMapViewController *controller;
}
@end

@implementation RWSMapViewControllerTests

- (void)setUp
{
    [super setUp];

    controller = [[RWSMapViewController alloc] init];
}

- (void)testControllerAsksSourceForItems
{
    id<RWSMapItemSource> source = mockProtocol(@protocol(RWSMapItemSource));
    controller.itemSource = source;

    [controller viewDidLoad];

    [verify(source) annotations];
}

@end
