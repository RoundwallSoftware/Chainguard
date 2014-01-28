//
//  RWSProjectViewControllerTests.m
//  Manifest
//
//  Created by Samuel Goodwin on 28-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

@import XCTest;
#import "RWSProject.h"
#import "RWSProjectViewController.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface RWSFakeProject : NSObject<RWSProject>

@end

@implementation RWSFakeProject

- (NSString *)title
{
    return @"Fake";
}

@end

@interface RWSProjectViewControllerTests : XCTestCase{
    RWSProjectViewController *controller;
}
@end

@implementation RWSProjectViewControllerTests

- (void)setUp
{
    [super setUp];

    controller = [[RWSProjectViewController alloc] init];
}

- (void)testProjectAcceptsAProject
{
    RWSFakeProject *project = [[RWSFakeProject alloc] init];

    controller.project = project;

    assertThat(controller.title, equalTo(project.title));
}

@end
