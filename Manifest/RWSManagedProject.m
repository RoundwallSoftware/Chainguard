#import "RWSManagedProject.h"
#import "RWSManagedItem.h"
#import "RWSPriceFormatter.h"
#import "NSLocale+RWSCurrency.h"
#import "RWSManagedPhoto.h"

@implementation RWSManagedProject

+ (NSArray *)search:(NSString *)searchString inContext:(NSManagedObjectContext *)context
{
    searchString = [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[cd] %@", searchString];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[self entityInManagedObjectContext:context]];
    [request setPredicate:predicate];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:RWSManagedProjectAttributes.title ascending:YES]]];
    
    NSError *fetchError;
    NSArray *results =  [context executeFetchRequest:request error:&fetchError];
    if(!results){
        NSAssert(NO, @"Error searching projects: %@", fetchError);
    }
    
    return results;
}

+ (instancetype)existingProjectWithTitle:(NSString *)title inContext:(NSManagedObjectContext *)context
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"title = %@", title]];

    NSError *fetchError;
    NSArray *projects = [context executeFetchRequest:request error:&fetchError];
    if(!projects){
        NSAssert(projects, @"Error fetching project: %@", fetchError);
    }

    NSParameterAssert([projects count] <= 1);

    return [projects firstObject];
}

- (void)awakeFromFetch
{
    [super awakeFromFetch];
    if(!self.preferredCurrencyCode){
        self.preferredCurrencyCode = [[NSLocale currentLocale] currencyCode];
    }
}

+ (instancetype)makeUntitledProjectInContext:(NSManagedObjectContext *)context // designated initializer
{
    RWSManagedProject *project = [self insertInManagedObjectContext:context];
    project.title = [self nextAppropriateUntitledTitleInContext:context];
    project.preferredCurrencyCode = [[NSLocale currentLocale] currencyCode];

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

    __block NSUInteger count;
    [context performBlockAndWait:^{
        NSError *fetchError;
        count = [context countForFetchRequest:request error:&fetchError];
        if(count == NSNotFound){
            abort();
        }
    }];

    if(count == 0){
        return @"Untitled";
    }

    return [NSString stringWithFormat:@"Untitled %@", @(count+1)];
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
    if([self count] > indexPath.row && indexPath.row >= 0){
        return self.items[indexPath.row];
    }
    
    return nil;
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

    for(NSUInteger i = 0;i < [item photoCount];i++){
        id<RWSPhoto> photo = [item photoAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [managedItem addPhotoWithImage:[photo fullImage]];
    }

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

- (NSDecimalNumber *)totalRemainingPrice
{
    NSDecimalNumber *total = [NSDecimalNumber zero];
    for(RWSManagedItem *item in self.items){
        if([item price] && ![item isPurchased]){
            total = [total decimalNumberByAdding:[item priceInCurrency:[self preferredCurrencyCode]]];
        }
    }
    return total;
}

- (NSString *)formattedTotalRemainingPrice
{
    RWSPriceFormatter *formatter = [[RWSPriceFormatter alloc] init];
    return [formatter stringFromNumber:[self totalRemainingPrice] currency:[self preferredCurrencyCode]];
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
    NSString *titleString = [@"Project: " stringByAppendingString:self.title];
    NSString *priceString = [@"Total: " stringByAppendingString:[self formattedTotalRemainingPrice]];
    NSString *itemString = [[[[self items] valueForKey:@"lineItemWithAddress"] array] componentsJoinedByString:@"\n"];
    NSString *madeWithThisAppString = [NSString stringWithFormat:@"Made with %@.app", [[NSBundle mainBundle] infoDictionary][(__bridge NSString *)kCFBundleExecutableKey]];
    NSString *appURLString = @"itms://itunes.com/apps/chainguard";

    return [@[titleString, @"", itemString, @"", priceString, @"", @"", madeWithThisAppString, appURLString] componentsJoinedByString:@"\n"];
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return @"Project";
}

- (NSString *)projectIdentifier
{
    return [[[self objectID] URIRepresentation] absoluteString];
}

- (NSArray *)currencyCodesUsed
{
    return [[self.items valueForKey:@"currencyCode"] allObjects];
}

- (BOOL)isSelectable
{
    return YES;
}

- (UIImage *)imageFromParts
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"photoCount > 0"];
    RWSManagedItem *item = [[self.items filteredOrderedSetUsingPredicate:predicate] firstObject];
    RWSManagedPhoto *photo = [[item photos] firstObject];
    return [photo thumbnailImage];
}

@end
