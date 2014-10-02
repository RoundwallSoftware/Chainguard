//
//  RWProjectViewController.m
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSProjectViewController.h"
#import "RWSPriceFormatter.h"
#import "NSLocale+RWSCurrency.h"
#import "UIColor+RWSAppColors.h"
#import <UIColor+iOS7Colors.h>

@interface RWSProjectViewController ()
@property (nonatomic, strong) UIBarButtonItem *priceItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *addItem;
@end

@implementation RWSProjectViewController

- (NSArray *)toolbarItems
{
    if(!self.priceItem){
        self.priceItem = [[UIBarButtonItem alloc] init];
        self.priceItem.target = self;
        self.priceItem.action = @selector(changePrice:);
    }

    UIBarButtonItem *actionItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];

    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    return @[actionItem, flexibleItem, self.priceItem ];
}

- (void)recalculatePrice
{
    self.priceItem.title = [self.project formattedTotalRemainingPrice];

    self.priceItem.tintColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        self.priceItem.tintColor = self.view.tintColor;
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupTitleTextField];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationItem.rightBarButtonItems = @[self.addItem];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self recalculatePrice];

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];

    [self showEmptyStateIfNecessary];
}

- (void)setupTitleTextField
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, 255.0, 40.0)];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.borderStyle = UITextBorderStyleNone;
    textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.returnKeyType = UIReturnKeyDone;
    textField.textColor = [UIColor tintColor];
    textField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    textField.text = [self.project title];
    textField.delegate = self;

    self.navigationItem.titleView = textField;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.project count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<RWSItem> item = [self.project itemAtIndexPath:indexPath];
    RWSItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"item" forIndexPath:indexPath];

    [cell setItem:item];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {}


- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id<RWSItem> item = [self.project itemAtIndexPath:indexPath];
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    
    UITableViewRowAction *delete = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *actionPath) {
        [self.project removeItemAtIndexPath:actionPath];
        
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        [self recalculatePrice];
        
        [self showEmptyStateIfNecessary];
    }];
    [buttons addObject:delete];
    
    UITableViewRowAction *share = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Share" handler:^(UITableViewRowAction *action, NSIndexPath *actionPath) {
        
        UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[item] applicationActivities:nil];
        [self presentViewController:controller animated:YES completion:nil];
        
    }];
    [buttons addObject:share];
    
    if([item isPurchased]){
        UITableViewRowAction *undo = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Undo" handler:^(UITableViewRowAction *action, NSIndexPath *actionPath) {
            [item togglePurchased];
            
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [self recalculatePrice];
            
            [self showEmptyStateIfNecessary];
        }];
        [buttons addObject:undo];
    } else {
        UITableViewRowAction *purchase = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Got It" handler:^(UITableViewRowAction *action, NSIndexPath *actionPath) {
            [item togglePurchased];
            
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
            
            [self recalculatePrice];
            
            [self showEmptyStateIfNecessary];
        }];
        [buttons addObject:purchase];
        
        purchase.backgroundColor = [UIColor iOS7greenColor];
    }
    
    return buttons;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [self.project moveItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
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
    NSString *title = textField.text;
    if(![title length]){
        title = @"Untitled";
        textField.text = title;
    }

    self.project.title = title;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField selectAll:nil];
}

#pragma mark - RWSNewItemDelegate

- (void)itemController:(RWSItemViewController *)controller didMakeItem:(id<RWSItem>)itemOrNil
{
    if(itemOrNil){
        [self.project addItemToList:itemOrNil];
    }

    [self.navigationController popViewControllerAnimated:YES];
    [self recalculatePrice];
}

- (void)itemController:(RWSItemViewController *)controller didDeleteItem:(id<RWSItem>)itemOrNil
{
    [self.navigationController popToViewController:self animated:YES];
    [self.project removeItemFromList:itemOrNil];
}

- (id<RWSItem>)selectedItem
{
    return [self.project itemAtIndexPath:[self.tableView indexPathForSelectedRow]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.title = @"";

    NSString *identifier = [segue identifier];
    if([identifier isEqualToString:@"newItem"]){

        RWSItemViewController *controller = [segue destinationViewController];
        controller.title = @"New Item";
        controller.delegate = self;
    }

    if([identifier isEqualToString:@"toItem"]){
        RWSItemViewController *controller = [segue destinationViewController];
        controller.item = [self selectedItem];
        NSParameterAssert(controller.item);
        controller.delegate = self;
    }
}

- (IBAction)share:(id)sender
{
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[self.project] applicationActivities:nil];
    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)changePrice:(id)sender
{
    NSArray *currencyCodes = [self.project currencyCodesUsed];
    if([currencyCodes count] <= 1){
        return;
    }

    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    sheet.title = @"Change Display Currency";
    sheet.delegate = self;

    for(NSString *currencyCode in currencyCodes){
        [sheet addButtonWithTitle:currencyCode];
    }

    sheet.cancelButtonIndex = [sheet addButtonWithTitle:@"Cancel"];

    [sheet showFromToolbar:self.navigationController.toolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == [actionSheet cancelButtonIndex]){
        return;
    }

    NSString *selectedCurrencyCode = [self.project currencyCodesUsed][buttonIndex];
    [self.project setPreferredCurrencyCode:selectedCurrencyCode];

    [self recalculatePrice];
}

- (void)showEmptyStateIfNecessary
{
    if([self.project count] > 0){
        self.tableView.tableFooterView = nil;
    } else {
        self.tableView.tableFooterView = [self emptyFooterView];
    }
}

- (UIView *)emptyFooterView
{
    CGRect frame = self.tableView.bounds;
    UIView *header = [[UIView alloc] initWithFrame:CGRectInset(frame, 0.0f, 40.0f)];
    UILabel *label = [[UILabel alloc] init];
    
    label.translatesAutoresizingMaskIntoConstraints = NO;
    label.textColor = [UIColor darkGrayColor];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    label.text = @"You have no items yet. Make one and get started!";

    [header addSubview:label];
    
    [header addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:header attribute:NSLayoutAttributeCenterX multiplier:1.0f constant:0.0f]];
    [header addConstraint:[NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:header attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0.0f]];
    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[label]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];
    [header addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[label]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(label)]];

    return  header;
}

@end
