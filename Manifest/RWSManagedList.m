#import "RWSManagedList.h"


@interface RWSManagedList ()
@end

@implementation RWSManagedList

+ (instancetype)makeUntitledListInContext:(NSManagedObjectContext *)context
{
    RWSManagedList *list = [self insertInManagedObjectContext:context];
    list.title = [self nextAppropriateUntitledTitleInContext:context];

    [context performBlockAndWait:^{
        NSError *saveError;
        BOOL created = [context save:&saveError];
        if(!created){
            abort();
        }
    }];

    return list;
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

+ (NSArray *)allListsInContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:RWSManagedListAttributes.title ascending:YES]]];
    NSError *fetchError;
    NSArray *results = [context executeFetchRequest:request error:&fetchError];

    if(!results){
        abort();
    }

    return results;
}

@end
