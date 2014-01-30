//
//  RWSList.h
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

@import Foundation;

@protocol RWSItem <NSObject>
- (NSString *)name;
@end

@protocol RWSProject <NSObject>
@property (nonatomic, copy) NSString *title;

- (NSUInteger)count;
- (id<RWSItem>)itemAtIndexPath:(NSIndexPath *)indexPath;

- (void)addItemToList:(id<RWSItem>)item;
@end