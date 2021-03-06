//
//  RWSNewPartViewController.m
//  Manifest
//
//  Created by Samuel Goodwin on 30-01-14.
//
//

#import "RWSItemViewController.h"
#import "RWSPriceFormatter.h"
#import "RWSDumbItem.h"
#import "RWSMapViewController.h"
#import "RWSPriceInputManager.h"
#import "RWSItemParser.h"
#import "UIColor+RWSAppColors.h"
#import <UIColor+iOS7Colors.h>
#import "RWSNotesViewController.h"
#import "RWSPhotosViewController.h"
#import "NSLocale+RWSCurrency.h"
#import "RWSPagedLayout.h"
#import "RWSSingularItemSource.h"
@import AddressBookUI;

NSString *const AYIUserDidAddLocationPreference = @"AYIUserDidAddLocationPreference";
NSString *const AYIUserDidDecideOnAutoLocationPreference = @"AYIUserDidDecideOnAutoLocationPreference";

@interface RWSItemViewController ()
@property (nonatomic, assign, getter = isExistingItem) BOOL existingItem;
@end

@implementation RWSItemViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIButton *locationButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, CGRectGetWidth(self.view.bounds), 34.0)];
    [locationButton setTitle:@"Set Location" forState:UIControlStateNormal];
    locationButton.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
    [locationButton setTitleColor:[UIColor tintColor] forState:UIControlStateNormal];
    [locationButton addTarget:self action:@selector(setCurrentLocation:) forControlEvents:UIControlEventTouchUpInside];

    self.locationButton = locationButton;

    UIView *toolbar = [[[UINib nibWithNibName:@"CurrencyToolbar" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
    UITextField *priceField = self.priceField;
    priceField.inputAccessoryView = toolbar;

    if(self.item){
        self.navigationItem.rightBarButtonItem = nil;
        self.existingItem = YES;
        self.deleteButton.tintColor = [UIColor iOS7redColor];

        RWSPriceFormatter *formatter = [[RWSPriceFormatter alloc] init];
        self.nameField.text = self.item.name;
        priceField.text = [formatter stringFromNumber:self.item.price currency:self.item.currencyCode];

        self.title = self.item.name;
        if(self.item.addressString){
            [locationButton setTitle:self.item.addressString forState:UIControlStateNormal];
        }
    }else{
        self.tableView.tableFooterView = nil;
        self.item = [[RWSDumbItem alloc] init];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        BOOL didPreviouslyAddLocation = [defaults boolForKey:AYIUserDidAddLocationPreference];
        BOOL didPreviouslyChooseAutoLocation = [defaults boolForKey:AYIUserDidDecideOnAutoLocationPreference];
        if(didPreviouslyAddLocation && didPreviouslyChooseAutoLocation){
            [self setCurrentLocation:locationButton];
        }
    }
    
    locationButton.enabled = [self.locationManager canGetLocations];
    [locationButton setTitle:@"" forState:UIControlStateDisabled];

    self.notesField.text = self.item.notes;
    [self setupPhotosController];
}

- (void)setupPhotosController
{
    CGFloat width = 320.0f;
    
    RWSPagedLayout *layout = [[RWSPagedLayout alloc] init];
    layout.itemSize = CGSizeMake(width, width);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0.0;
    layout.minimumLineSpacing = 0.0;

    RWSPhotosViewController *controller = [[RWSPhotosViewController alloc] initWithCollectionViewLayout:layout];
    controller.item = self.item;

    UIView *view = controller.view;
    view.frame = CGRectMake(0.0, 0.0, width, width);
    self.tableView.tableHeaderView = view;
    [controller willMoveToParentViewController:self];

    [self addChildViewController:controller];

    self.photosController = controller;

    self.tableView.contentInset = UIEdgeInsetsMake(-12.0, 0.0, 0.0, 0.0);
}

- (IBAction)save:(id)sender
{
    [self.delegate itemController:self didMakeItem:self.item];
}

- (IBAction)delete:(id)sender
{
    [self.delegate itemController:self didDeleteItem:self.item];
}

- (IBAction)setCurrentLocation:(id)sender
{
    if([self isExistingItem]){
        [self performSegueWithIdentifier:@"toMap" sender:self];
        return;
    }

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL didPreviouslyAddLocation = [defaults boolForKey:AYIUserDidAddLocationPreference];
    BOOL didPreviouslyChooseAutoLocation = [defaults boolForKey:AYIUserDidDecideOnAutoLocationPreference];
    if(didPreviouslyAddLocation && ![RWSLocationManager isAutoLocationEnabled] && !didPreviouslyChooseAutoLocation){
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:AYIUserDidDecideOnAutoLocationPreference];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Auto-add Location" message:@"Do you want to always add location to new items?\n(This can be disabled in settings.)" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"No Thanks" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *autoAdd = [UIAlertAction actionWithTitle:@"Auto" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self.locationManager enableAutoUpdates];
        }];
        
        [alert addAction:cancel];
        [alert addAction:autoAdd];
        
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        [defaults setBool:YES forKey:AYIUserDidAddLocationPreference];
    }

    [self.locationManager updateLocation];
    [sender setTitle:@"Finding location..." forState:UIControlStateNormal];
}

