//
//  RWSListSource.h
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSProject.h"
@class RWSCoreDataController;

@interface RWSProjectsSource : NSObject
@property (nonatomic, strong) NSManagedObjectContext *context;

- (NSUInteger)count;
- (id<RWSProject>)listAtIndexPath:(NSIndexPath *)indexPath;
- (id<RWSProject>)makeUntitledList;
@end
