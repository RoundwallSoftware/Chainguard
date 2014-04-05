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
#import "RWSManagedItem.h"
#import "RWSProjectCell.h"
#import "RWSProjectViewController.h"
#import "RWSMapViewController.h"

@interface RWSProjectsViewController ()
@property (nonatomic, strong) UIView *emptyHeaderView;
@end

@implementation RWSProjectsViewController

- (RWSProjectsSource *)projectSource
{
    if(!_projectSource){
        self.projectSource = [[RWSProjectsSource alloc] init];
    }
    return _projectSource;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];

    if([self.projectSource count]){
        self.tableView.tableHeaderView = nil;
        self.navigationItem.rightBarButtonItem = self.editButtonItem;
    } else {
        self.tableView.tableHeaderView = [self emptyHeaderView];
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

    id<RWSProject> list = [self.projectSource projectAtIndexPath:indexPath];
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

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [self.projectSource deleteProjectAtIndexPath:indexPath];

        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return YES;
    }
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = [segue identifier];
    if([identifier isEqualToString:@"addList"]){
        id<RWSProject> project = [self.projectSource makeUntitledList];

        RWSProjectViewController *controller = [segue destinationViewController];
        controller.project = project;
    }

    if([identifier isEqualToString:@"showList"]){
        id<RWSProject> project = [self.projectSource projectAtIndexPath:[self.tableView indexPathForSelectedRow]];

        RWSProjectViewController *controller = [segue destinationViewController];
        controller.project = project;
    }

    if([identifier isEqualToString:@"toMap"]){
        RWSMapViewController *mapController = [segue destinationViewController];
        mapController.itemSource = self.projectSource;
    }
}

#pragma mark - UIDataSourceModelAssociation

- (NSString *)modelIdentifierForElementAtIndexPath:(NSIndexPath *)indexPath inView:(UIView *)view
{
    if(indexPath.section == 0){
        id<RWSProject> project = [self.projectSource projectAtIndexPath:indexPath];
        return [project projectIdentifier];
    }

    if(indexPath.row == 0) {
        return @"settings";
    }
    if(indexPath.row == 1) {
        return @"credits";
    }

    return nil;
}

- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view
{
    if([identifier isEqualToString:@"settings"]){
        return [NSIndexPath indexPathForRow:0 inSection:1];
    }
    if([identifier isEqualToString:@"credits"]){
        return [NSIndexPath indexPathForRow:1 inSection:1];
    }

    return [self.projectSource indexPathForProjectWithIdentifier:identifier];
}

- (UIView *)emptyHeaderView
{
    if(_emptyHeaderView){
        return _emptyHeaderView;
    }

    CGRect frame = CGRectMake(0.0, 0.0, CGRectGetWidth([self.tableView bounds]), 120.0);
    UIView *header = [[UIView alloc] initWithFrame:frame];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(frame, 10.0, 10.0)];
    label.textColor = [UIColor darkGrayColor];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    label.text = @"You have no projects yet. Make one and get started!";

    [header addSubview:label];
    label.center = header.center;

    _emptyHeaderView = header;
    return header;
}

@end
