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

    return [NSString stringWithFormat:@"Untitled %@", @([results count]+1)];
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
    return [self.items count];
}

- (id<RWSItem>)itemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.items objectAtIndex:indexPath.row];
}

- (void)addItemToList:(id<RWSItem>)item
{
    RWSManagedItem *managedItem = [RWSManagedItem insertInManagedObjectContext:[self managedObjectContext]];
    managedItem.name = item.name;
    managedItem.price = item.price;
    managedItem.currencyCode = item.currencyCode;
    managedItem.latitudeValue = item.coordinate.latitude;
    managedItem.longitudeValue = item.coordinate.longitude;
    managedItem.addressString = item.addressString;

    NSMutableOrderedSet *items = self.itemsSet;
    [items addObject:managedItem];
    [self setItems:items];
}

- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath
{
    RWSManagedItem *item = (RWSManagedItem*)[self itemAtIndexPath:indexPath];

    NSMutableOrderedSet *items = [self itemsSet];
    [items removeObject:item];

    self.items = items;
}

- (NSDecimalNumber *)totalRemainingPriceWithCurrencyCode:(NSString *)code
{
    NSDecimalNumber *total = [NSDecimalNumber zero];
    for(RWSManagedItem *item in self.items){
        if([item price]){
            total = [total decimalNumberByAdding:[item price]];
        }
    }
    return total;
}

- (NSArray *)annotations
{
    NSOrderedSet *items = [self items];
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[items count]];
    for(RWSManagedItem *item in items){
        if([item latitudeValue] != 0 && [item longitudeValue] != 0){
            [annotations addObject:item];
        }
    }

    return annotations;
}

@end
