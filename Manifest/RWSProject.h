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

@protocol RWSPhoto <NSObject>
- (void)setImageData:(NSData *)data;
- (UIImage *)image;
@end

@protocol RWSItem <NSObject>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSDecimalNumber *price;
@property (nonatomic, copy) NSString *currencyCode;

@property (nonatomic, copy) NSString *notes;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *addressString;

- (BOOL)isPurchased;
- (void)togglePurchased;

- (NSUInteger)photoCount;
- (id<RWSPhoto>)photoAtIndexPath:(NSIndexPath *)indexPath;
- (void)addPhotoWithImage:(UIImage *)image;
@end

@protocol RWSProject <RWSMapItemSource, UIActivityItemSource>
@property (nonatomic, copy) NSString *title;

- (NSUInteger)count;
- (id<RWSItem>)itemAtIndexPath:(NSIndexPath *)indexPath;

- (NSDecimalNumber *)totalRemainingPriceWithCurrencyCode:(NSString *)code;

- (void)addItemToList:(id<RWSItem>)item;
- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)removeItemFromList:(id<RWSItem>)item;
- (void)moveItemAtIndexPath:(NSIndexPath *)sourcePath toIndexPath:(NSIndexPath *)destinationPath;
@end
