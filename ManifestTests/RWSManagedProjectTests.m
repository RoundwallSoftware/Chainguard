//
//  RWSManagedListTests.m
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

@import XCTest;
@import CoreData;
#import "RWSManagedProject.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface RWSManagedProjectTests : XCTestCase{
    NSPersistentStoreCoordinator *storeCoordinator;
    NSManagedObjectContext *testContext;
}

@end

@implementation RWSManagedProjectTests

- (void)setUp
{
    [super setUp];

    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
    storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    NSPersistentStore *store = [storeCoordinator addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:nil];
    assertThat(store, isNot(nilValue()));

    testContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [testContext setPersistentStoreCoordinator:storeCoordinator];
}

- (void)testCreatingANewUntitledList
{
    RWSManagedProject *project = [RWSManagedProject makeUntitledProjectInContext:testContext];

    assertThat([project title], equalTo(@"Untitled"));
}

- (void)testCreatingMultipleNewUntitledLists
{
    RWSManagedProject *project = [RWSManagedProject makeUntitledProjectInContext:testContext];

    assertThat([project title], equalTo(@"Untitled"));

    RWSManagedProject *project2 = [RWSManagedProject makeUntitledProjectInContext:testContext];

    assertThat([project2 title], equalTo(@"Untitled 2"));

    RWSManagedProject *project3 = [RWSManagedProject makeUntitledProjectInContext:testContext];

    assertThat([project3 title], equalTo(@"Untitled 3"));
}

@end
