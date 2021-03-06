//
//  RWSList.h
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//
//

#import "RWSMapItemSource.h"
@import Foundation;
@import CoreLocation;

@protocol RWSPhoto <NSObject>
- (void)setImage:(UIImage *)image;
- (UIImage *)fullImage;
- (UIImage *)thumbnailImage;
@end

@protocol RWSItem <UIActivityItemSource>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSDecimalNumber *price;
@property (nonatomic, copy) NSString *currencyCode;

@property (nonatomic, copy) NSString *notes;

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *addressString;

- (BOOL)isPurchased;
- (void)togglePurchased;

- (BOOL)isValid;

- (NSUInteger)photoCount;
- (id<RWSPhoto>)photoAtIndexPath:(NSIndexPath *)indexPath;
- (void)addPhotoWithImage:(UIImage *)image;
- (void)deletePhotoAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol RWSProject <UIActivityItemSource>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) NSString *projectIdentifier;
@property (nonatomic, copy) NSString *preferredCurrencyCode;

- (NSUInteger)count;
- (id<RWSItem>)itemAtIndexPath:(NSIndexPath *)indexPath;

- (NSDecimalNumber *)totalRemainingPrice;
- (NSString *)formattedTotalRemainingPrice;

- (void)addItemToList:(id<RWSItem>)item;
- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)removeItemFromList:(id<RWSItem>)item;
- (void)moveItemAtIndexPath:(NSIndexPath *)sourcePath toIndexPath:(NSIndexPath *)destinationPath;

- (NSArray *)currencyCodesUsed;
- (UIImage *)imageFromParts;
@end
