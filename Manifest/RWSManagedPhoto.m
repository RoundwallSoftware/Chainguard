#import "RWSManagedPhoto.h"


@interface RWSManagedPhoto ()

// Private interface goes here.

@end


@implementation RWSManagedPhoto

- (UIImage *)image
{
    return [UIImage imageWithData:self.imageData];
}

@end
