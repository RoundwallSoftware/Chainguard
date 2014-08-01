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

@protocol RWSProjectSourceDelegate;

@interface RWSProjectsSource : NSObject<RWSMapItemSource, UIAlertViewDelegate>
@property (nonatomic, weak) id<RWSProjectSourceDelegate> delegate;

@property (nonatomic, strong) NSManagedObjectContext *context;

@property (readonly) NSUInteger count;
@property (readonly, strong) id<RWSProject> makeUntitledList;

- (id<RWSProject>)projectAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForProjectWithIdentifier:(NSString *)identifier;
- (void)deleteProjectAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol RWSProjectSourceDelegate
- (void)projectSourceDidAddProject:(RWSProjectsSource *)source;
@end
