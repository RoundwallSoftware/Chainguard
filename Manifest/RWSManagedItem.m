#import "RWSManagedItem.h"
#import "RWSPriceFormatter.h"
#import "RWSManagedPhoto.h"

@interface RWSManagedItem ()

// Private interface goes here.

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

- (NSString *)lineItemString
{
    RWSPriceFormatter *formatter = [[RWSPriceFormatter alloc] init];

    return [@[self.name, @": ", [formatter stringFromNumber:[self price] currency:@"USD"]] componentsJoinedByString:@""];
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
    return [self.photos objectAtIndex:indexPath.item];
}

- (void)addPhotoWithImage:(UIImage *)image
{
    RWSManagedPhoto *photo = [RWSManagedPhoto insertInManagedObjectContext:self.managedObjectContext];
    NSData *data = UIImagePNGRepresentation(image);
    photo.imageData = data;

    NSMutableOrderedSet *photos = self.photosSet;
    [photos addObject:photo];
    self.photos = photos;
}

@end
