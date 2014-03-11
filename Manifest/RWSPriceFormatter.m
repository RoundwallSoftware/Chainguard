//
//  RWSPriceFormatter.m
//  Parts
//
//  Created by Samuel Goodwin on 23-11-13.
//  Copyright (c) 2013 Roundwall Software. All rights reserved.
//

#import "RWSPriceFormatter.h"
#import "NSLocale+RWSCurrency.h"

@implementation RWSPriceFormatter

- (NSString *)stringFromNumber:(NSNumber *)value currency:(NSString *)currency
{
    NSParameterAssert(currency);
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSLocale *locale = [NSLocale currentLocaleWithCurrency:currency];

    formatter.locale = locale;
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    formatter.minimumFractionDigits = 0;

    return [formatter stringFromNumber:value];
}

@end
