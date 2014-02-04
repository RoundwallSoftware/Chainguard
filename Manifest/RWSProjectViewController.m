//
//  RWProjectViewController.m
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSProjectViewController.h"
#import "RWSPriceFormatter.h"
#import "RWSMapViewController.h"

@interface RWSProjectViewController ()
@property (nonatomic, strong) UIBarButtonItem *priceItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *addItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *mapItem;
@end

@implementation RWSProjectViewController

- (NSArray *)toolbarItems
{
    if(!self.priceItem){
        self.priceItem = [[UIBarButtonItem alloc] init];
    }

    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    return @[self.mapItem, flexibleItem, self.addItem, flexibleItem, self.priceItem];
}

- (void)recalculatePrice
{
    RWSPriceFormatter *formatter = [[RWSPriceFormatter alloc] init];
    self.priceItem.title = [formatter stringFromNumber:[self.project totalRemainingPriceWithCurrencyCode:@"USD"] currency:@"USD"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupTitleTextField];

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self recalculatePrice];
}

- (void)setupTitleTextField
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 40.0)];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    textField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    textField.text = [self.project title];
    textField.delegate = self;
    textField.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.1];

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

    if(item.price){
        RWSPriceFormatter *formatter = [[RWSPriceFormatter alloc] init];
        cell.detailTextLabel.text = [formatter stringFromNumber:item.price currency:item.currencyCode];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        [self.project removeItemAtIndexPath:indexPath];

        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self recalculatePrice];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    self.project.title = textField.text;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.project.title = textField.text;
}

#pragma mark - RWSNewItemDelegate

- (void)newItemController:(RWSNewItemViewController *)controller didMakeItem:(id<RWSItem>)item
{
    if(item){
        [self.project addItemToList:item];
    }

    [self dismissViewControllerAnimated:YES completion:^{
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self recalculatePrice];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = [segue identifier];
    if([identifier isEqualToString:@"newItem"]){
        RWSNewItemViewController *controller = [segue destinationViewController];
        controller.delegate = self;
    }

    if([identifier isEqualToString:@"toMap"]){
        RWSMapViewController *controller = [segue destinationViewController];
        controller.itemSource = self.project;
    }
}

@end
