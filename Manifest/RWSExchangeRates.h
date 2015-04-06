//
//  RWSExchangeRates.h
//  Manifest
//
//  Created by Samuel Goodwin on 04-03-14.
//
//

extern NSString *const RWSFormattedLastTimeExchangeRateUpdated;

@interface RWSExchangeRates : NSObject

- (void)updateRatesWithCompletionHandler:(void (^)(UIBackgroundFetchResult))block;

@property (readonly, copy) NSArray *supportedCurrencyCodes;
- (NSDecimalNumber *)convertPrice:(NSDecimalNumber *)price fromCurrencyCode:(NSString *)fromCode toCurrencyCode:(NSString *)toCode;

@end
