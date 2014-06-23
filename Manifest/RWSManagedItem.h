#import "_RWSManagedItem.h"
#import "RWSProject.h"
@import MapKit;

@interface RWSManagedItem : _RWSManagedItem<RWSItem, MKAnnotation> {}
@property (readonly, copy) NSString *lineItemString;
- (NSDecimalNumber *)priceInCurrency:(NSString *)currencyCode;
@end
