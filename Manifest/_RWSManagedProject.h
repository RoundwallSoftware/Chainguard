// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RWSManagedProject.h instead.

#import <CoreData/CoreData.h>


extern const struct RWSManagedProjectAttributes {
	__unsafe_unretained NSString *title;
} RWSManagedProjectAttributes;

extern const struct RWSManagedProjectRelationships {
} RWSManagedProjectRelationships;

extern const struct RWSManagedProjectFetchedProperties {
} RWSManagedProjectFetchedProperties;




@interface RWSManagedProjectID : NSManagedObjectID {}
@end

@interface _RWSManagedProject : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (RWSManagedProjectID*)objectID;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;






#if TARGET_OS_IPHONE

#endif

@end

@interface _RWSManagedProject (CoreDataGeneratedAccessors)

@end

@interface _RWSManagedProject (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




@end
