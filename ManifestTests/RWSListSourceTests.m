//
//  RWSListSourceTests.m
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

@import XCTest;
@import CoreData;
#import "RWSCoreDataController.h"
#import "RWSListSource.h"
#import "RWSManagedList.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface RWSListSourceTests : XCTestCase{
    NSManagedObjectContext *testContext;
    NSPersistentStoreCoordinator *storeCoordinator;
    RWSCoreDataController *coreDataController;
    RWSListSource *source;
}
@end

@implementation RWSListSourceTests

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

    RWSManagedList *list = [RWSManagedList insertInManagedObjectContext:testContext];
    list.title = @"Untitled From Test";
    assertThatBool([testContext save:nil], equalToBool(YES));

    coreDataController = mock([RWSCoreDataController class]);
    [given([coreDataController mainContext]) willReturn:testContext];

    source = [[RWSListSource alloc] initWithCoreDataController:coreDataController];
}

- (void)testListSourceKnowsTheRightNumberOfLists
{
    assertThatInteger([source listCount], equalToInteger(1));
}

- (void)testListSourceGrabsCorrectList
{
    RWSManagedList *list = [source listAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    assertThat(list, notNilValue());
    assertThat([list title], equalTo(@"Untitled From Test"));
}

@end
