//
//  RWSExchangeRates.m
//  Manifest
//
//  Created by Samuel Goodwin on 04-03-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSExchangeRates.h"

NSString *const RWSLastTimeExchangeRateUpdated = @"RWSLastTimeExchangeRateUpdated";

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
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:RWSLastTimeExchangeRateUpdated];
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

@end
