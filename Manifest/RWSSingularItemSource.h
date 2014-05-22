//
//  RWSSingularItemSource.h
//  Manifest
//
//  Created by Samuel Goodwin on 22-05-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSMapItemSource.h"
#import "RWSProject.h"

@interface RWSSingularItemSource : NSObject<RWSMapItemSource>
- (id)initWithItem:(id<RWSItem>)item;
@end
