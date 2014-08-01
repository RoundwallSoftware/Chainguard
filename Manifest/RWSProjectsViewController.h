//
//  RWSListViewController.h
//  Manifest
//
//  Created by Samuel Goodwin on 26-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSProjectsSource.h"
@class RWSCoreDataController;

@interface RWSProjectsViewController : UITableViewController<UIDataSourceModelAssociation, RWSProjectSourceDelegate>
@property (nonatomic, strong) RWSProjectsSource *projectSource;
@end
