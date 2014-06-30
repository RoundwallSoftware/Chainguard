//
//  RWSDumbItem.m
//  Manifest
//
//  Created by Samuel Goodwin on 03-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSDumbItem.h"

@interface RWSDumbPhoto : NSObject<RWSPhoto>
@property (nonatomic, strong) UIImage *image;
@end

@implementation RWSDumbPhoto

- (UIImage *)thumbnailImage
{
    return self.image;
}

- (UIImage *)fullImage
{
    return self.image;
}

@end

@interface RWSDumbItem()
@property (nonatomic, strong) NSMutableArray *photos;
@end

@implementation RWSDumbItem

- (void)togglePurchased
{
    self.purchased = !self.purchased;
}

- (NSUInteger)photoCount
{
    return [self.photos count];
}

- (BOOL)isValid
{
    return [self.name length] > 0;
}

- (id<RWSPhoto>)photoAtIndexPath:(NSIndexPath *)indexPath
{
    return self.photos[indexPath.row];
}

- (void)addPhotoWithImage:(UIImage *)image
{
    NSParameterAssert(image);
    if(!self.photos){
        self.photos = [NSMutableArray array];
    }

    RWSDumbPhoto *photo = [[RWSDumbPhoto alloc] init];
    photo.image = image;
    [self.photos addObject:photo];
}

- (void)deletePhotoAtIndexPath:(NSIndexPath *)indexPath{}

@end
