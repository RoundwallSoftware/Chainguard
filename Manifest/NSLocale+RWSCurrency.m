//
//  NSLocale+RWSCurrency.m
//  Parts
//
//  Created by Samuel Goodwin on 23-11-13.
//  Copyright (c) 2013 Roundwall Software. All rights reserved.
//

#import "NSLocale+RWSCurrency.h"

@implementation NSLocale (RWSCurrency)

- (NSLocale *)localeWithCurrency:(NSString *)currency
{
    NSDictionary *components = @{
                                 NSLocaleCurrencyCode: currency,
                                 NSLocaleLanguageCode: [self objectForKey:NSLocaleLanguageCode],
                                 NSLocaleCountryCode: [self objectForKey:NSLocaleCountryCode]
                                 };

    NSString *identifier = [[self class] localeIdentifierFromComponents:components];
    return [[self class] localeWithLocaleIdentifier:identifier];

}

- (NSString *)currencySymbol
{
    return [self objectForKey:NSLocaleCurrencySymbol];
}

- (NSString *)currencyCode
{
    return [self objectForKey:NSLocaleCurrencyCode];
}

@end
