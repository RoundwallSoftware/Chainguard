//
//  RWSReverseItemParser.h
//  Manifest
//
//  Created by Samuel Goodwin on 08-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWSReverseItemParser : NSObject

- (void)setName:(NSString *)name;
- (void)setPriceInput:(NSString *)priceInput;

- (NSString *)inputString;

@end