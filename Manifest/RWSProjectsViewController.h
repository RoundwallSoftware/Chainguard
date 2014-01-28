//
//  RWSListViewController.h
//  Manifest
//
//  Created by Samuel Goodwin on 26-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

@class RWSCoreDataController;
@class RWSProjectsSource;

@interface RWSProjectsViewController : UITableViewController
@property (nonatomic, strong) RWSProjectsSource *projectSource;
@end
