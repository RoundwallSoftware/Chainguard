//
//  RWSManagedListTests.m
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

@import XCTest;
@import CoreData;
@import MapKit;
#import "RWSManagedProject.h"
#import "RWSDumbItem.h"

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

- (void)testAddingItemsToAList
{
    RWSManagedProject *project = [RWSManagedProject makeUntitledProjectInContext:testContext];

    assertThatInteger([project count], equalToInteger(0));

    id<RWSItem> item = mockProtocol(@protocol(RWSItem));
    [given([item name]) willReturn:@"Something"];

    [project addItemToList:item];

    assertThatInteger([project count], equalToInteger(1));

    id<RWSItem> backItem = [project itemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    assertThat([backItem name], equalTo([item name]));
}

- (void)testProjectsKnowTheirPriceTotals
{
    RWSManagedProject *project = [RWSManagedProject makeUntitledProjectInContext:testContext];
    id<RWSItem> item = mockProtocol(@protocol(RWSItem));
    [given([item name]) willReturn:@"Something"];
    [given([item price]) willReturn:@5.21];
    [given([item currencyCode]) willReturn:@"USD"];

    [project addItemToList:item];

    assertThat([project totalRemainingPrice], equalTo(@5.21));
}

- (void)testProjectsKnowTheirPriceTotalsButNotPurchasedItems
{
    RWSManagedProject *project = [RWSManagedProject makeUntitledProjectInContext:testContext];
    RWSDumbItem *item = [[RWSDumbItem alloc] init];
    item.name = @"Something";
    item.price = [NSDecimalNumber decimalNumberWithString:@"5.21"];
    item.currencyCode = @"USD";
    item.purchased = YES;

    [project addItemToList:item];

    assertThat([project totalRemainingPrice], equalTo(@0));
}

- (void)testDeletingItemsFromAList
{
    RWSManagedProject *project = [RWSManagedProject makeUntitledProjectInContext:testContext];
    id<RWSItem> item = mockProtocol(@protocol(RWSItem));
    [given([item name]) willReturn:@"Something"];

    [project addItemToList:item];

    [project removeItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];

    assertThatInteger([project count], equalToInteger(0));
}

- (void)testProjectKnowsOnlyUSDIsUsedInList
{
    RWSManagedProject *project = [RWSManagedProject makeUntitledProjectInContext:testContext];
    RWSDumbItem *item = [[RWSDumbItem alloc] init];
    item.name = @"Something";
    item.price = [NSDecimalNumber decimalNumberWithString:@"5.21"];
    item.currencyCode = @"USD";
    item.purchased = YES;

    [project addItemToList:item];

    NSArray *currencyCodes = [project currencyCodesUsed];
    assertThat(currencyCodes, contains(@"USD", nil));
}

- (void)testProjectKnowsUSDandEuroesIsUsedInList
{
    RWSManagedProject *project = [RWSManagedProject makeUntitledProjectInContext:testContext];
    RWSDumbItem *item = [[RWSDumbItem alloc] init];
    item.name = @"Something";
    item.price = [NSDecimalNumber decimalNumberWithString:@"5.21"];
    item.currencyCode = @"USD";
    item.purchased = YES;

    RWSDumbItem *item2 = [[RWSDumbItem alloc] init];
    item2.name = @"Something";
    item2.price = [NSDecimalNumber decimalNumberWithString:@"99.99"];
    item2.currencyCode = @"EUR";
    item2.purchased = YES;

    [project addItemToList:item];
    [project addItemToList:item2];

    NSArray *currencyCodes = [project currencyCodesUsed];
    assertThat(currencyCodes, contains(@"USD", @"EUR", nil));
}

- (void)testPreferredCurrencyCodeMatchesSystemDefaultInitially
{
    RWSManagedProject *project = [RWSManagedProject makeUntitledProjectInContext:testContext];
    NSString *code = [[NSLocale currentLocale] currencyCode];

    assertThat([project preferredCurrencyCode], equalTo(code));
}

@end
