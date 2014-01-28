//
//  RWSListViewControllerTests.m
//  Manifest
//
//  Created by Samuel Goodwin on 26-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

@import XCTest;

#import "RWSProjectsViewController.h"
#import "RWSProjectsSource.h"
#import "RWSProjectCell.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface RWSProjectsViewControllerTests : XCTestCase{
    RWSProjectsViewController *controller;
}

@end

@implementation RWSProjectsViewControllerTests

- (void)setUp
{
    [super setUp];

    controller = [[RWSProjectsViewController alloc] init];
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
    RWSProjectsSource *source = mock([RWSProjectsSource class]);
    controller.projectSource = source;

    [controller tableView:nil numberOfRowsInSection:0];

    [verify(source) count];
}

- (void)testControllerUsesListCellForLists
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableView *mockTable = mock([UITableView class]);
    RWSProjectsSource *source = mock([RWSProjectsSource class]);
    controller.projectSource = source;

    [controller tableView:mockTable cellForRowAtIndexPath:indexPath];

    [verify(mockTable) dequeueReusableCellWithIdentifier:@"list" forIndexPath:indexPath];
}

- (void)testControllerAsksSourceForListToMatchIndexPath
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableView *table = mock([UITableView class]);
    RWSProjectCell *cell = mock([RWSProjectCell class]);
    id<RWSProject> list = mockProtocol(@protocol(RWSProject));
    RWSProjectsSource *source = mock([RWSProjectsSource class]);
    controller.projectSource = source;

    [given([table dequeueReusableCellWithIdentifier:@"list" forIndexPath:indexPath]) willReturn:cell];
    [given([source projectAtIndexPath:indexPath]) willReturn:list];

    [controller tableView:table cellForRowAtIndexPath:indexPath];

    [verify(source) projectAtIndexPath:indexPath];
    [verify(cell) setList:list];
}

@end
