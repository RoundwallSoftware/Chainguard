
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
#import "RWSEmptyProject.h"

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
    NSUInteger count =  [self.context countForFetchRequest:request error:nil];
    if(count == 0u){
        return 1u;
    }
    return count;
}

- (id<RWSProject>)projectAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section != 0){
        return nil;
    }

    NSArray *allProjects = [RWSManagedProject allProjectsInContext:self.context];
    if([allProjects count] > indexPath.row){
        return allProjects[indexPath.row];
    }

    RWSEmptyProject *project = [[RWSEmptyProject alloc] init];
    return project;
}

- (NSIndexPath *)indexPathForProjectWithIdentifier:(NSString *)identifier
{
    NSArray *allProjects = [RWSManagedProject allProjectsInContext:self.context];
    for(RWSManagedProject *project in allProjects){
        if([[project projectIdentifier] isEqualToString:identifier]){
            return [NSIndexPath indexPathForRow:[allProjects indexOfObject:project] inSection:0];
        }
    }
    return nil;
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
    [request setPredicate:[NSPredicate predicateWithFormat:@"latitude != nil AND longitude != nil AND latitude != 0 AND longitude != 0"]];

    NSError *fetchError;
    NSArray *results = [[self context] executeFetchRequest:request error:&fetchError];
    if(!results){
        abort();
    }

    return results;
}

@end
