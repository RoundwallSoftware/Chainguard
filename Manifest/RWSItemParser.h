//
//  RWSItemParser.h
//  Manifest
//
//  Created by Samuel Goodwin on 30-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSProject.h"

@interface RWSItemParser : NSObject
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, strong) NSDecimalNumber *price;
@property (nonatomic, readonly, copy) NSString *currencyCode;

- (id<RWSItem>)itemFromText:(NSString *)text;
@end
