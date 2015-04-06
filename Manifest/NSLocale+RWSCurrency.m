//
//  NSLocale+RWSCurrency.m
//  Parts
//
//  Created by Samuel Goodwin on 23-11-13.
//
//

#import "NSLocale+RWSCurrency.h"

@implementation NSLocale (RWSCurrency)

- (NSLocale *)localeWithCurrency:(NSString *)currency
{
    NSMutableDictionary *components = [@{
                                 NSLocaleLanguageCode: [self objectForKey:NSLocaleLanguageCode],
                                 NSLocaleCountryCode: [self objectForKey:NSLocaleCountryCode]
                                 } mutableCopy];
    components[NSLocaleCurrencyCode] = currency;

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
