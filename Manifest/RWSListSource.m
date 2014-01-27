//
//  RWSListSource.m
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSListSource.h"
#import "RWSManagedList.h"
#import "RWSCoreDataController.h"

@interface RWSListSource()
@property (nonatomic, strong) NSManagedObjectContext *context;
@end

@implementation RWSListSource

- (id)initWithCoreDataController:(RWSCoreDataController *)controller;
{
    self = [super init];
    if(self){
        _context = [controller mainContext];
    }
    return self;
}

- (NSUInteger)listCount
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[RWSManagedList entityName]];
    return [self.context countForFetchRequest:request error:nil];
}

- (id<RWSList>)listAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section != 0){
        return nil;
    }

    NSArray *allLists = [RWSManagedList allListsInContext:self.context];
    return allLists[indexPath.row];
}

@end
