//
//  RWSEmptyProject.m
//  Manifest
//
//  Created by Samuel Goodwin on 05-04-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSEmptyProject.h"

@implementation RWSEmptyProject

- (NSString *)title
{
    return @"You Have No Projects Yet";
}

- (NSUInteger)count
{
    return 0;
}

- (id<RWSItem>)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSDecimalNumber *)totalRemainingPrice
{
    return [NSDecimalNumber decimalNumberWithString:@"0"];
}

- (NSString *)formattedTotalRemainingPrice
{
    return nil;
}

- (void)addItemToList:(id<RWSItem>)item{}

- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath{}

- (void)removeItemFromList:(id<RWSItem>)item{}

- (void)moveItemAtIndexPath:(NSIndexPath *)sourcePath toIndexPath:(NSIndexPath *)destinationPath{}

- (NSArray *)currencyCodesUsed
{
    return @[];
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    return nil;
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return nil;
}

- (BOOL)isSelectable
{
    return NO;
}

@end
