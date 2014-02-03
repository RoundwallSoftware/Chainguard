#import "RWSManagedItem.h"


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
    return self.name;
}

@end
