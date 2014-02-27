//
//  RWSListSource.m
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSProjectsSource.h"
#import "RWSManagedProject.h"
#import "RWSManagedItem.h"
#import "RWSCoreDataController.h"

@interface RWSProjectsSource()
@property (nonatomic, strong) RWSCoreDataController *coreDataController;
@end

@implementation RWSProjectsSource

- (NSManagedObjectContext *)context
{
    if(_context){
        return _context;
    }
    
    _coreDataController = [[RWSCoreDataController alloc] init];
    _context = _coreDataController.mainContext;

    return _context;
}

- (NSUInteger)count
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[RWSManagedProject entityName]];
    return [self.context countForFetchRequest:request error:nil];
}

- (id<RWSProject>)projectAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section != 0){
        return nil;
    }

    NSArray *allLists = [RWSManagedProject allProjectsInContext:self.context];
    return allLists[indexPath.row];
}

- (id<RWSProject>)makeUntitledList
{
    RWSManagedProject *project = [RWSManagedProject makeUntitledProjectInContext:self.context];
    return project;
}

- (void)deleteProjectAtIndexPath:(NSIndexPath *)indexPath
{
    RWSManagedProject *project = (RWSManagedProject*)[self projectAtIndexPath:indexPath];

    [self.context deleteObject:project];
}

- (NSArray *)annotations
{
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:[RWSManagedItem entityName]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"latitude != nil AND longitude != nil"]];

    NSError *fetchError;
    NSArray *results = [[self context] executeFetchRequest:request error:&fetchError];
    if(!results){
        abort();
    }

    return results;
}

@end
