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
    id<RWSItem> item = [parser itemFromText:@"Something"];

    assertThat(item.name, equalTo(@"Something"));
}

- (void)testParserPicksUpDollars
{
    id<RWSItem> item = [parser itemFromText:@"Something $5"];

    assertThat(item.name, equalTo(@"Something"));
    assertThat(item.price, equalTo(@5));
    assertThat(item.currencyCode, equalTo(@"USD"));
}

- (void)testParserDoesNotPickUpNanDollars
{
    id<RWSItem> item = [parser itemFromText:@"Something $"];

    assertThat(item.name, equalTo(@"Something"));
    assertThat(item.price, nilValue());
    assertThat(item.currencyCode, equalTo(@"USD"));
}

@end
