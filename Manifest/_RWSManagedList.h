// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RWSManagedList.h instead.

#import <CoreData/CoreData.h>


extern const struct RWSManagedListAttributes {
	__unsafe_unretained NSString *title;
} RWSManagedListAttributes;

extern const struct RWSManagedListRelationships {
} RWSManagedListRelationships;

extern const struct RWSManagedListFetchedProperties {
} RWSManagedListFetchedProperties;




@interface RWSManagedListID : NSManagedObjectID {}
@end

@interface _RWSManagedList : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (RWSManagedListID*)objectID;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;






#if TARGET_OS_IPHONE

#endif

@end

@interface _RWSManagedList (CoreDataGeneratedAccessors)

@end

@interface _RWSManagedList (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




@end
