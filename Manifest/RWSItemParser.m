//
//  RWSItemParser.m
//  Manifest
//
//  Created by Samuel Goodwin on 30-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSItemParser.h"
#import "NSLocale+RWSCurrency.h"

@interface RWSItemParser()
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSDecimalNumber *price;
@property (nonatomic, copy) NSString *currencyCode;
@end

@implementation RWSItemParser

- (void)setText:(NSString *)text
{
    id<RWSItemParserDelegate> delegate = self.delegate;

    NSArray *currencyCodes = @[@"USD"];
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    NSCharacterSet *charSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];

    for(NSString *currencyCode in currencyCodes){
        NSLocale *locale = [NSLocale currentLocaleWithCurrency:currencyCode];
        NSString *currencySymbol = [locale objectForKey:NSLocaleCurrencySymbol];

        if([text rangeOfString:currencySymbol].location != NSNotFound){
            self.currencyCode = currencyCode;

            NSArray *stringChunks = [text componentsSeparatedByString:currencySymbol];
            self.name = [[stringChunks firstObject] stringByTrimmingCharactersInSet:charSet];
            if([[stringChunks lastObject] length]){
                self.price = [NSDecimalNumber decimalNumberWithString:[[stringChunks lastObject] stringByTrimmingCharactersInSet:charSet]];
            }

            [delegate parserDidFinishParsing:self];
            return;
        }
    }

    self.name = [text stringByTrimmingCharactersInSet:charSet];
    [delegate parserDidFinishParsing:self];
}

@end
