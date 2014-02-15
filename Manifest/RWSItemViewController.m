//
//  RWSNewPartViewController.m
//  Manifest
//
//  Created by Samuel Goodwin on 30-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSItemViewController.h"
#import "RWSPriceFormatter.h"
#import "RWSDumbItem.h"
#import "RWSPriceInputManager.h"
#import "RWSItemParser.h"
#import "UIColor+iOS7Colors.h"
@import AddressBookUI;

@interface RWSItemViewController ()
@property (nonatomic, assign, getter = isExistingItem) BOOL existingItem;
@end

@implementation RWSItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

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

        [self.reverseParser setName:self.item.name];
        [self.reverseParser setPriceInput:priceField.text];
        self.quickInputField.text = [self.reverseParser inputString];

        if(self.item.addressString){
            [self.locationButton setTitle:self.item.addressString forState:UIControlStateNormal];
        }
    }else{
        self.tableView.tableFooterView = nil;
        self.item = [[RWSDumbItem alloc] init];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if(!self.isExistingItem){
        [self.quickInputField becomeFirstResponder];
    }
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
    [self.locationManager updateLocation];
    [sender setTitle:@"Finding location..." forState:UIControlStateNormal];
}

- (IBAction)dismissKeyboard:(id)sender
{
    [self.view endEditing:NO];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == self.priceField){
        setCurrencyOnTextField(@"USD", textField);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    RWSItemParser *parser = self.parser;
    NSString *totalString = [[textField text] stringByReplacingCharactersInRange:range withString:string];

    UITextField *quickInputField = self.quickInputField;
    if(textField == quickInputField){
        id<RWSItem> item = [parser itemFromText:totalString];
        self.item.price = item.price;
        self.item.name = item.name;
        self.item.currencyCode = item.currencyCode;
        [self updateNameAndPriceFieldsForItem];

        [self.reverseParser setName:item.name];
        if(item.price){
            RWSPriceFormatter *formatter = [[RWSPriceFormatter alloc] init];
            [self.reverseParser setPriceInput:[formatter stringFromNumber:item.price currency:item.currencyCode]];
        }
    }

    if(textField == self.priceField){
        if([[textField text] length] == 1 && [string length] == 0){
            return NO;
        }

        [self.reverseParser setPriceInput:totalString];

        quickInputField.text = self.reverseParser.inputString;

        id<RWSItem> item = [parser itemFromText:self.reverseParser.inputString];
        self.item.price = item.price;
        self.item.currencyCode = item.currencyCode;
    }


    if(textField == self.nameField){
        [self.reverseParser setName:totalString];

        quickInputField.text = self.reverseParser.inputString;
        id<RWSItem> item = [parser itemFromText:self.reverseParser.inputString];
        self.item.name = item.name;
    }
    
    return YES;
}

- (void)updateNameAndPriceFieldsForItem
{
    self.nameField.text = self.item.name;
    //[self.reverseParser setName:parser.name];
    UITextField *priceField = self.priceField;
    if(self.item.price){
        RWSPriceFormatter *formatter = [[RWSPriceFormatter alloc] init];
        NSString *text = [formatter stringFromNumber:[self.item price] currency:[self.item currencyCode]];
        priceField.text = text;
        //[self.reverseParser setPriceInput:text];
    }else{
        priceField.text = nil;
    }
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
    setCurrencyOnTextField(@"USD", self.priceField);
}

@end
