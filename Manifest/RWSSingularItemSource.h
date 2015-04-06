//
//  RWSSingularItemSource.h
//  Manifest
//
//  Created by Samuel Goodwin on 22-05-14.
//
//

#import "RWSMapItemSource.h"
#import "RWSProject.h"

@interface RWSSingularItemSource : NSObject<RWSMapItemSource>
- (instancetype)initWithItem:(id<RWSItem>)item;
@end
