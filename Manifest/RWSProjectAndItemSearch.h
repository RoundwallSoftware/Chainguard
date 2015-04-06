//
//  RWSProjectAndItemSearch.h
//  Manifest
//
//  Created by Samuel Goodwin on 10/11/14.
//
//

#import <Foundation/Foundation.h>

@interface RWSProjectAndItemSearch : UITableViewController<UISearchResultsUpdating>
@property (nonatomic, strong) NSManagedObjectContext *context;

@end
