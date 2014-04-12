//
//  RWSPriceFormatterTests.m
//  Manifest
//
//  Created by Samuel Goodwin on 30-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RWSPriceFormatter.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface RWSPriceFormatterTests : XCTestCase{
    RWSPriceFormatter *formatter;
}

@end

@implementation RWSPriceFormatterTests

- (void)setUp
{
    [super setUp];

    formatter = [[RWSPriceFormatter alloc] init];
    formatter.locale = [NSLocale currentLocale];
}

- (void)testFormatterFormatsWholeNumbersAndDollars
{
    assertThat([formatter stringFromNumber:@5 currency:@"USD"], equalTo(@"$5.00"));
    assertThat([formatter stringFromNumber:@25 currency:@"USD"], equalTo(@"$25.00"));
    assertThat([formatter stringFromNumber:@15 currency:@"USD"], equalTo(@"$15.00"));
}

- (void)testFormatterFormatsFractionNumbersAndDollars
{
    assertThat([formatter stringFromNumber:@5.12 currency:@"USD"], equalTo(@"$5.12"));
    assertThat([formatter stringFromNumber:@25.43 currency:@"USD"], equalTo(@"$25.43"));
    assertThat([formatter stringFromNumber:@15.34 currency:@"USD"], equalTo(@"$15.34"));
}

@end
