//
//  RWSListSource.h
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSProject.h"
#import "RWSMapItemSource.h"
@class RWSCoreDataController;

@interface RWSProjectsSource : NSObject<RWSMapItemSource>
@property (nonatomic, strong) NSManagedObjectContext *context;

@property (readonly) NSUInteger count;
- (id<RWSProject>)projectAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForProjectWithIdentifier:(NSString *)identifier;
@property (readonly, strong) id<RWSProject> makeUntitledList;
- (void)deleteProjectAtIndexPath:(NSIndexPath *)indexPath;
@end
