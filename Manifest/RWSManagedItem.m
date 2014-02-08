#import "RWSManagedItem.h"
#import "RWSPriceFormatter.h"

@interface RWSManagedItem ()

// Private interface goes here.

@end


@implementation RWSManagedItem

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.latitudeValue, self.longitudeValue);
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

@end
