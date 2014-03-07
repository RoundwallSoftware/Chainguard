#import "RWSManagedProject.h"
#import "RWSManagedItem.h"
#import "RWSPriceFormatter.h"
#import "NSLocale+RWSCurrency.h"

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
    managedItem.purchasedValue = [item isPurchased];
    managedItem.notes = item.notes;

    NSMutableOrderedSet *items = self.itemsSet;
    [items addObject:managedItem];
    [self setItems:items];
}

- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath
{
    RWSManagedItem *item = (RWSManagedItem*)[self itemAtIndexPath:indexPath];
    [self removeItemFromList:item];
}

- (void)removeItemFromList:(id<RWSItem>)item
{
    NSMutableOrderedSet *items = [self itemsSet];
    NSParameterAssert([items indexOfObject:item] != NSNotFound);
    [items removeObject:item];

    self.items = items;
}

- (NSDecimalNumber *)totalRemainingPriceWithCurrencyCode:(NSString *)code
{
    NSDecimalNumber *total = [NSDecimalNumber zero];
    for(RWSManagedItem *item in self.items){
        if([item price] && ![item isPurchased]){
            total = [total decimalNumberByAdding:[item priceInCurrency:code]];
        }
    }
    return total;
}

- (void)moveItemAtIndexPath:(NSIndexPath *)sourcePath toIndexPath:(NSIndexPath *)destinationPath
{
    NSMutableOrderedSet *set = [self itemsSet];
    [set moveObjectsAtIndexes:[NSIndexSet indexSetWithIndex:sourcePath.row] toIndex:destinationPath.row];

    self.items = set;
}

#pragma mark - UIActivityItemSource

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    RWSPriceFormatter *formatter = [[RWSPriceFormatter alloc] init];

    NSString *titleString = [@"Project: " stringByAppendingString:self.title];
    NSLocale *locale = [NSLocale currentLocale];
    NSString *currencyCode = [locale currencyCode];
    NSString *priceString = [@"Total: " stringByAppendingString:[formatter stringFromNumber:[self totalRemainingPriceWithCurrencyCode:currencyCode] currency:currencyCode]];
    NSString *itemString = [[[[self items] valueForKey:@"lineItemString"] array] componentsJoinedByString:@"\n"];

    return [@[titleString, @"", itemString, @"", priceString] componentsJoinedByString:@"\n"];
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return @"Project";
}

- (NSString *)projectIdentifier
{
    return [[[self objectID] URIRepresentation] absoluteString];
}

@end
