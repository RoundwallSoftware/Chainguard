//
//  RWSListCell.m
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSListCell.h"

@implementation RWSListCell

- (void)setList:(id<RWSList>)list
{
    self.textLabel.text = [list title];
}

@end
