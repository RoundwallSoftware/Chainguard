//
//  RWSItemCell.m
//  Manifest
//
//  Created by Samuel Goodwin on 08-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSItemCell.h"
#import "RWSPriceFormatter.h"
#import "NSMutableArray+SWUtilityButtons.h"
#import "UIColor+iOS7Colors.h"

@implementation RWSItemCell

- (void)setItem:(id<RWSItem>)item
{
    NSMutableArray *leftButtons = [[NSMutableArray alloc] init];
    if([item isPurchased]){
        [leftButtons sw_addUtilityButtonWithColor:[UIColor iOS7darkBlueColor] title:@"Undo"];
    }else{
        [leftButtons sw_addUtilityButtonWithColor:[UIColor iOS7greenColor] title:@"Got it"];
    }
    self.leftUtilityButtons = leftButtons;

    NSMutableArray *rightButtons = [[NSMutableArray alloc] init];
    [rightButtons sw_addUtilityButtonWithColor:[UIColor iOS7redColor] title:@"Delete"];
    self.rightUtilityButtons = rightButtons;

    self.textLabel.text = item.name;
    if([item isPurchased]){
        self.textLabel.attributedText = [[NSAttributedString alloc] initWithString:item.name attributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleSingle)}];
    }else{
        self.textLabel.attributedText = [[NSAttributedString alloc] initWithString:item.name attributes:@{NSStrikethroughStyleAttributeName: @(NSUnderlineStyleNone)}];
    }

    if(item.price){
        RWSPriceFormatter *formatter = [[RWSPriceFormatter alloc] init];
        NSString *priceString = [formatter stringFromNumber:item.price currency:item.currencyCode];
        self.detailTextLabel.text = priceString;
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
