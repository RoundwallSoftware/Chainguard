#import "_RWSManagedProject.h"
#import "RWSProject.h"

@interface RWSManagedProject : _RWSManagedProject<RWSProject> {}
+ (instancetype)makeUntitledProjectInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allProjectsInContext:(NSManagedObjectContext *)context;

@end
