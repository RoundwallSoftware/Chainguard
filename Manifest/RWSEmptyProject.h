//
//  RWSEmptyProject.h
//  Manifest
//
//  Created by Samuel Goodwin on 05-04-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSProject.h"

@interface RWSEmptyProject : NSObject<RWSProject>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) NSString *projectIdentifier;
@property (nonatomic, copy) NSString *preferredCurrencyCode;

@end
