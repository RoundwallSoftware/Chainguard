//
//  RWSItemCell.h
//  Manifest
//
//  Created by Samuel Goodwin on 08-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "SWTableViewCell.h"
#import "RWSProject.h"

@interface RWSItemCell : SWTableViewCell
- (void)setItem:(id<RWSItem>)item;
@end
