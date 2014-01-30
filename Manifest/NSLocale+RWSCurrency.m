//
//  NSLocale+RWSCurrency.m
//  Parts
//
//  Created by Samuel Goodwin on 23-11-13.
//  Copyright (c) 2013 Roundwall Software. All rights reserved.
//

#import "NSLocale+RWSCurrency.h"

@implementation NSLocale (RWSCurrency)

+ (NSLocale *)currentLocaleWithCurrency:(NSString *)currency
{
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSDictionary *components = @{
                                 NSLocaleCurrencyCode: currency,
                                 NSLocaleLanguageCode: [currentLocale objectForKey:NSLocaleLanguageCode],
                                 NSLocaleCountryCode: [currentLocale objectForKey:NSLocaleCountryCode]
                                 };

    NSString *identifier = [NSLocale localeIdentifierFromComponents:components];
    return [NSLocale localeWithLocaleIdentifier:identifier];
}

@end