- (IBAction)dismissKeyboard:(id)sender
{
    [self.view endEditing:NO];

    [self updateNameAndPriceFieldsForItem];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.priceField){
        if([textField.text length] == 0){
            NSLocale *locale = [NSLocale currentLocale];
            setCurrencyOnTextField([locale currencyCode], locale, textField);
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

    if(textField == self.nameField){
        [self.priceField becomeFirstResponder];
    }

    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    RWSItemParser *parser = self.parser;
    NSString *totalString = [[textField text] stringByReplacingCharactersInRange:range withString:string];
    id<RWSItem> item = [parser itemFromText:totalString];
    if([string length] == 0){
        item = [parser itemFromText:[textField text]];
    }

    if(textField == self.priceField){
        NSString *currencySymbol = [[[NSLocale currentLocale] localeWithCurrency:item.currencyCode] currencySymbol];
        if([[textField text] length] == [currencySymbol length] && [string length] == 0){
            return NO;
        }

        self.item.price = item.price;
        self.item.currencyCode = item.currencyCode;
    }

    if(textField == self.nameField){
        self.item.name = item.name;
        self.title = item.name;
    }

    self.navigationItem.rightBarButtonItem.enabled = [self.item isValid];
    
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.item.notes = textView.text;
}

- (void)updateNameAndPriceFieldsForItem
{
    self.nameField.text = self.item.name;
    UITextField *priceField = self.priceField;
    if(self.item.price){
        RWSPriceFormatter *formatter = [[RWSPriceFormatter alloc] init];
        NSString *text = [formatter stringFromNumber:[self.item price] currency:[self.item currencyCode]];
        priceField.text = text;
    }else{
        priceField.text = nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if(section == 1){
        CGRect frame = CGRectMake(0.0, 0.0, 320.0, 44.0);
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectInset(frame, 15.0, 0.0)];
        label.text = @"Notes";
        label.textColor = [UIColor iOS7darkGrayColor];
        label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption1];
        [view addSubview:label];
        return view;
    }

    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section != 0){
        return nil;
    }

    return self.locationButton;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section != 0){
        return 0.0;
    }

    return CGRectGetHeight(self.locationButton.bounds);
}

-(void)locationManagerDidDetermineLocation:(RWSLocationManager *)manager
{
    CLPlacemark *placemark = manager.placemark;

    NSMutableDictionary *addressDictionary = [placemark.addressDictionary mutableCopy];
    [addressDictionary removeObjectForKey:@"Country"];

    NSString *addressString = ABCreateStringWithAddressDictionary(addressDictionary, NO);
    [self.locationButton setTitle:addressString forState:UIControlStateNormal];

    self.item.addressString = addressString;
    self.item.coordinate = placemark.location.coordinate;
}

- (void)locationManagerDidFailToDetermineLocation:(RWSLocationManager *)manager
{
    [self.locationButton setTitle:@"Unable to determine location." forState:UIControlStateNormal];
}

- (IBAction)setUSD:(id)sender
{
    UITextField *priceField = self.priceField;
    if([priceField isFirstResponder]){
        setCurrencyOnTextField(@"USD", [NSLocale currentLocale], priceField);
    }
}

- (IBAction)setGBP:(id)sender
{
    UITextField *priceField = self.priceField;
    if([priceField isFirstResponder]){
        setCurrencyOnTextField(@"GBP", [NSLocale currentLocale], priceField);
    }
}

- (IBAction)setEUR:(id)sender
{
    UITextField *priceField = self.priceField;
    if([priceField isFirstResponder]){
        setCurrencyOnTextField(@"EUR", [NSLocale currentLocale], priceField);
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = [segue identifier];
    if([identifier isEqualToString:@"toPhotos"]){
        RWSPhotosViewController *controller = [segue destinationViewController];
        controller.item = self.item;
    }

    if([identifier isEqualToString:@"toMap"]){
        RWSMapViewController *controller = [segue destinationViewController];
        [controller setItemSource:[[RWSSingularItemSource alloc] initWithItem:self.item]];
    }
}

@end
