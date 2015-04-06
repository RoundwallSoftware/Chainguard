//
//  RWSListViewController.h
//  Manifest
//
//  Created by Samuel Goodwin on 26-01-14.
//
//

#import "RWSProjectsSource.h"
@class RWSCoreDataController;

@interface RWSProjectsViewController : UITableViewController<UIDataSourceModelAssociation, RWSProjectSourceDelegate>
@property (nonatomic, strong) RWSProjectsSource *projectSource;
@end
