//
//  RWSCoreDataController.m
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSCoreDataController.h"

@interface RWSCoreDataController()
@property (nonatomic, strong) NSManagedObjectContext *mainContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *storeCoordinator;
@end

@implementation RWSCoreDataController

- (id)init
{
    self = [super init];
    if(self){
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
        NSParameterAssert(url);

        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:url];
        NSParameterAssert(model);

        NSString *sqlFilePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
        sqlFilePath = [sqlFilePath stringByAppendingPathComponent:@"Database.coredata"];
        NSURL *sqlFileURL = [NSURL fileURLWithPath:sqlFilePath];
        
        _storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];

        NSError *storeError;
        NSPersistentStore *store = [_storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlFileURL options:nil error:&storeError];
        if(!store){
            abort();
        }

        _mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [_mainContext setPersistentStoreCoordinator:_storeCoordinator];
    }
    return self;
}

@end
