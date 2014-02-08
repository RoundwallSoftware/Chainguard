//
//  RWSNewPartViewController.m
//  Manifest
//
//  Created by Samuel Goodwin on 30-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSNewItemViewController.h"
#import "RWSPriceFormatter.h"
#import "RWSDumbItem.h"
#import "RWSPriceInputManager.h"
#import "RWSItemParser.h"
@import AddressBookUI;

@interface RWSNewItemViewController ()
@property (nonatomic, strong) RWSDumbItem *item;
@end

@implementation RWSNewItemViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIView *toolbar = [[[UINib nibWithNibName:@"CurrencyToolbar" bundle:nil] instantiateWithOwner:self options:nil] firstObject];
    self.priceField.inputAccessoryView = toolbar;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.quickInputField becomeFirstResponder];
}

- (IBAction)save:(id)sender
{
    [self.delegate newItemController:self didMakeItem:self.item];
}

- (IBAction)dismiss:(id)sender
{
    [self.delegate newItemController:self didMakeItem:nil];
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

- (RWSDumbItem *)item
{
    if(_item){
        return _item;
    }

    _item = [[RWSDumbItem alloc] init];
    return _item;
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
