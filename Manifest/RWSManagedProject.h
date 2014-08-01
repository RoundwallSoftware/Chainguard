#import "_RWSManagedProject.h"
#import "RWSProject.h"

@interface RWSManagedProject : _RWSManagedProject<RWSProject> {}
+ (BOOL)canAddDefaultProject;
+ (void)addDefaultProject:(NSManagedObjectContext *)context;
+ (void)makeNoteProjectWasDeleted;

+ (instancetype)makeUntitledProjectInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allProjectsInContext:(NSManagedObjectContext *)context;

@end
