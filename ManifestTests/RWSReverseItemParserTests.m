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
    [parser setPriceInput:@"$2"];

    assertThat([parser inputString], equalTo(@"$2"));
}

- (void)testParserGeneratesTogether
{
    [parser setPriceInput:@"$43.21"];
    [parser setName:@"Dude"];

    assertThat([parser inputString], equalTo(@"Dude $43.21"));
}

@end
