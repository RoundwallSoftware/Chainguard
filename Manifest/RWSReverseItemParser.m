//
//  RWSReverseItemParser.m
//  Manifest
//
//  Created by Samuel Goodwin on 08-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSReverseItemParser.h"
#import "RWSPriceFormatter.h"

@interface RWSReverseItemParser()
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *currencyCode;
@property (nonatomic, strong) NSDecimalNumber *price;
@end

@implementation RWSReverseItemParser

- (NSString *)inputString
{
    NSMutableString *string = [[NSMutableString alloc] init];
    if(self.name){
        [string appendString:self.name];
    }

    if(self.name && self.price && self.currencyCode){
        [string appendString:@" "];
    }

    if(self.price && self.currencyCode){
        RWSPriceFormatter *formatter = [[RWSPriceFormatter alloc] init];
        [string appendString:[formatter stringFromNumber:self.price currency:self.currencyCode]];
    }

    return string;
}

@end
