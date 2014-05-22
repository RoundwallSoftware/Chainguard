//
//  RWSSingularItemSource.m
//  Manifest
//
//  Created by Samuel Goodwin on 22-05-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSSingularItemSource.h"

@interface RWSSingularItemSource()
@property (nonatomic, strong) id<RWSItem> item;
@end

@implementation RWSSingularItemSource

- (id)initWithItem:(id<RWSItem>)item
{
    self = [super init];
    if(self){
        self.item = item;
    }
    return self;
}

- (NSArray *)annotations
{
    return @[self.item];
}

@end
