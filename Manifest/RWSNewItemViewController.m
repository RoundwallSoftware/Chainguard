//
//  RWSNewPartViewController.m
//  Manifest
//
//  Created by Samuel Goodwin on 30-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSNewItemViewController.h"
#import "RWSPriceFormatter.h"
@import AddressBookUI;

@interface RWSDumbItem : NSObject<RWSItem>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSDecimalNumber *price;
@property (nonatomic, copy) NSString *currencyCode;
@end

@implementation RWSDumbItem
@end

@interface RWSNewItemViewController ()
@property (nonatomic, strong) RWSDumbItem *item;
@end

@implementation RWSNewItemViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.quickInputField becomeFirstResponder];
}

- (IBAction)save:(id)sender
{
    [self.delegate newItemController:self didMakeItem:self.item];
}

- (IBAction)setCurrentLocation:(id)sender
{
    [self.locationManager updateLocation];
    self.locationLabel.text = @"Finding location...";
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
    if(parser.price){
        RWSPriceFormatter *formatter = [[RWSPriceFormatter alloc] init];
        NSString *text = [formatter stringFromNumber:[parser price] currency:[parser currencyCode]];
        self.priceField.text = text;
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

    self.locationLabel.text = ABCreateStringWithAddressDictionary(addressDictionary, NO);
}

@end
