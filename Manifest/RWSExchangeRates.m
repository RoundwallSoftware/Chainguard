//
//  RWSExchangeRates.m
//  Manifest
//
//  Created by Samuel Goodwin on 04-03-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSExchangeRates.h"

NSString *const RWSFormattedLastTimeExchangeRateUpdated = @"RWSFormattedLastTimeExchangeRateUpdated";

@interface RWSExchangeRates()
@property (nonatomic, copy) NSDictionary *rates;
@end

@implementation RWSExchangeRates

- (id)init
{
    self = [super init];
    if(self){
        NSData *data = [NSData dataWithContentsOfURL:[self ratesFileLocation]];
        if(data){
            NSError *jsonError;
            self.rates = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            NSParameterAssert(self.rates);
        }else{
            [self updateRatesWithCompletionHandler:nil];
        }
    }
    return self;
}

- (void)updateRatesWithCompletionHandler:(void (^)(UIBackgroundFetchResult))block
{
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://manifestsupport.roundwallsoftware.com"]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [self parseData:data];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle] forKey:RWSFormattedLastTimeExchangeRateUpdated];
        [defaults synchronize];
        NSLog(@"Committed the save date");
        if(block){
            block(UIBackgroundFetchResultNewData);
        }
    }];
    [task resume];
}

- (void)parseData:(NSData *)data
{
    NSError *jsonError;
    self.rates = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    if(self.rates){
        [data writeToURL:[self ratesFileLocation] atomically:YES];
    }
}

- (NSURL *)ratesFileLocation
{
    return [[NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES] URLByAppendingPathComponent:@"rates.json"];
}

- (NSArray *)supportedCurrencyCodes
{
    return [self.rates allKeys];
}

- (NSString *)debugDescription
{
    return [[NSString alloc] initWithFormat:@"[%@] Supporting %i currencies.", [self class], [[self supportedCurrencyCodes] count]];
}

- (NSDecimalNumber *)convertPrice:(NSDecimalNumber *)price fromCurrencyCode:(NSString *)fromCode toCurrencyCode:(NSString *)toCode
{
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp scale:2
                                       raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];
    NSDecimalNumber *fromRate = [NSDecimalNumber decimalNumberWithString:self.rates[fromCode]];
    NSDecimalNumber *toRate = [NSDecimalNumber decimalNumberWithString:self.rates[toCode]];

    return [[price decimalNumberByDividingBy:fromRate withBehavior:roundUp] decimalNumberByMultiplyingBy:toRate withBehavior:roundUp];
}

@end
