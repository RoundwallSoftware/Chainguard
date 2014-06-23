//
//  RWSCoreDataController.h
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

@import CoreData;

@interface RWSCoreDataController : NSObject

@property (readonly, strong) NSManagedObjectContext *mainContext;
@end
