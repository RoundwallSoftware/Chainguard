#import "RWSManagedProject.h"
#import "RWSManagedItem.h"

@implementation RWSManagedProject

+ (instancetype)makeUntitledProjectInContext:(NSManagedObjectContext *)context
{
    RWSManagedProject *project = [self insertInManagedObjectContext:context];
    project.title = [self nextAppropriateUntitledTitleInContext:context];

    [context performBlockAndWait:^{
        NSError *saveError;
        BOOL created = [context save:&saveError];
        if(!created){
            abort();
        }
    }];

    return project;
}

+ (NSString *)nextAppropriateUntitledTitleInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"title BEGINSWITH %@", @"Untitled"]];

    __block NSArray *results;
    [context performBlockAndWait:^{
        NSError *fetchError;
        results = [context executeFetchRequest:request error:&fetchError];
        if(!results){
            abort();
        }
    }];

    if([results count] == 0){
        return @"Untitled";
    }

    return [NSString stringWithFormat:@"Untitled %i", [results count]+1];
}

+ (NSArray *)allProjectsInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:RWSManagedProjectAttributes.title ascending:YES]]];
    NSError *fetchError;
    NSArray *results = [context executeFetchRequest:request error:&fetchError];

    if(!results){
        abort();
    }
    
    return results;
}

- (NSUInteger)count
{
    return 0;
}

- (id<RWSItem>)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)addItemToList:(id<RWSItem>)item
{
    NSParameterAssert([item isKindOfClass:[RWSManagedItem class]]);
    [self addItemsObject:(RWSManagedItem *)item];
}

@end
