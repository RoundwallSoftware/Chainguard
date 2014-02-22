//
//  RWSDumbItem.m
//  Manifest
//
//  Created by Samuel Goodwin on 03-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSDumbItem.h"

@implementation RWSDumbItem

- (void)togglePurchased
{
    self.purchased = !self.purchased;
}

- (NSUInteger)photoCount
{
    return 0;
}

- (id<RWSPhoto>)photoAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)addPhotoWithImage:(UIImage *)image
{
    return;
}

@end
