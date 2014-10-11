//
//  RWSProjectAndItemSearch.m
//  Manifest
//
//  Created by Samuel Goodwin on 10/11/14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSProjectAndItemSearch.h"
#import "RWSManagedProject.h"
#import "RWSProjectViewController.h"

@interface RWSProjectAndItemSearch()
@property (nonatomic, copy) NSArray *results;
@end

@implementation RWSProjectAndItemSearch

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = searchController.searchBar.text;
    
    self.results = [RWSManagedProject search:searchString inContext:self.context];
    
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"project" forIndexPath:indexPath];
    
    RWSManagedProject *project = self.results[indexPath.row];
    
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
        id<RWSProject> project = self.results[[self.tableView indexPathForSelectedRow].row];
        
        RWSProjectViewController *controller = [segue destinationViewController];
        controller.project = project;
    }
}

@end
