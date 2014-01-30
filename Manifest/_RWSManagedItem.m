// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RWSManagedItem.m instead.

#import "_RWSManagedItem.h"

const struct RWSManagedItemAttributes RWSManagedItemAttributes = {
	.name = @"name",
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
	

	return keyPaths;
}




@dynamic name;






@dynamic project;

	






#if TARGET_OS_IPHONE



#endif

@end
