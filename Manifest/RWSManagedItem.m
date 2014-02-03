#import "RWSManagedItem.h"


@interface RWSManagedItem ()

// Private interface goes here.

@end


@implementation RWSManagedItem

- (CLLocationCoordinate2D)coordinates
{
    return CLLocationCoordinate2DMake(self.latitudeValue, self.longitudeValue);
}

@end
