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
    NSLocale *USLocale;
}
@end

@implementation RWSPriceInputManagerTests

- (void)setUp
{
    [super setUp];

    textField = [[UITextField alloc] init];
    USLocale = [NSLocale localeWithLocaleIdentifier:@"en-US"];
}

- (void)testInputtingDollarSignOnBlankField
{
    textField.text = nil;

    setCurrencyOnTextField(@"USD", USLocale, textField);

    assertThat(textField.text, equalTo(@"$"));
}

- (void)testInputtingDollarSignTwiceOnBlankField
{
    textField.text = nil;

    setCurrencyOnTextField(@"USD", USLocale, textField);
    setCurrencyOnTextField(@"USD", USLocale, textField);

    assertThat(textField.text, equalTo(@"$"));
}

- (void)testInputtingDollarSignTwiceOnBlankFieldInCanada
{
    textField.text = nil;
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en-CA"];

    setCurrencyOnTextField(@"USD", locale, textField);
    setCurrencyOnTextField(@"USD", locale, textField);

    assertThat(textField.text, equalTo(@"US$"));
}

- (void)testChangingCurrencyToDollars
{
    textField.text = @"€32.32";

    setCurrencyOnTextField(@"USD", USLocale, textField);

    assertThat(textField.text, equalTo(@"$32.32"));
}

- (void)testChangingCurrencyWithDecimalAtEnd
{
    textField.text = @"€32.";

    setCurrencyOnTextField(@"USD", USLocale, textField);

    assertThat(textField.text, equalTo(@"$32.00"));
}

- (void)testInputtingEuroSignOnBlankField
{
    textField.text = nil;

    setCurrencyOnTextField(@"EUR", USLocale, textField);

    assertThat(textField.text, equalTo(@"€"));
}

- (void)testChangingCurrencyToEuro
{
    textField.text = @"$32.32";

    setCurrencyOnTextField(@"EUR", USLocale, textField);

    assertThat(textField.text, equalTo(@"€32.32"));
}

- (void)testChangingCurrencyToEurosWithDecimalAtEnd
{
    textField.text = @"£32.";

    setCurrencyOnTextField(@"EUR", USLocale, textField);

    assertThat(textField.text, equalTo(@"€32.00"));
}

@end
