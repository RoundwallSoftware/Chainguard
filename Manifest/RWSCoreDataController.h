//
//  RWSCoreDataController.h
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//
//

@import CoreData;

@interface RWSCoreDataController : NSObject

@property (readonly, strong) NSManagedObjectContext *mainContext;
@end
