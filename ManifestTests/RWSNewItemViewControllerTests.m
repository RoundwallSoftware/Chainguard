//
//  RWSNewItemViewControllerTests.m
//  Manifest
//
//  Created by Samuel Goodwin on 30-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RWSNewItemViewController.h"
#import "RWSItemParser.h"
#import "RWSLocationManager.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface RWSNewItemViewControllerTests : XCTestCase{
    RWSNewItemViewController *controller;
}
@end

@implementation RWSNewItemViewControllerTests

- (void)setUp
{
    [super setUp];

    controller = [[RWSNewItemViewController alloc] init];
}

- (void)testControllerJustDismissesKeyboardOnReturn
{
    UITextField *mockField = mock([UITextField class]);

    BOOL shouldReturn = [controller textFieldShouldReturn:mockField];

    assertThatBool(shouldReturn, equalToBool(NO));
    [verify(mockField) resignFirstResponder];
}

- (void)testControllerFeedsQuickInputTextToParser
{
    RWSItemParser *parser = mock([RWSItemParser class]);
    controller.parser = parser;
    UITextField *mockField = mock([UITextField class]);
    controller.quickInputField = mockField;

    [given([mockField text]) willReturn:@"Item Name"];

    [controller textField:mockField shouldChangeCharactersInRange:NSMakeRange(0, 1) replacementString:@"I"];

    [verify(parser) itemFromText:@"Item Name"];
}

- (void)testControllerDoesNotFeedOtherInputToParser
{
    RWSItemParser *parser = mock([RWSItemParser class]);
    controller.parser = parser;
    UITextField *mockField = mock([UITextField class]);
    controller.nameField = mockField;

    [given([mockField text]) willReturn:@"Item Name"];

    [controller textField:mockField shouldChangeCharactersInRange:NSMakeRange(0, 1) replacementString:@"I"];

    [verifyCount(parser, never()) itemFromText:@"Item Name"];
}

- (void)testControllerUsesReverseParserForNameField
{
    RWSReverseItemParser *mockParser = mock([RWSReverseItemParser class]);
    controller.reverseParser = mockParser;
    UITextField *field = [[UITextField alloc] init];
    field.text = @"Name Of Something";
    controller.nameField = field;

    [controller textField:field shouldChangeCharactersInRange:NSMakeRange(0, 1) replacementString:@"N"];

    [verify(mockParser) setName:@"Name Of Something"];
}

- (void)testControllerUsesReverseParserForPriceField
{
    RWSReverseItemParser *mockParser = mock([RWSReverseItemParser class]);
    controller.reverseParser = mockParser;
    UITextField *field = [[UITextField alloc] init];
    field.text = @"$4";
    controller.priceField = field;

    [controller textField:field shouldChangeCharactersInRange:NSMakeRange(1, 1) replacementString:@"4"];

    [verify(mockParser) setPriceInput:@"$4"];
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
