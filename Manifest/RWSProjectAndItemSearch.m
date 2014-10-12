//
//  RWSProjectAndItemSearch.m
//  Manifest
//
//  Created by Samuel Goodwin on 10/11/14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSProjectAndItemSearch.h"
#import "RWSManagedProject.h"
#import "RWSManagedItem.h"
#import "RWSProjectViewController.h"
#import "RWSPriceFormatter.h"

@interface RWSProjectAndItemSearch()
@property (nonatomic, copy) NSArray *projectResults;
@property (nonatomic, copy) NSArray *itemResults;
@end

typedef NS_ENUM(NSUInteger, RWSSearchSection) {
    RWSSearchSectionProjects = 0,
    RWSSearchSectionItems
};

@implementation RWSProjectAndItemSearch

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    
    self.projectResults = [RWSManagedProject search:searchString inContext:self.context];
    self.itemResults = [RWSManagedItem search:searchString inContext:self.context];
    
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section){
        case RWSSearchSectionItems:
            return [self.itemResults count];
            break;
        case RWSSearchSectionProjects:
            return [self.projectResults count];
            break;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    switch(indexPath.section){
        case RWSSearchSectionProjects:
            cell = [self tableView:tableView projectCellForRowAtIndexPath:indexPath];
            break;
        case RWSSearchSectionItems:
            cell = [self tableView:tableView itemCellForRowAtIndexPath:indexPath];
            break;
    }
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView itemCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"item" forIndexPath:indexPath];
    
    RWSManagedItem *item = self.itemResults[indexPath.row];
    
    cell.textLabel.text = [item name];
    
    RWSPriceFormatter *formatter = [[RWSPriceFormatter alloc] init];
    NSString *priceString = [formatter stringFromNumber:item.price currency:item.currencyCode];
    
    cell.detailTextLabel.text = priceString;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView projectCellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"project" forIndexPath:indexPath];
    
    RWSManagedProject *project = self.projectResults[indexPath.row];
    
    cell.textLabel.text = [project title];
    cell.detailTextLabel.text = [project formattedTotalRemainingPrice];
    return cell;
}

- (void)showViewController:(UIViewController *)vc sender:(id)sender
{
    [[self presentingViewController] showViewController:vc sender:sender];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = [segue identifier];
    if([identifier isEqualToString:@"toProject"]){
        id<RWSProject> project = self.projectResults[[self.tableView indexPathForSelectedRow].row];
        
        RWSProjectViewController *controller = [segue destinationViewController];
        controller.project = project;
    }
}

@end
