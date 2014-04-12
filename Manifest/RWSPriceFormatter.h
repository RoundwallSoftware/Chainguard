//
//  RWSPriceFormatter.h
//  Parts
//
//  Created by Samuel Goodwin on 23-11-13.
//  Copyright (c) 2013 Roundwall Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWSPriceFormatter : NSObject
@property (nonatomic, strong) NSLocale *locale;
- (NSString *)stringFromNumber:(NSNumber *)value currency:(NSString *)currency;
@end
