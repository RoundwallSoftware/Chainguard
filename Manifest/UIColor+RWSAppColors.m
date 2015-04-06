//
//  UIColor+RWSAppColors.m
//  Manifest
//
//  Created by Samuel Goodwin on 02-05-14.
//
//

#import "UIColor+RWSAppColors.h"

@implementation UIColor (RWSAppColors)

+ (instancetype)tintColor
{
    return [self colorWithRed:89.0/255.0 green:89.0/255.0 blue:207.0/255.0 alpha:1.0];
}

+ (instancetype)secondaryColor
{
    return [self colorWithRed:137.0/255.0 green:137.0/255.0 blue:159.0/255.0 alpha:1.0];
}

+ (instancetype)accentColor
{
    return [self colorWithRed:215.0/255.0 green:127.0/255.0 blue:82.0/255.0 alpha:1.0];
}

@end
