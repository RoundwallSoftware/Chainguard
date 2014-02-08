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
@property (nonatomic, weak) IBOutlet UIBarButtonItem *actionItem;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *mapItem;
@end

@implementation RWSProjectViewController

- (NSArray *)toolbarItems
{
    if(!self.priceItem){
        self.priceItem = [[UIBarButtonItem alloc] init];
    }

    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    return @[flexibleItem, self.priceItem, flexibleItem];
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
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self recalculatePrice];

    self.navigationItem.rightBarButtonItems = @[self.addItem, self.actionItem];
}

- (void)setupTitleTextField
{
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0.0, 0.0, 200.0, 40.0)];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.autocapitalizationType = UITextAutocapitalizationTypeWords;
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
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    return YES;
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
    self.project.title = textField.text;
}

#pragma mark - RWSNewItemDelegate

- (void)newItemController:(RWSNewItemViewController *)controller didMakeItem:(id<RWSItem>)itemOrNil
{
    if(itemOrNil){
        [self.project addItemToList:itemOrNil];
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

- (IBAction)share:(id)sender
{
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[self.project] applicationActivities:nil];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
