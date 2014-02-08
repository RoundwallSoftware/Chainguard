//
//  RWSNewPartViewController.h
//  Manifest
//
//  Created by Samuel Goodwin on 30-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSProject.h"
#import "RWSItemParser.h"
#import "RWSLocationManager.h"
#import "RWSReverseItemParser.h"

@protocol RWSNewItemDelegate;

@interface RWSNewItemViewController : UIViewController<UITextFieldDelegate, RWSItemParserDelegate, RWSLocationManagerDelegate>
@property (nonatomic, strong) IBOutlet RWSItemParser *parser;
@property (nonatomic, strong) IBOutlet RWSLocationManager *locationManager;
@property (nonatomic, strong) IBOutlet RWSReverseItemParser *reverseParser;
@property (nonatomic, weak) IBOutlet UITextField *quickInputField;
@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UITextField *priceField;
@property (nonatomic, weak) IBOutlet UIButton *locationButton;

@property (nonatomic, weak) id<RWSNewItemDelegate> delegate;

- (IBAction)save:(id)sender;
- (IBAction)dismiss:(id)sender;
- (IBAction)setCurrentLocation:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

- (IBAction)setUSD:(id)sender;
@end

@protocol RWSNewItemDelegate
- (void)newItemController:(RWSNewItemViewController *)controller didMakeItem:(id<RWSItem>)itemOrNil;
@end
