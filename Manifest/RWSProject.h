//
//  RWSList.h
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSMapItemSource.h"
@import Foundation;
@import CoreLocation;

@protocol RWSItem <NSObject>
- (NSString *)name;
- (NSDecimalNumber *)price;
- (NSString *)currencyCode;

- (CLLocationCoordinate2D)coordinate;
- (NSString *)addressString;
@end

@protocol RWSProject <RWSMapItemSource>
@property (nonatomic, copy) NSString *title;

- (NSUInteger)count;
- (id<RWSItem>)itemAtIndexPath:(NSIndexPath *)indexPath;

- (NSDecimalNumber *)totalRemainingPriceWithCurrencyCode:(NSString *)code;

- (void)addItemToList:(id<RWSItem>)item;
- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)moveItemAtIndexPath:(NSIndexPath *)sourcePath toIndexPath:(NSIndexPath *)destinationPath;
@end
