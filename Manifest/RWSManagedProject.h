#import "_RWSManagedProject.h"
#import "RWSProject.h"
#import "RWSMapItemSource.h"

@interface RWSManagedProject : _RWSManagedProject<RWSProject, RWSMapItemSource> {}
+ (instancetype)makeUntitledProjectInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allProjectsInContext:(NSManagedObjectContext *)context;

@end
