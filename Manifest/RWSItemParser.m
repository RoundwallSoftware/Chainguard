//
//  RWSItemParser.m
//  Manifest
//
//  Created by Samuel Goodwin on 30-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSItemParser.h"
#import "RWSDumbItem.h"
#import "NSLocale+RWSCurrency.h"

@interface RWSItemParser()
@end

@implementation RWSItemParser

- (id<RWSItem>)itemFromText:(NSString *)text
{
    RWSDumbItem *item = [[RWSDumbItem alloc] init];

    NSArray *currencyCodes = @[@"USD"];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];

    for(NSString *currencyCode in currencyCodes){
        NSLocale *locale = [NSLocale currentLocaleWithCurrency:currencyCode];
        NSString *currencySymbol = [locale objectForKey:NSLocaleCurrencySymbol];

        if([text rangeOfString:currencySymbol].location != NSNotFound){
            item.currencyCode = currencyCode;

            NSArray *stringChunks = [text componentsSeparatedByString:currencySymbol];
            item.name = [[stringChunks firstObject] stringByTrimmingCharactersInSet:charSet];
            if([[stringChunks lastObject] length]){
                item.price = [NSDecimalNumber decimalNumberWithString:[[stringChunks lastObject] stringByTrimmingCharactersInSet:charSet]];
            }

            return item;
        }
    }

    item.name = [text stringByTrimmingCharactersInSet:charSet];
    return item;
}

@end
