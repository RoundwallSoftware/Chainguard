// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RWSManagedItem.h instead.

#import <CoreData/CoreData.h>


extern const struct RWSManagedItemAttributes {
	__unsafe_unretained NSString *addressString;
	__unsafe_unretained NSString *currencyCode;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *price;
} RWSManagedItemAttributes;

extern const struct RWSManagedItemRelationships {
	__unsafe_unretained NSString *project;
} RWSManagedItemRelationships;

extern const struct RWSManagedItemFetchedProperties {
} RWSManagedItemFetchedProperties;

@class RWSManagedProject;








@interface RWSManagedItemID : NSManagedObjectID {}
@end

@interface _RWSManagedItem : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (RWSManagedItemID*)objectID;





@property (nonatomic, strong) NSString* addressString;



//- (BOOL)validateAddressString:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* currencyCode;



//- (BOOL)validateCurrencyCode:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* latitude;



@property double latitudeValue;
- (double)latitudeValue;
- (void)setLatitudeValue:(double)value_;

//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* longitude;



@property double longitudeValue;
- (double)longitudeValue;
- (void)setLongitudeValue:(double)value_;

//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDecimalNumber* price;



//- (BOOL)validatePrice:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) RWSManagedProject *project;

//- (BOOL)validateProject:(id*)value_ error:(NSError**)error_;





#if TARGET_OS_IPHONE



#endif

@end

@interface _RWSManagedItem (CoreDataGeneratedAccessors)

@end

@interface _RWSManagedItem (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAddressString;
- (void)setPrimitiveAddressString:(NSString*)value;




- (NSString*)primitiveCurrencyCode;
- (void)setPrimitiveCurrencyCode:(NSString*)value;




- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (double)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(double)value_;




- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (double)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(double)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSDecimalNumber*)primitivePrice;
- (void)setPrimitivePrice:(NSDecimalNumber*)value;





- (RWSManagedProject*)primitiveProject;
- (void)setPrimitiveProject:(RWSManagedProject*)value;


@end
