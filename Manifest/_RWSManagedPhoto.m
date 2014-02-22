// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RWSManagedPhoto.m instead.

#import "_RWSManagedPhoto.h"

const struct RWSManagedPhotoAttributes RWSManagedPhotoAttributes = {
	.imageData = @"imageData",
};

const struct RWSManagedPhotoRelationships RWSManagedPhotoRelationships = {
	.item = @"item",
};

const struct RWSManagedPhotoFetchedProperties RWSManagedPhotoFetchedProperties = {
};

@implementation RWSManagedPhotoID
@end

@implementation _RWSManagedPhoto

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Photo";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Photo" inManagedObjectContext:moc_];
}

- (RWSManagedPhotoID*)objectID {
	return (RWSManagedPhotoID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic imageData;






@dynamic item;

	






#if TARGET_OS_IPHONE



#endif

@end
