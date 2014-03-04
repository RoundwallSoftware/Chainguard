//
//  RWSPriceInputManagerTests.m
//  Manifest
//
//  Created by Samuel Goodwin on 06-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RWSPriceInputManager.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface RWSPriceInputManagerTests : XCTestCase{
    UITextField *textField;
}
@end

@implementation RWSPriceInputManagerTests

- (void)setUp
{
    [super setUp];

    textField = [[UITextField alloc] init];
}

- (void)testInputtingDollarSignOnBlankField
{
    textField.text = nil;

    setCurrencyOnTextField(@"USD", textField);

    assertThat(textField.text, equalTo(@"$"));
}

- (void)testChangingCurrencyToDollars
{
    textField.text = @"€32.32";

    setCurrencyOnTextField(@"USD", textField);

    assertThat(textField.text, equalTo(@"$32.32"));
}

- (void)testChangingCurrencyWithDecimalAtEnd
{
    textField.text = @"€32.";

    setCurrencyOnTextField(@"USD", textField);

    assertThat(textField.text, equalTo(@"$32"));
}

- (void)testInputtingEuroSignOnBlankField
{
    textField.text = nil;

    setCurrencyOnTextField(@"EUR", textField);

    assertThat(textField.text, equalTo(@"€"));
}

- (void)testChangingCurrencyToEuro
{
    textField.text = @"$32.32";

    setCurrencyOnTextField(@"EUR", textField);

    assertThat(textField.text, equalTo(@"€32.32"));
}

- (void)testChangingCurrencyToEurosWithDecimalAtEnd
{
    textField.text = @"£32.";

    setCurrencyOnTextField(@"EUR", textField);

    assertThat(textField.text, equalTo(@"€32"));
}

@end
