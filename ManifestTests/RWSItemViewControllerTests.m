//
//  RWSNewItemViewControllerTests.m
//  Manifest
//
//  Created by Samuel Goodwin on 30-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RWSItemViewController.h"
#import "RWSItemParser.h"
#import "RWSLocationManager.h"  

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface RWSItemViewControllerTests : XCTestCase{
    RWSItemViewController *controller;
}
@end

@implementation RWSItemViewControllerTests

- (void)setUp
{
    [super setUp];

    controller = [[RWSItemViewController alloc] init];
}

- (void)testControllerJustDismissesKeyboardOnReturn
{
    UITextField *mockField = mock([UITextField class]);

    BOOL shouldReturn = [controller textFieldShouldReturn:mockField];

    assertThatBool(shouldReturn, isFalse());
    [verify(mockField) resignFirstResponder];
}

- (void)testControllerDoesFeedOtherInputToParser
{
    RWSItemParser *parser = mock([RWSItemParser class]);
    controller.parser = parser;
    UITextField *mockField = mock([UITextField class]);
    controller.nameField = mockField;

    [given([mockField text]) willReturn:@"Item Name"];

    [controller textField:mockField shouldChangeCharactersInRange:NSMakeRange(0, 1) replacementString:@"I"];

    [verifyCount(parser, times(1)) itemFromText:@"Item Name"];
}

- (void)testControllerRespondsToGetLocationAction
{
    RWSLocationManager *manager = mock([RWSLocationManager class]);
    controller.locationManager = manager;
    UIButton *button = mock([UIButton class]);

    [controller setCurrentLocation:button];

    [verify(manager) updateLocation];
    [verify(button) setTitle:@"Finding location..." forState:UIControlStateNormal];
}

- (void)testControllerRespondsWhenLocationManagerFindsPlaces
{
    RWSLocationManager *manager = mock([RWSLocationManager class]);

    [controller locationManagerDidDetermineLocation:manager];

    [verify(manager) placemark];
}

- (void)testControllerMakesSureCurrencySymbolInPlace
{
    UITextField *textField = [[UITextField alloc] init];
    controller.priceField = textField;

    [controller textFieldDidBeginEditing:textField];

    assertThat(textField.text, equalTo(@"$"));
}

@end
