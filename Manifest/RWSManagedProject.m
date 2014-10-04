#import "RWSManagedProject.h"
#import "RWSManagedItem.h"
#import "RWSPriceFormatter.h"
#import "NSLocale+RWSCurrency.h"
#import "RWSManagedPhoto.h"

NSString *const RWSProjectWasDeletedKey = @"RWSProjectWasDeletedKey";
NSString *const RWSProjectHasAddedKey = @"RWSProjectHasAddedKey";

@implementation RWSManagedProject

+ (BOOL)canAddDefaultProject
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return ![defaults boolForKey:RWSProjectHasAddedKey] && ![defaults boolForKey:RWSProjectWasDeletedKey];
}

+ (void)makeNoteProjectWasDeleted
{
    return [[NSUserDefaults standardUserDefaults] setBool:YES forKey:RWSProjectWasDeletedKey];
}

+ (void)addDefaultProject:(NSManagedObjectContext *)context
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:RWSProjectHasAddedKey];

    RWSManagedProject *defaultProject = [RWSManagedProject insertInManagedObjectContext:context];
    defaultProject.title = @"Starting Guitar";
    defaultProject.preferredCurrencyCode = @"EUR";

    RWSManagedItem *guitar = [RWSManagedItem insertInManagedObjectContext:context];
    guitar.project = defaultProject;
    guitar.name = @"Squire Jazzmaster";
    guitar.currencyCode = @"EUR";
    guitar.price = [NSDecimalNumber decimalNumberWithString:@"325"];
    guitar.addressString = @"Rozengracht 115";
    guitar.latitude = @52.37284440000001;
    guitar.longitude = @4.8791261;
    guitar.notes = @"If they don't have this one, any one you like will do.";
    UIImage *guitarImage = [UIImage imageNamed:@"jazzmaster.jpg"];
    [guitar addPhotoWithImage:guitarImage];

    RWSManagedItem *gigBag = [RWSManagedItem insertInManagedObjectContext:context];
    gigBag.project = defaultProject;
    gigBag.name = @"Gig Bag";
    gigBag.currencyCode = @"EUR";
    gigBag.price = [NSDecimalNumber decimalNumberWithString:@"35"];
    gigBag.addressString = @"Rozengracht 115";
    gigBag.latitude = @52.37284440000001;
    gigBag.longitude = @4.8791261;

    RWSManagedItem *tuner = [RWSManagedItem insertInManagedObjectContext:context];
    tuner.project = defaultProject;
    tuner.name = @"Headstock Tuner";
    tuner.currencyCode = @"EUR";
    tuner.price = [NSDecimalNumber decimalNumberWithString:@"20"];
    tuner.addressString = @"Rozengracht 115";
    tuner.latitude = @52.37284440000001;
    tuner.longitude = @4.8791261;
    tuner.notes = @"Definitely need a tuner. Use it before you practice every time.";

    RWSManagedItem *rocksmith = [RWSManagedItem insertInManagedObjectContext:context];
    rocksmith.project = defaultProject;
    rocksmith.name = @"Rocksmith 2014 with cable";
    rocksmith.currencyCode = @"USD";
    rocksmith.price = [NSDecimalNumber decimalNumberWithString:@"79.99"];
    rocksmith.notes = @"Make sure you get it with the cable. Also make sure you get the right platform";

    NSError *saveError;
    BOOL saved = [context save:&saveError];
    if(!saved){
        NSAssert(saved, @"Saving error: %@", saveError);
    }
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
    return self.items[indexPath.row];
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
