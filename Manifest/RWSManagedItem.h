#import "_RWSManagedItem.h"
#import "RWSProject.h"
@import MapKit;

@interface RWSManagedItem : _RWSManagedItem<RWSItem, MKAnnotation> {}
- (NSString *)lineItemString;
@end
