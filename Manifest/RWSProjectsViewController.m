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
@end

@implementation RWSProjectsViewController

- (RWSProjectsSource *)projectSource
{
    if(!_projectSource){
        self.projectSource = [[RWSProjectsSource alloc] init];
        self.projectSource.delegate = self;
    }
    return _projectSource;
}

- (void)projectSourceDidAddProject:(RWSProjectsSource *)source
{
    [self showEmptyStateIfNecessary];
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];

    [self showEmptyStateIfNecessary];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"";
    
    UIBarButtonItem *mapButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"map"] style:UIBarButtonItemStylePlain target:self action:@selector(showMap)];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addProject)];

    self.navigationItem.rightBarButtonItems = @[addButton, mapButton];
}

- (void)showMap
{
    [self performSegueWithIdentifier:@"toMap" sender:self];
}

- (void)addProject
{
    [self performSegueWithIdentifier:@"addList" sender:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.projectSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RWSProjectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list" forIndexPath:indexPath];

    id<RWSProject> list = [self.projectSource projectAtIndexPath:indexPath];
    [cell setList:list];

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [self.projectSource deleteProjectAtIndexPath:indexPath];

        [tableView reloadData];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self showEmptyStateIfNecessary];
        });
    }
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
    id<RWSProject> project = [self.projectSource projectAtIndexPath:indexPath];
    return [project projectIdentifier];
}

- (NSIndexPath *)indexPathForElementWithModelIdentifier:(NSString *)identifier inView:(UIView *)view
{
    if([identifier isEqualToString:@"settings"]){
        return [NSIndexPath indexPathForRow:0 inSection:1];
    }

    return [self.projectSource indexPathForProjectWithIdentifier:identifier];
}

- (void)showEmptyStateIfNecessary
{
    if([self.projectSource count]){
        self.tableView.tableHeaderView = nil;
    } else {
        UIView *header = [self emptyHeaderView];
        header.alpha = 0.0;
        self.tableView.tableHeaderView = header;

        [UIView animateWithDuration:0.3 animations:^{
            header.alpha = 1.0;
        }];
    }
}

- (UIView *)emptyHeaderView
{
    CGRect frame = self.tableView.bounds;
    UIView *header = [[UIView alloc] initWithFrame:CGRectInset(frame, 0.0f, 40.0f)];

    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textColor = [UIColor darkGrayColor];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    label.text = @"You have no projects yet. Make one and get started!";

    [header addSubview:label];
    
    [header addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:header attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [header addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:header attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[label]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];

    return header;
}

@end
