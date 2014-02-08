// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RWSManagedItem.m instead.

#import "_RWSManagedItem.h"

const struct RWSManagedItemAttributes RWSManagedItemAttributes = {
	.addressString = @"addressString",
	.currencyCode = @"currencyCode",
	.latitude = @"latitude",
	.longitude = @"longitude",
	.name = @"name",
	.price = @"price",
	.purchased = @"purchased",
};

const struct RWSManagedItemRelationships RWSManagedItemRelationships = {
	.project = @"project",
};

const struct RWSManagedItemFetchedProperties RWSManagedItemFetchedProperties = {
};

@implementation RWSManagedItemID
@end

@implementation _RWSManagedItem

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Item";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Item" inManagedObjectContext:moc_];
}

- (RWSManagedItemID*)objectID {
	return (RWSManagedItemID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"latitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"longitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"purchasedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"purchased"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic addressString;






@dynamic currencyCode;






@dynamic latitude;



- (double)latitudeValue {
	NSNumber *result = [self latitude];
	return [result doubleValue];
}

- (void)setLatitudeValue:(double)value_ {
	[self setLatitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLatitudeValue {
	NSNumber *result = [self primitiveLatitude];
	return [result doubleValue];
}

- (void)setPrimitiveLatitudeValue:(double)value_ {
	[self setPrimitiveLatitude:[NSNumber numberWithDouble:value_]];
}





@dynamic longitude;



- (double)longitudeValue {
	NSNumber *result = [self longitude];
	return [result doubleValue];
}

- (void)setLongitudeValue:(double)value_ {
	[self setLongitude:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveLongitudeValue {
	NSNumber *result = [self primitiveLongitude];
	return [result doubleValue];
}

- (void)setPrimitiveLongitudeValue:(double)value_ {
	[self setPrimitiveLongitude:[NSNumber numberWithDouble:value_]];
}





@dynamic name;






@dynamic price;






@dynamic purchased;



- (BOOL)purchasedValue {
	NSNumber *result = [self purchased];
	return [result boolValue];
}

- (void)setPurchasedValue:(BOOL)value_ {
	[self setPurchased:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitivePurchasedValue {
	NSNumber *result = [self primitivePurchased];
	return [result boolValue];
}

- (void)setPrimitivePurchasedValue:(BOOL)value_ {
	[self setPrimitivePurchased:[NSNumber numberWithBool:value_]];
}





@dynamic project;

	






#if TARGET_OS_IPHONE



#endif

@end
