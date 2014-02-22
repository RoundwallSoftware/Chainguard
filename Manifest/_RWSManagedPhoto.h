// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RWSManagedPhoto.h instead.

#import <CoreData/CoreData.h>


extern const struct RWSManagedPhotoAttributes {
	__unsafe_unretained NSString *imageData;
	__unsafe_unretained NSString *thumbnailData;
} RWSManagedPhotoAttributes;

extern const struct RWSManagedPhotoRelationships {
	__unsafe_unretained NSString *item;
} RWSManagedPhotoRelationships;

extern const struct RWSManagedPhotoFetchedProperties {
} RWSManagedPhotoFetchedProperties;

@class RWSManagedItem;




@interface RWSManagedPhotoID : NSManagedObjectID {}
@end

@interface _RWSManagedPhoto : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (RWSManagedPhotoID*)objectID;





@property (nonatomic, strong) NSData* imageData;



//- (BOOL)validateImageData:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSData* thumbnailData;



//- (BOOL)validateThumbnailData:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) RWSManagedItem *item;

//- (BOOL)validateItem:(id*)value_ error:(NSError**)error_;





#if TARGET_OS_IPHONE



#endif

@end

@interface _RWSManagedPhoto (CoreDataGeneratedAccessors)

@end

@interface _RWSManagedPhoto (CoreDataGeneratedPrimitiveAccessors)


- (NSData*)primitiveImageData;
- (void)setPrimitiveImageData:(NSData*)value;




- (NSData*)primitiveThumbnailData;
- (void)setPrimitiveThumbnailData:(NSData*)value;





- (RWSManagedItem*)primitiveItem;
- (void)setPrimitiveItem:(RWSManagedItem*)value;


@end
