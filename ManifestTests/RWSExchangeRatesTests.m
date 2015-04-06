//
//  RWSExchangeRatesTests.m
//  Manifest
//
//  Created by Samuel Goodwin on 04-03-14.
//
//

#import <XCTest/XCTest.h>
#import "RWSExchangeRates.h"
#import "NSLocale+RWSCurrency.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface RWSExchangeRatesTests : XCTestCase

@end

@implementation RWSExchangeRatesTests

- (void)testDefaultCurrency
{
    assertThat([[NSLocale localeWithLocaleIdentifier:@"en-US"] currencyCode], equalTo(@"USD"));
    assertThat([[NSLocale localeWithLocaleIdentifier:@"en-FR"] currencyCode], equalTo(@"EUR"));
    assertThat([[NSLocale localeWithLocaleIdentifier:@"en-UK"] currencyCode], equalTo(@"GBP"));
}

@end
