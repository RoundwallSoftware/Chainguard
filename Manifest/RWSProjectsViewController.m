//
//  RWSListViewController.m
//  Manifest
//
//  Created by Samuel Goodwin on 26-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSProjectsViewController.h"
#import "RWSCoreDataController.h"
#import "RWSProjectsSource.h"
#import "RWSManagedProject.h"
#import "RWSProjectCell.h"
#import "RWSProjectViewController.h"

@interface RWSProjectsViewController ()

@end

@implementation RWSProjectsViewController

- (RWSProjectsSource *)projectSource
{
    if(!_projectSource){
        self.projectSource = [[RWSProjectsSource alloc] init];

        RWSManagedProject *project = [RWSManagedProject insertInManagedObjectContext:self.projectSource.context];
        project.title = @"Example Project";
        NSError *saveError;
        BOOL saved = [self.projectSource.context save:&saveError];
        if(!saved){
            abort();
        }
    }
    return _projectSource;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return [self.projectSource count];
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return [self tableView:tableView firstSectionCellAtIndexPath:indexPath];
    }

    return [self tableView:tableView secondSectionCellAtIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView firstSectionCellAtIndexPath:(NSIndexPath *)indexPath
{
    RWSProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list" forIndexPath:indexPath];

    id<RWSProject> list = [self.projectSource listAtIndexPath:indexPath];
    [cell setList:list];

    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView secondSectionCellAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.row){
        case 0:
            return [tableView dequeueReusableCellWithIdentifier:@"settings" forIndexPath:indexPath];
        case 1:
            return [tableView dequeueReusableCellWithIdentifier:@"credits" forIndexPath:indexPath];
    }

    return nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = [segue identifier];
    if([identifier isEqualToString:@"addList"]){
        RWSManagedProject *project = [self.projectSource makeUntitledList];

        RWSProjectViewController *controller = [segue destinationViewController];
        controller.project = project;
    }
}

@end
