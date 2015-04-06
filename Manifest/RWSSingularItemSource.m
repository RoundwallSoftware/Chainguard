//
//  RWSSingularItemSource.m
//  Manifest
//
//  Created by Samuel Goodwin on 22-05-14.
//
//

#import "RWSSingularItemSource.h"

@interface RWSSingularItemSource()
@property (nonatomic, strong) id<RWSItem> item;
@end

@implementation RWSSingularItemSource

- (instancetype)initWithItem:(id<RWSItem>)item
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
