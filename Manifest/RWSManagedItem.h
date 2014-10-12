#import "_RWSManagedItem.h"
#import "RWSProject.h"
@import MapKit;

@interface RWSManagedItem : _RWSManagedItem<RWSItem, MKAnnotation> {}
@property (readonly, copy) NSString *lineItemString;
@property (readonly, copy) NSString *lineItemWithAddress;

+ (NSArray *)search:(NSString *)searchString inContext:(NSManagedObjectContext *)contex;
- (NSDecimalNumber *)priceInCurrency:(NSString *)currencyCode;
@end
