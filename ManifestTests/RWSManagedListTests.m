//
//  RWSManagedListTests.m
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

@import XCTest;
@import CoreData;
#import "RWSManagedList.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface RWSManagedListTests : XCTestCase{
    NSPersistentStoreCoordinator *storeCoordinator;
    NSManagedObjectContext *testContext;
}

@end

@implementation RWSManagedListTests

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
    RWSManagedList *list = [RWSManagedList makeUntitledListInContext:testContext];

    assertThat([list title], equalTo(@"Untitled"));
}

- (void)testCreatingMultipleNewUntitledLists
{
    RWSManagedList *list = [RWSManagedList makeUntitledListInContext:testContext];

    assertThat([list title], equalTo(@"Untitled"));

    RWSManagedList *list2 = [RWSManagedList makeUntitledListInContext:testContext];

    assertThat([list2 title], equalTo(@"Untitled 2"));

    RWSManagedList *list3 = [RWSManagedList makeUntitledListInContext:testContext];

    assertThat([list3 title], equalTo(@"Untitled 3"));
}

@end
