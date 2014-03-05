//
//  RWSExchangeRates.h
//  Manifest
//
//  Created by Samuel Goodwin on 04-03-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

extern NSString *const RWSFormattedLastTimeExchangeRateUpdated;

@interface RWSExchangeRates : NSObject

- (void)updateRatesWithCompletionHandler:(void (^)(UIBackgroundFetchResult))block;

- (NSArray *)supportedCurrencyCodes;
- (NSDecimalNumber *)convertPrice:(NSDecimalNumber *)price fromCurrencyCode:(NSString *)fromCode toCurrencyCode:(NSString *)toCode;

@end
