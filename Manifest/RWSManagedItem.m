#import "RWSManagedItem.h"
#import "RWSPriceFormatter.h"
#import "RWSManagedPhoto.h"
#import "RWSExchangeRates.h"

@interface RWSManagedItem ()
@end

@implementation RWSManagedItem

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

    return [@[self.name, @": ", [formatter stringFromNumber:[self price] currency:self.currencyCode]] componentsJoinedByString:@""];
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

@end
