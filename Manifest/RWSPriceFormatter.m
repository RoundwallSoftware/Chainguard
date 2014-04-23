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
    NSParameterAssert(self.locale);

    if(!currency){
        currency = [self.locale currencyCode];
    }
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    NSLocale *locale = [self.locale localeWithCurrency:currency];

    formatter.locale = locale;
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    formatter.minimumFractionDigits = 2;

    return [formatter stringFromNumber:value];
}

- (NSLocale *)locale
{
    if(_locale){
        return _locale;
    }

    return [NSLocale currentLocale];
}

@end
