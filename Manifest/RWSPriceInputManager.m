//
//  RWSPriceInputManager.m
//  Manifest
//
//  Created by Samuel Goodwin on 06-02-14.
//
//

#import "RWSPriceInputManager.h"
#import "NSLocale+RWSCurrency.h"
#import "RWSPriceFormatter.h"

void setCurrencyOnTextField(NSString *currencyCode, NSLocale *locale, UITextField *textField)
{
    NSLocale *localeForCurrency = [locale localeWithCurrency:currencyCode];
    NSCharacterSet *punctuationSet = [NSCharacterSet characterSetWithCharactersInString:[localeForCurrency objectForKey:NSLocaleDecimalSeparator]];

    NSString *strippedString = [textField.text stringByTrimmingCharactersInSet:punctuationSet];
    NSScanner *scanner = [[NSScanner alloc] initWithString:strippedString];
    NSMutableCharacterSet *exclusionSet = [NSMutableCharacterSet letterCharacterSet];
    [exclusionSet formUnionWithCharacterSet:[NSCharacterSet symbolCharacterSet]];
    [scanner setCharactersToBeSkipped:exclusionSet];

    double price;
    BOOL foundNumber = [scanner scanDouble:&price];

    RWSPriceFormatter *priceFormatter = [[RWSPriceFormatter alloc] init];
    priceFormatter.locale = localeForCurrency;

    if(foundNumber){
        [textField setText:[priceFormatter stringFromNumber:@(price) currency:currencyCode]];
    } else {
        [textField setText:[localeForCurrency currencySymbol]];
    }
}
