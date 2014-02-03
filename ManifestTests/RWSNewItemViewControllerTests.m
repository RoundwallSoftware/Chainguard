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

    [verify(parser) setText:@"Item Name"];
}

- (void)testControllerDoesNotFeedOtherInputToParser
{
    RWSItemParser *parser = mock([RWSItemParser class]);
    controller.parser = parser;
    UITextField *mockField = mock([UITextField class]);
    controller.nameField = mockField;

    [given([mockField text]) willReturn:@"Item Name"];

    [controller textField:mockField shouldChangeCharactersInRange:NSMakeRange(0, 1) replacementString:@"I"];

    [verifyCount(parser, never()) setText:@"Item Name"];
}

- (void)testControllerUsesParserToPopulateNameField
{
    UITextField *field = [[UITextField alloc] init];
    controller.nameField = field;

    RWSItemParser *parser = mock([RWSItemParser class]);
    [given([parser name]) willReturn:@"Something"];

    [controller parserDidFinishParsing:parser];

    assertThat([[controller nameField] text], equalTo(@"Something"));
}

- (void)testControllerUsesParserToPopulatePriceField
{
    UITextField *field = [[UITextField alloc] init];
    controller.priceField = field;

    RWSItemParser *parser = [[RWSItemParser alloc] init];
    parser.delegate = controller;
    [parser setText:@"Something $5"];

    assertThat([[controller priceField] text], equalTo(@"$5"));
}

- (void)testControllerEmptiesPriceFieldWhenParserHasNoPrice
{
    UITextField *field = [[UITextField alloc] init];
    controller.priceField = field;

    RWSItemParser *parser = mock([RWSItemParser class]);
    [given([parser price]) willReturn:nil];
    [given([parser currencyCode]) willReturn:@"USD"];

    [controller parserDidFinishParsing:parser];

    assertThat([[controller priceField] text], equalTo(@""));
}

- (void)testControllerRespondsToGetLocationAction
{
    RWSLocationManager *manager = mock([RWSLocationManager class]);
    controller.locationManager = manager;
    UILabel *label = mock([UILabel class]);
    controller.locationLabel = label;

    [controller setCurrentLocation:nil];

    [verify(manager) updateLocation];
    [verify(label) setText:@"Finding location..."];
}

- (void)testControllerHidesButtonOnGetLocationAction
{
    UIButton *button = mock([UIButton class]);

    [controller setCurrentLocation:button];

    [verify(button) setHidden:YES];
}

- (void)testControllerRespondsWhenLocationManagerFindsPlaces
{
    RWSLocationManager *manager = mock([RWSLocationManager class]);

    [controller locationManagerDidDetermineLocation:manager];

    [verify(manager) placemark];
}

@end
