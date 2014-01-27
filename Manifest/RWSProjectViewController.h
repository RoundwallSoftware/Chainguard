//
//  RWProjectViewController.h
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

@class RWSCoreDataController;
@class RWSManagedList;

@interface RWSProjectViewController : UITableViewController
@property (nonatomic, strong) RWSCoreDataController *coreDataController;
@property (nonatomic, strong) RWSManagedList *list;
@end
