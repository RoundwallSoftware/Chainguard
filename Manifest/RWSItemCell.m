//
//  RWSItemCell.m
//  Manifest
//
//  Created by Samuel Goodwin on 08-02-14.
//
//

#import "RWSItemCell.h"
#import "RWSPriceFormatter.h"
#import "UIColor+RWSAppColors.h"
#import <UIColor+iOS7Colors.h>

@implementation RWSItemCell

- (void)setItem:(id<RWSItem>)item
{
    self.textLabel.text = item.name;
    if([item isPurchased]){
        self.textLabel.attributedText = [[NSAttributedString alloc] initWithString:item.name attributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle)}];
    }else{
        self.textLabel.attributedText = [[NSAttributedString alloc] initWithString:item.name attributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleNone)}];
    }

    if(item.price){
        RWSPriceFormatter *formatter = [[RWSPriceFormatter alloc] init];
        NSString *priceString = [formatter stringFromNumber:item.price currency:item.currencyCode];
        
        if([item isPurchased]){
            self.detailTextLabel.attributedText = [[NSAttributedString alloc] initWithString:priceString attributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle)}];
        }else{
            self.detailTextLabel.attributedText = [[NSAttributedString alloc] initWithString:priceString attributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleNone)}];
        }
    }else{
        self.detailTextLabel.text = nil;
    }
}

@end
