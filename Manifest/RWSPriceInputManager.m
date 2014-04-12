//
//  RWSPriceInputManager.m
//  Manifest
//
//  Created by Samuel Goodwin on 06-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSPriceInputManager.h"
#import "NSLocale+RWSCurrency.h"
#import "RWSPriceFormatter.h"

void setCurrencyOnTextField(NSString *currencyCode, NSLocale *locale, UITextField *textField)
{
    NSLocale *localeForCurrency = [locale localeWithCurrency:currencyCode];
    NSCharacterSet *symbolSet = [NSCharacterSet symbolCharacterSet];
    NSCharacterSet *punctuationSet = [NSCharacterSet characterSetWithCharactersInString:[localeForCurrency objectForKey:NSLocaleDecimalSeparator]];

    NSString *justPrice = [[textField.text stringByTrimmingCharactersInSet:symbolSet] stringByTrimmingCharactersInSet:punctuationSet];

    RWSPriceFormatter *priceFormatter = [[RWSPriceFormatter alloc] init];
    priceFormatter.locale = localeForCurrency;

    if([justPrice length]){
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        NSNumber *price = [numberFormatter numberFromString:justPrice];

        [textField setText:[priceFormatter stringFromNumber:price currency:currencyCode]];
    } else {
        [textField setText:[localeForCurrency currencySymbol]];
    }
}
