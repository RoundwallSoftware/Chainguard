//
//  RWSPriceInputManager.m
//  Manifest
//
//  Created by Samuel Goodwin on 06-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSPriceInputManager.h"

void setCurrencyOnTextField(NSString *currencyCode, UITextField *textField)
{
    NSCharacterSet *symbolSet = [NSCharacterSet symbolCharacterSet];
    NSCharacterSet *punctuationSet = [NSCharacterSet punctuationCharacterSet];

    NSString *justPrice = [[textField.text stringByTrimmingCharactersInSet:symbolSet] stringByTrimmingCharactersInSet:punctuationSet];

    [textField setText:[@"$" stringByAppendingString:justPrice]];
}
