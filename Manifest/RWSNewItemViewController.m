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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.quickInputField){
        [self.parser setText:[[textField text] stringByReplacingCharactersInRange:range withString:string]];
    }

    return YES;
}

- (void)parserDidFinishParsing:(RWSItemParser *)parser
{
    if(!self.item){
        self.item = [[RWSDumbItem alloc] init];
    }
    
    self.nameField.text = parser.name;
    UITextField *priceField = self.priceField;
    if(parser.price){
        RWSPriceFormatter *formatter = [[RWSPriceFormatter alloc] init];
        NSString *text = [formatter stringFromNumber:[parser price] currency:[parser currencyCode]];
        priceField.text = text;
    }else{
        priceField.text = nil;
    }

    self.item.name = parser.name;
    self.item.price = parser.price;
    self.item.currencyCode = parser.currencyCode;
}

-(void)locationManagerDidDetermineLocation:(RWSLocationManager *)manager
{
    CLPlacemark *placemark = manager.placemark;

    NSMutableDictionary *addressDictionary = [placemark.addressDictionary mutableCopy];
    [addressDictionary removeObjectForKey:@"Country"];

    NSString *addressString = ABCreateStringWithAddressDictionary(addressDictionary, NO);
    [self.locationButton setTitle:addressString forState:UIControlStateNormal];

    if(!self.item){
        self.item = [[RWSDumbItem alloc] init];
    }

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
