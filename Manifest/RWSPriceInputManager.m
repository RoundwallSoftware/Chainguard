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

void setCurrencyOnTextField(NSString *currencyCode, UITextField *textField)
{
    NSCharacterSet *symbolSet = [NSCharacterSet symbolCharacterSet];
    NSCharacterSet *punctuationSet = [NSCharacterSet punctuationCharacterSet];

    NSString *justPrice = [[textField.text stringByTrimmingCharactersInSet:symbolSet] stringByTrimmingCharactersInSet:punctuationSet];

    RWSPriceFormatter *priceFormatter = [[RWSPriceFormatter alloc] init];

    if([justPrice length]){
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        NSNumber *price = [numberFormatter numberFromString:justPrice];

        [textField setText:[priceFormatter stringFromNumber:price currency:currencyCode]];
    } else {
        [textField setText:[[NSLocale currentLocaleWithCurrency:currencyCode] currencySymbol]];
    }
}
