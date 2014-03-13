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
#import "RWSExchangeRates.h"

@interface RWSItemParser()
@end

@implementation RWSItemParser

- (id<RWSItem>)itemFromText:(NSString *)text
{
    RWSDumbItem *item = [[RWSDumbItem alloc] init];
    RWSExchangeRates *rates = [[RWSExchangeRates alloc] init];

    NSArray *currencyCodes = [rates supportedCurrencyCodes];
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceAndNewlineCharacterSet];

    for(NSString *currencyCode in currencyCodes){
        NSLocale *locale = [NSLocale currentLocaleWithCurrency:currencyCode];
        NSString *currencySymbol = [locale currencySymbol];
        NSUInteger currencySymbolIndex = [text rangeOfString:currencySymbol].location;

        if(currencySymbolIndex == NSNotFound){
            continue;
        }

        item.currencyCode = currencyCode;

        NSScanner *scanner = [[NSScanner alloc] initWithString:text];
        [scanner setScanLocation:currencySymbolIndex+1];

        NSDecimal price;
        BOOL foundCurrency = [scanner scanDecimal:&price];
        if(!foundCurrency){
            text = [text stringByReplacingOccurrencesOfString:currencySymbol withString:@""];
            continue;
        }

        item.price = [NSDecimalNumber decimalNumberWithDecimal:price];
        item.currencyCode = currencyCode;

        NSRange priceRange = NSMakeRange(currencySymbolIndex, [scanner scanLocation]-currencySymbolIndex);

        item.name = [[text stringByReplacingCharactersInRange:priceRange withString:@""] stringByTrimmingCharactersInSet:whiteSpace];

        return item;
    }

    item.name = [text stringByTrimmingCharactersInSet:whiteSpace];
    return item;
}

@end
