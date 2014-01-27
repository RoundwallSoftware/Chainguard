#import "_RWSManagedList.h"
#import "RWSList.h"

@interface RWSManagedList : _RWSManagedList<RWSList> {}

+ (instancetype)makeUntitledListInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allListsInContext:(NSManagedObjectContext *)context;

@end
