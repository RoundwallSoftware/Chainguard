//
//  RWSListCell.m
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSProjectCell.h"
#import "RWSPriceFormatter.h"
#import "NSLocale+RWSCurrency.h"

@implementation RWSProjectCell

- (void)setList:(id<RWSProject>)list
{
    self.textLabel.text = [list title];

    RWSPriceFormatter *formatter = [[RWSPriceFormatter alloc] init];
    NSString *currencyCode = [[NSLocale currentLocale] currencyCode];
    self.detailTextLabel.text = [formatter stringFromNumber:[list totalRemainingPriceWithCurrencyCode:currencyCode] currency:currencyCode];
}

@end
