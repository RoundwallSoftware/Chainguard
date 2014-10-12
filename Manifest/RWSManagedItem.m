#import "RWSManagedItem.h"
#import "RWSPriceFormatter.h"
#import "RWSManagedPhoto.h"
#import "RWSExchangeRates.h"

@interface RWSManagedItem ()
@end

@implementation RWSManagedItem

+ (NSArray *)search:(NSString *)searchString inContext:(NSManagedObjectContext *)context
{
    searchString = [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@ OR notes CONTAINS[cd] %@", searchString, searchString];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[self entityInManagedObjectContext:context]];
    [request setPredicate:predicate];
    [request setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:RWSManagedItemAttributes.name ascending:YES]]];
    
    NSError *fetchError;
    NSArray *results =  [context executeFetchRequest:request error:&fetchError];
    if(!results){
        NSAssert(NO, @"Error searching projects: %@", fetchError);
    }
    
    return results;
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.latitudeValue, self.longitudeValue);
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    self.latitudeValue = newCoordinate.latitude;
    self.longitudeValue = newCoordinate.longitude;
}

- (NSString *)title
{
    return [self lineItemString];
}

- (NSString *)subtitle
{
    return [self addressString];
}

- (NSString *)lineItemString
{
    RWSPriceFormatter *formatter = [[RWSPriceFormatter alloc] init];
    
    NSMutableArray *items = [NSMutableArray array];
    [items addObject:self.name];
    
    if([self price] && [self currencyCode]){
        [items addObject:@": "];
        [items addObject:[formatter stringFromNumber:[self price] currency:self.currencyCode]];
    }
    
    return [items componentsJoinedByString:@""];
}

- (BOOL)isValid
{
    return [self.name length] > 0;
}

- (NSDecimalNumber *)priceInCurrency:(NSString *)currencyCode
{
    RWSExchangeRates *rates = [[RWSExchangeRates alloc] init];
    return [rates convertPrice:self.price fromCurrencyCode:self.currencyCode toCurrencyCode:currencyCode];
}

- (BOOL)isPurchased
{
    return self.purchasedValue;
}

- (void)togglePurchased
{
    self.purchasedValue = !self.purchasedValue;
}

- (NSUInteger)photoCount
{
    return [self.photos count];
}

- (id<RWSPhoto>)photoAtIndexPath:(NSIndexPath *)indexPath
{
    return self.photos[indexPath.item];
}

- (void)addPhotoWithImage:(UIImage *)image
{
    RWSManagedPhoto *photo = [RWSManagedPhoto insertInManagedObjectContext:self.managedObjectContext];
    [photo setImage:image];

    NSMutableOrderedSet *photos = self.photosSet;
    [photos addObject:photo];
    self.photos = photos;
}

- (void)deletePhotoAtIndexPath:(NSIndexPath *)indexPath
{
    RWSManagedPhoto *photo = (self.photos)[indexPath.item];
    [self willChangeValueForKey:@"photos"];
    [self.managedObjectContext deleteObject:photo];
    [self didChangeValueForKey:@"photos"];
}

- (NSString *)lineItemWithAddress
{
    NSMutableArray *items = [NSMutableArray arrayWithObject:[self lineItemString]];
    if([self addressString]){
        [items addObject:[NSString stringWithFormat:@"( %@ )", [self addressString]]];
    }
    
    return [items componentsJoinedByString:@" "];
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType
{
    return [self lineItemWithAddress];
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController
{
    return [self lineItemWithAddress];
}

@end
