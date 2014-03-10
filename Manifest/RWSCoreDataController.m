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

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidReceiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
}

- (void)applicationDidReceiveMemoryWarning:(NSNotification *)notification
{
    NSManagedObjectContext *context = self.mainContext;
    [context performBlock:^{
        NSError *savingError;
        BOOL saved = [context save:&savingError];
        if(!saved){
            NSException *saveException = [NSException exceptionWithName:@"Failed to save for memory warning" reason:[saveError localizedDescription] userInfo:[saveError userInfo]];
            [saveException raise];
        }

    }];
}

- (void)applicationWillResignActive:(NSNotification* )notification
{
    NSManagedObjectContext *context = [self mainContext];
    UIBackgroundTaskIdentifier task = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSException *backgroundException = [NSException exceptionWithName:@"Failed to finish background saving" reason:@"Probably took too long" userInfo:nil];
        [backgroundException raise];
    }];

    [context performBlock:^{
        NSError *saveError;
        BOOL saved = [context save:&saveError];
        if(!saved){
            NSException *saveException = [NSException exceptionWithName:@"Failed to save in background" reason:[saveError localizedDescription] userInfo:[saveError userInfo]];
            [saveException raise];
        }

        [[UIApplication sharedApplication] endBackgroundTask:task];
    }];
}

@end
