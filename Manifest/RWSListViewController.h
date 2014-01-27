//
//  RWSListViewController.h
//  Manifest
//
//  Created by Samuel Goodwin on 26-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

@class RWSCoreDataController;
@class RWSListSource;

@interface RWSListViewController : UITableViewController
@property (nonatomic, strong) RWSCoreDataController *coreDataController;
@property (nonatomic, strong) RWSListSource *listSource;
@end
