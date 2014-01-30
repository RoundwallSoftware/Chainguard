//
//  RWSNewPartViewController.m
//  Manifest
//
//  Created by Samuel Goodwin on 30-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSNewItemViewController.h"
#import "RWSPriceFormatter.h"

@interface RWSDumbItem : NSObject<RWSItem>
@property (nonatomic, copy) NSString *name;
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    [self.parser setText:[[textField text] stringByReplacingCharactersInRange:range withString:string]];

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
}

@end
