//
//  RWSReverseItemParserTests.m
//  Manifest
//
//  Created by Samuel Goodwin on 08-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RWSReverseItemParser.h"

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

@interface RWSReverseItemParserTests : XCTestCase{
    RWSReverseItemParser *parser;
}

@end

@implementation RWSReverseItemParserTests

- (void)setUp
{
    [super setUp];

    parser = [[RWSReverseItemParser alloc] init];
}

- (void)testParserGeneratesAName
{
    [parser setName:@"Something"];

    assertThat([parser inputString], equalTo(@"Something"));
}

- (void)testParserGeneratesJustPrice
{
    [parser setPrice:[NSDecimalNumber decimalNumberWithString:@"2"]];
    [parser setCurrencyCode:@"USD"];

    assertThat([parser inputString], equalTo(@"$2"));
}

@end
