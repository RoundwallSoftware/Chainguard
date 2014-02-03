//
//  RWSList.h
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

@import Foundation;
@import CoreLocation;

@protocol RWSItem <NSObject>
- (NSString *)name;
- (NSDecimalNumber *)price;
- (NSString *)currencyCode;

- (CLLocationCoordinate2D)coordinates;
- (NSString *)addressString;
@end

@protocol RWSProject <NSObject>
@property (nonatomic, copy) NSString *title;

- (NSUInteger)count;
- (id<RWSItem>)itemAtIndexPath:(NSIndexPath *)indexPath;

- (NSDecimalNumber *)totalRemainingPriceWithCurrencyCode:(NSString *)code;

- (void)addItemToList:(id<RWSItem>)item;
- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath;
@end
