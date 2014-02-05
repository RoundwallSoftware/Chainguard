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
#import "RWSManagedItem.h"
#import "RWSProjectCell.h"
#import "RWSProjectViewController.h"
#import "RWSPriceFormatter.h"
#import "RWSMapViewController.h"

@interface RWSProjectsViewController ()

@end

@implementation RWSProjectsViewController

- (RWSProjectsSource *)projectSource
{
    if(!_projectSource){
        self.projectSource = [[RWSProjectsSource alloc] init];

        // This is all gross and goes away soon as the app stops using in-memory contexts
        NSManagedObjectContext *context = self.projectSource.context;
        RWSManagedProject *project = [RWSManagedProject insertInManagedObjectContext:context];
        project.title = @"Example Project";

        RWSManagedItem *cog = [RWSManagedItem insertInManagedObjectContext:context];
        cog.name = @"Dura Ace Cog";
        cog.price = [NSDecimalNumber decimalNumberWithString:@"30.99"];
        cog.currencyCode = @"USD";

        RWSManagedItem *crankset = [RWSManagedItem insertInManagedObjectContext:context];
        crankset.name = @"Dura Ace Crankset";
        crankset.price = [NSDecimalNumber decimalNumberWithString:@"350.99"];
        crankset.currencyCode = @"USD";

        RWSManagedItem *chain = [RWSManagedItem insertInManagedObjectContext:context];
        chain.name = @"Pearl Izumi Chain";
        chain.price = [NSDecimalNumber decimalNumberWithString:@"12.99"];
        chain.currencyCode = @"USD";

        RWSManagedItem *pedal = [RWSManagedItem insertInManagedObjectContext:context];
        pedal.name = @"Shimano SPD-SL Pedal";
        pedal.price = [NSDecimalNumber decimalNumberWithString:@"60.99"];
        pedal.currencyCode = @"USD";

        NSOrderedSet *set = [NSOrderedSet orderedSetWithObjects:cog, crankset, chain, pedal, nil];
        project.items = set;

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

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
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

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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

@end
