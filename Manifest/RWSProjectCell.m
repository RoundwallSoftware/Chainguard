//
//  RWSListCell.m
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSProjectCell.h"

@implementation RWSProjectCell

- (void)setList:(id<RWSProject>)project
{
    self.textLabel.text = [project title];

    NSString *priceString = [project formattedTotalRemainingPrice];
    self.detailTextLabel.text = priceString;
}

@end
