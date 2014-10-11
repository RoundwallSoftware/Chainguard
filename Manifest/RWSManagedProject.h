#import "_RWSManagedProject.h"
#import "RWSProject.h"

@interface RWSManagedProject : _RWSManagedProject<RWSProject> {}
+ (NSArray *)search:(NSString *)searchString inContext:(NSManagedObjectContext *)context;
+ (BOOL)canAddDefaultProject;
+ (void)addDefaultProject:(NSManagedObjectContext *)context;
+ (void)makeNoteProjectWasDeleted;

+ (instancetype)makeUntitledProjectInContext:(NSManagedObjectContext *)context;
+ (NSArray *)allProjectsInContext:(NSManagedObjectContext *)context;

@end
