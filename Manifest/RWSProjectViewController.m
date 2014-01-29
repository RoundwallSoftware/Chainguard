//
//  RWProjectViewController.m
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSProjectViewController.h"

@interface RWSProjectViewController ()

@end

@implementation RWSProjectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 44.0)];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.text = [self.project title];

    self.navigationItem.titleView = textField;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.project count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"item" forIndexPath:indexPath];

    id<RWSItem> item = [self.project itemAtIndexPath:indexPath];

    cell.textLabel.text = item.name;

    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.project.title = textField.text;
    return YES;
}

@end
