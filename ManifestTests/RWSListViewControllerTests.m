//
//  RWSListViewControllerTests.m
//  Manifest
//
//  Created by Samuel Goodwin on 26-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RWSListViewController.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface RWSListViewControllerTests : XCTestCase{
    RWSListViewController *controller;
}

@end

@implementation RWSListViewControllerTests

- (void)setUp
{
    [super setUp];

    controller = [[RWSListViewController alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreation
{

}

@end
