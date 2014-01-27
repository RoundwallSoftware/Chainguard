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
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@end

@implementation RWSListSource

- (NSString *)debugDescription
{
    return [[self.fetchedResultsController fetchedObjects] debugDescription];
}

- (id)initWithCoreDataController:(RWSCoreDataController *)controller;
{
    self = [super init];
    if(self){
        NSManagedObjectContext *mainContext = [controller mainContext];

        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[RWSManagedList entityName]];
        [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:RWSManagedListAttributes.title ascending:YES]]];

        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:mainContext sectionNameKeyPath:nil cacheName:nil];

        NSError *fetchError;
        BOOL fetched = [self.fetchedResultsController performFetch:&fetchError];
        if(!fetched){
            abort();
        }
    }
    return self;
}

- (NSUInteger)listCount
{
    id<NSFetchedResultsSectionInfo> info = [[self fetchedResultsController] sections][0];
    return [info numberOfObjects];
}

- (id<RWSList>)listAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.fetchedResultsController objectAtIndexPath:indexPath];
}

@end
