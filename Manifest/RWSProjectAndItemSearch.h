//
//  RWSProjectAndItemSearch.h
//  Manifest
//
//  Created by Samuel Goodwin on 10/11/14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RWSProjectAndItemSearch : UITableViewController<UISearchResultsUpdating>
@property (nonatomic, strong) NSManagedObjectContext *context;

@end
