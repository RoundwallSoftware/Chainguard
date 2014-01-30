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

- (void)testControllerAcceptsAProject
{
    NSString *title = @"Fake Project";
    id<RWSProject> project = mockProtocol(@protocol(RWSProject));
    [given([project title]) willReturn:title];

    controller.project = project;
    [controller viewDidLoad];

    [verify(project) title];
}

- (void)testControllerAsksProjectForItemCount
{
    id<RWSProject> project = mockProtocol(@protocol(RWSProject));
    [given([project count]) willReturnInteger:3];

    controller.project = project;

    assertThatInteger([controller tableView:nil numberOfRowsInSection:0], equalToInteger(3));
}

- (void)testControllerAsksProjectForItem
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    id<RWSProject> project = mockProtocol(@protocol(RWSProject));

    controller.project = project;

    [controller tableView:nil cellForRowAtIndexPath:indexPath];

    [verify(project) itemAtIndexPath:indexPath];
}

- (void)testControllerRenamesProjectOnTextViewDelegateMethod
{
    id<RWSProject> project = mockProtocol(@protocol(RWSProject));
    controller.project = project;
    UITextField *textField = mock([UITextField class]);
    [given([textField text]) willReturn:@"Title Now"];

    BOOL shouldReturn = [controller textFieldShouldReturn:textField];
    assertThatBool(shouldReturn, equalToBool(YES));

    [verify(project) setTitle:@"Title Now"];
}

- (void)testControllerRenamesProjectOnOtherTextViewDelegateMethod
{
    id<RWSProject> project = mockProtocol(@protocol(RWSProject));
    controller.project = project;
    UITextField *textField = mock([UITextField class]);
    [given([textField text]) willReturn:@"Title Now"];

    [controller textFieldDidEndEditing:textField];

    [verify(project) setTitle:@"Title Now"];
}

- (void)testControllerAddsItemWhenModalFinishes
{
    id<RWSProject> project = mockProtocol(@protocol(RWSProject));
    controller.project = project;

    id<RWSItem> item = mockProtocol(@protocol(RWSItem));

    [controller newItemController:nil didMakeItem:item];

    [verify(project) addItemToList:item];
}

@end