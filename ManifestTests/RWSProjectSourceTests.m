//
//  RWSListSourceTests.m
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

@import XCTest;
@import CoreData;
@import MapKit;
#import "RWSCoreDataController.h"
#import "RWSProjectsSource.h"
#import "RWSManagedProject.h"
#import "RWSDumbItem.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface RWSProjectSourceTests : XCTestCase{
    NSManagedObjectContext *testContext;
    NSPersistentStoreCoordinator *storeCoordinator;
    RWSCoreDataController *coreDataController;
    RWSProjectsSource *source;
}
@end

@implementation RWSProjectSourceTests

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

    RWSManagedProject *project = [RWSManagedProject insertInManagedObjectContext:testContext];
    project.title = @"Untitled From Test";
    assertThatBool([testContext save:nil], equalToBool(YES));

    source = [[RWSProjectsSource alloc] init];
    source.context = testContext;
}

- (void)testListSourceKnowsTheRightNumberOfLists
{
    assertThatInteger([source count], equalToInteger(1));
}

- (void)testListSourceGrabsCorrectList
{
    id<RWSProject> project = [source projectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    assertThat(project, notNilValue());
    assertThat([project title], equalTo(@"Untitled From Test"));
}

- (void)testDeletingProject
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    id<RWSProject> project = [source projectAtIndexPath:indexPath];
    [source deleteProjectAtIndexPath:indexPath];

    assertThat([testContext deletedObjects], hasItem(project));
}

- (void)testProjectSourceHasAnnotations
{
    assertThatInteger([[source annotations] count], equalToInteger(0));

    id<RWSProject> project = [source projectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    RWSDumbItem *item = [[RWSDumbItem alloc] init];
    item.coordinate = CLLocationCoordinate2DMake(32.03, -114.32);
    item.name = @"Map Item";

    [project addItemToList:item];

    RWSDumbItem *item2 = [[RWSDumbItem alloc] init];
    item.name = @"Map Item 2";

    [project addItemToList:item2];

    NSArray *annotations = [source annotations];
    assertThat(annotations, hasCountOf(1));
    assertThatBool([[annotations firstObject] conformsToProtocol:@protocol(MKAnnotation)], equalToBool(YES));
}

@end
