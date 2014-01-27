//
//  RWSListViewController.m
//  Manifest
//
//  Created by Samuel Goodwin on 26-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSListViewController.h"
#import "RWSCoreDataController.h"
#import "RWSListSource.h"
#import "RWSListCell.h"

@interface RWSListViewController ()

@end

@implementation RWSListViewController

- (RWSListSource *)listSource
{
    if(!_listSource){
        self.listSource = [[RWSListSource alloc] initWithCoreDataController:self.coreDataController];
    }
    return _listSource;
}

- (RWSCoreDataController *)coreDataController
{
    if(!_coreDataController){
        self.coreDataController = [[RWSCoreDataController alloc] init];
    }
    return _coreDataController;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0){
        return [self.listSource listCount];
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
    RWSListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list" forIndexPath:indexPath];

    id<RWSList> list = [self.listSource listAtIndexPath:indexPath];
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

@end
