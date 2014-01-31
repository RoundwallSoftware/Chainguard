//
//  RWSItemParser.h
//  Manifest
//
//  Created by Samuel Goodwin on 30-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

@protocol RWSItemParserDelegate;

@interface RWSItemParser : NSObject
@property (nonatomic, weak) IBOutlet id<RWSItemParserDelegate> delegate;

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, strong) NSDecimalNumber *price;
@property (nonatomic, readonly, copy) NSString *currencyCode;

- (void)setText:(NSString *)text;
@end

@protocol RWSItemParserDelegate
- (void)parserDidFinishParsing:(RWSItemParser *)parser;
@end
