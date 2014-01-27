//
//  RWSListViewControllerTests.m
//  Manifest
//
//  Created by Samuel Goodwin on 26-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

@import XCTest;

#import "RWSListViewController.h"
#import "RWSListSource.h"
#import "RWSListCell.h"

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

- (void)testCreation
{
    assertThat(controller, notNilValue());
}

- (void)testListHasTwoSections
{
    assertThatInteger([controller numberOfSectionsInTableView:nil], equalToInteger(2));
}

#pragma mark - Second Section

- (void)testSecondSectionHasTwoCells
{
    assertThatInteger([controller tableView:nil numberOfRowsInSection:1], equalToInteger(2));
}

- (void)testSecondSectionUsesSettingsCell
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    UITableView *mockTable = mock([UITableView class]);

    [controller tableView:mockTable cellForRowAtIndexPath:indexPath];

    [verify(mockTable) dequeueReusableCellWithIdentifier:@"settings" forIndexPath:indexPath];
}

- (void)testSecondSectionUsesCreditsCell
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    UITableView *mockTable = mock([UITableView class]);

    [controller tableView:mockTable cellForRowAtIndexPath:indexPath];

    [verify(mockTable) dequeueReusableCellWithIdentifier:@"credits" forIndexPath:indexPath];
}

#pragma mark - First Section

- (void)testControllerAsksListSourceForFirstSectionCount
{
    RWSListSource *source = mock([RWSListSource class]);
    controller.listSource = source;

    [controller tableView:nil numberOfRowsInSection:0];

    [verify(source) listCount];
}

- (void)testControllerUsesListCellForLists
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableView *mockTable = mock([UITableView class]);
    RWSListSource *source = mock([RWSListSource class]);
    controller.listSource = source;

    [controller tableView:mockTable cellForRowAtIndexPath:indexPath];

    [verify(mockTable) dequeueReusableCellWithIdentifier:@"list" forIndexPath:indexPath];
}

- (void)testControllerAsksSourceForListToMatchIndexPath
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableView *table = mock([UITableView class]);
    RWSListCell *cell = mock([RWSListCell class]);
    id<RWSList> list = mockProtocol(@protocol(RWSList));
    RWSListSource *source = mock([RWSListSource class]);
    controller.listSource = source;

    [given([table dequeueReusableCellWithIdentifier:@"list" forIndexPath:indexPath]) willReturn:cell];
    [given([source listAtIndexPath:indexPath]) willReturn:list];

    [controller tableView:table cellForRowAtIndexPath:indexPath];

    [verify(source) listAtIndexPath:indexPath];
    [verify(cell) setList:list];
}

@end
