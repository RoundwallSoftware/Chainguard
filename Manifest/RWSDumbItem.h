//
//  RWSDumbItem.h
//  Manifest
//
//  Created by Samuel Goodwin on 03-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSProject.h"

@interface RWSDumbItem : NSObject<RWSItem>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSDecimalNumber *price;
@property (nonatomic, copy) NSString *currencyCode;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *addressString;
@property (nonatomic, assign, getter = isPurchased) BOOL purchased;
@end
