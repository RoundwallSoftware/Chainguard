#import "_RWSManagedProject.h"
#import "RWSProject.h"

@interface RWSManagedProject : _RWSManagedProject<RWSProject> {}
+ (void)ensureDefaultProjectsInContext:(NSManagedObjectContext *)context;
+ (void)makeNoteAProjectWasDeleted;

+ (instancetype)makeUntitledProjectInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allProjectsInContext:(NSManagedObjectContext *)context;

@end
