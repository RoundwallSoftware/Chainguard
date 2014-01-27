// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RWSManagedList.m instead.

#import "_RWSManagedList.h"

const struct RWSManagedListAttributes RWSManagedListAttributes = {
	.title = @"title",
};

const struct RWSManagedListRelationships RWSManagedListRelationships = {
};

const struct RWSManagedListFetchedProperties RWSManagedListFetchedProperties = {
};

@implementation RWSManagedListID
@end

@implementation _RWSManagedList

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"List" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"List";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"List" inManagedObjectContext:moc_];
}

- (RWSManagedListID*)objectID {
	return (RWSManagedListID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic title;











#if TARGET_OS_IPHONE

#endif

@end
