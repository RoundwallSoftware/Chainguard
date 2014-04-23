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

@interface RWSProjectViewController ()
@property (nonatomic, strong) UIBarButtonItem *priceItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *addItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *actionItem;
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
    self.actionItem = actionItem;

    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    return @[flexibleItem, self.priceItem, flexibleItem, actionItem ];
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
    self.title = nil;
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
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 40.0)];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
    textField.returnKeyType = UIReturnKeyDone;
    textField.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    textField.text = [self.project title];
    textField.delegate = self;
    textField.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.1];

    UIView *background = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 50.0)];
    [background addSubview:textField];

    textField.center = background.center;

    self.tableView.tableHeaderView = background;
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
    cell.delegate = self;
    cell.containingTableView = tableView;

    [cell setItem:item];

    [cell setCellHeight:self.tableView.rowHeight];
    return cell;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index
{
    [cell hideUtilityButtonsAnimated:YES];

    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    id<RWSItem>item = [self.project itemAtIndexPath:indexPath];
    [item togglePurchased];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];

    [self recalculatePrice];
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.project removeItemAtIndexPath:indexPath];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self recalculatePrice];

    [self showEmptyStateIfNecessary];
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [self.project moveItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self performSegueWithIdentifier:@"toItem" sender:self];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    for(RWSItemCell *cell in [self.tableView visibleCells]){
        [cell hideUtilityButtonsAnimated:YES];
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
    self.title = self.project.title;

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

    NSString *selectedCurrencyCode = [[self.project currencyCodesUsed] objectAtIndex:buttonIndex];
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
    CGRect frame = CGRectMake(0.0, 0.0, 320.0, 180.0);
    UIView *header = [[UIView alloc] initWithFrame:frame];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(frame, 10.0, 10.0)];
    label.textColor = [UIColor darkGrayColor];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    label.text = @"You have no items yet. Make one and get started!";

    [header addSubview:label];

    return  header;
}

@end
