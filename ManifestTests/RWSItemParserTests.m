//
//  RWSItemParserTests.m
//  Manifest
//
//  Created by Samuel Goodwin on 30-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RWSItemParser.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface RWSItemParserTests : XCTestCase{
    RWSItemParser *parser;
}

@end

@implementation RWSItemParserTests

- (void)setUp
{
    [super setUp];

    parser = [[RWSItemParser alloc] init];
}

- (void)testParserPicksUpName
{
    [parser setText:@"Something"];

    assertThat(parser.name, equalTo(@"Something"));
}

- (void)testParserPicksUpDollars
{
    [parser setText:@"Something $5"];

    assertThat(parser.name, equalTo(@"Something"));
    assertThat(parser.price, equalTo(@5));
    assertThat(parser.currencyCode, equalTo(@"USD"));
}

@end
