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
            self.rates = @{
                           @"AED": @"3.673093",
                           @"AFN": @"57.068175",
                           @"ALL": @"101.2689",
                           @"AMD": @"416.708001",
                           @"ANG": @"1.78904",
                           @"AOA": @"97.599676",
                           @"ARS": @"7.882199",
                           @"AUD": @"1.100134",
                           @"AWG": @"1.79",
                           @"AZN": @"0.784033",
                           @"BAM": @"1.413938",
                           @"BBD": @"2",
                           @"BDT": @"77.550181",
                           @"BGN": @"1.416111",
                           @"BHD": @"0.377011",
                           @"BIF": @"1555.228333",
                           @"BMD": @"1",
                           @"BND": @"1.260606",
                           @"BOB": @"6.875275",
                           @"BRL": @"2.321575",
                           @"BSD": @"1",
                           @"BTC": @"0.0015364936",
                           @"BTN": @"61.077075",
                           @"BWP": @"8.780181",
                           @"BYR": @"9809.32",
                           @"BZD": @"1.975385",
                           @"CAD": @"1.100601",
                           @"CDF": @"919.166504",
                           @"CHF": @"0.880202",
                           @"CLF": @"0.02374",
                           @"CLP": @"558.963302",
                           @"CNY": @"6.119414",
                           @"COP": @"2033.58335",
                           @"CRC": @"507.870708",
                           @"CUP": @"22.682881",
                           @"CVE": @"79.49492",
                           @"CZK": @"19.75124",
                           @"DJF": @"178.557",
                           @"DKK": @"5.389699",
                           @"DOP": @"42.97278",
                           @"DZD": @"77.66126",
                           @"EEK": @"11.622175",
                           @"EGP": @"6.958426",
                           @"ERN": @"15.002825",
                           @"ETB": @"19.22817",
                           @"EUR": @"0.721211",
                           @"FJD": @"1.855289",
                           @"FKP": @"0.597697",
                           @"GBP": @"0.597697",
                           @"GEL": @"1.74832",
                           @"GHS": @"2.546528",
                           @"GIP": @"0.597697",
                           @"GMD": @"38.0894",
                           @"GNF": @"7027.506667",
                           @"GTQ": @"7.706395",
                           @"GYD": @"204.328332",
                           @"HKD": @"7.760434",
                           @"HNL": @"19.40451",
                           @"HRK": @"5.528492",
                           @"HTG": @"44.77548",
                           @"HUF": @"223.443899",
                           @"IDR": @"11446.616667",
                           @"ILS": @"3.462691",
                           @"INR": @"61.03635",
                           @"IQD": @"1164.501633",
                           @"IRR": @"24910.666667",
                           @"ISK": @"112.598001",
                           @"JEP": @"0.597697",
                           @"JMD": @"107.8228",
                           @"JOD": @"0.708012",
                           @"JPY": @"102.8649",
                           @"KES": @"86.53997",
                           @"KGS": @"53.79175",
                           @"KHR": @"3992.401667",
                           @"KMF": @"355.814474",
                           @"KPW": @"900",
                           @"KRW": @"1062.606683",
                           @"KWD": @"0.281491",
                           @"KYD": @"0.824872",
                           @"KZT": @"181.751001",
                           @"LAK": @"8036.5",
                           @"LBP": @"1504.938333",
                           @"LKR": @"130.585801",
                           @"LRD": @"85.5",
                           @"LSL": @"10.60232",
                           @"LTL": @"2.493296",
                           @"LVL": @"0.50674",
                           @"LYD": @"1.241644",
                           @"MAD": @"8.122576",
                           @"MDL": @"13.59148",
                           @"MGA": @"2345.133333",
                           @"MKD": @"44.76675",
                           @"MMK": @"972.15122",
                           @"MNT": @"1757",
                           @"MOP": @"7.96647",
                           @"MRO": @"289.6892",
                           @"MTL": @"0.683602",
                           @"MUR": @"30.11102",
                           @"MVR": @"15.38173",
                           @"MWK": @"422.9418",
                           @"MXN": @"13.17154",
                           @"MYR": @"3.253209",
                           @"MZN": @"31.99265",
                           @"NAD": @"10.60712",
                           @"NGN": @"163.763601",
                           @"NIO": @"25.3175",
                           @"NOK": @"5.975765",
                           @"NPR": @"97.50001",
                           @"NZD": @"1.178655",
                           @"OMR": @"0.385035",
                           @"PAB": @"1",
                           @"PEN": @"2.79077",
                           @"PGK": @"2.611533",
                           @"PHP": @"44.4588",
                           @"PKR": @"103.4558",
                           @"PLN": @"3.020594",
                           @"PYG": @"4413.899987",
                           @"QAR": @"3.641322",
                           @"RON": @"3.248929",
                           @"RSD": @"83.79411",
                           @"RUB": @"36.21719",
                           @"RWF": @"678.3386",
                           @"SAR": @"3.75051",
                           @"SBD": @"7.270475",
                           @"SCR": @"12.2142",
                           @"SDG": @"5.675028",
                           @"SEK": @"6.396372",
                           @"SGD": @"1.264764",
                           @"SHP": @"0.597697",
                           @"SLL": @"4334.666667",
                           @"SOS": @"1042.3981",
                           @"SRD": @"3.283333",
                           @"STD": @"17725.75",
                           @"SVC": @"8.705484",
                           @"SYP": @"143.283749",
                           @"SZL": @"10.61272",
                           @"THB": @"32.28572",
                           @"TJS": @"4.808925",
                           @"TMT": @"2.851833",
                           @"TND": @"1.572577",
                           @"TOP": @"1.863333",
                           @"TRY": @"2.189207",
                           @"TTD": @"6.362341",
                           @"TWD": @"30.16819",
                           @"TZS": @"1630.45",
                           @"UAH": @"9.284629",
                           @"UGX": @"2513.743333",
                           @"USD": @"1",
                           @"UYU": @"22.28075",
                           @"UZS": @"2237.106637",
                           @"VEF": @"6.291875",
                           @"VND": @"21090.816667",
                           @"VUV": @"96.434999",
                           @"WST": @"2.332538",
                           @"XAF": @"474.472912",
                           @"XAG": @"0.04646069",
                           @"XAU": @"0.00073116",
                           @"XCD": @"2.70152",
                           @"XDR": @"0.645837",
                           @"XOF": @"475.383981",
                           @"XPF": @"86.423361",
                           @"YER": @"214.946499",
                           @"ZAR": @"10.63375",
                           @"ZMK": @"5252.024745",
                           @"ZMW": @"5.996967",
                           @"ZWL": @"322.355006",
                           };
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
    return [[NSString alloc] initWithFormat:@"[%@] Supporting %lu currencies.", [self class], (unsigned long)[[self supportedCurrencyCodes] count]];
}

- (NSDecimalNumber *)convertPrice:(NSDecimalNumber *)price fromCurrencyCode:(NSString *)fromCode toCurrencyCode:(NSString *)toCode
{
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp scale:2
                                       raiseOnExactness:NO raiseOnOverflow:YES raiseOnUnderflow:YES raiseOnDivideByZero:YES];
    NSDecimalNumber *fromRate = [NSDecimalNumber decimalNumberWithString:self.rates[fromCode]];
    NSDecimalNumber *toRate = [NSDecimalNumber decimalNumberWithString:self.rates[toCode]];

    return [[price decimalNumberByDividingBy:fromRate withBehavior:roundUp] decimalNumberByMultiplyingBy:toRate withBehavior:roundUp];
}

@end
