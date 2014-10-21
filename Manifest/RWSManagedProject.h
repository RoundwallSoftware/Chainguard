#import "_RWSManagedProject.h"
#import "RWSProject.h"

@interface RWSManagedProject : _RWSManagedProject<RWSProject> {}
+ (NSArray *)search:(NSString *)searchString inContext:(NSManagedObjectContext *)context;

+ (instancetype)makeUntitledProjectInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allProjectsInContext:(NSManagedObjectContext *)context;

@end
