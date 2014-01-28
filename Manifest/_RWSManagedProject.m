// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RWSManagedProject.m instead.

#import "_RWSManagedProject.h"

const struct RWSManagedProjectAttributes RWSManagedProjectAttributes = {
	.title = @"title",
};

const struct RWSManagedProjectRelationships RWSManagedProjectRelationships = {
};

const struct RWSManagedProjectFetchedProperties RWSManagedProjectFetchedProperties = {
};

@implementation RWSManagedProjectID
@end

@implementation _RWSManagedProject

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Project" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Project";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Project" inManagedObjectContext:moc_];
}

- (RWSManagedProjectID*)objectID {
	return (RWSManagedProjectID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic title;











#if TARGET_OS_IPHONE

#endif

@end
