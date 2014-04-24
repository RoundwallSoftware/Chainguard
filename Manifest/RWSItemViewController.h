//
//  RWSNewPartViewController.h
//  Manifest
//
//  Created by Samuel Goodwin on 30-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSProject.h"
#import "RWSLocationManager.h"
#import "RWSReverseItemParser.h"

@protocol RWSItemDelegate;
@class RWSItemParser;
@class RWSExchangeRates;
@class RWSPhotosViewController;
@interface RWSItemViewController : UITableViewController<UITextFieldDelegate, RWSLocationManagerDelegate, UITextViewDelegate, UIAlertViewDelegate>
@property (nonatomic, strong) IBOutlet RWSItemParser *parser;
@property (nonatomic, strong) IBOutlet RWSLocationManager *locationManager;
@property (nonatomic, strong) IBOutlet RWSExchangeRates *rates;
@property (nonatomic, weak) IBOutlet UITextField *nameField;
@property (nonatomic, weak) IBOutlet UITextField *priceField;
@property (nonatomic, strong) UIButton *locationButton;
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;
@property (nonatomic, strong) IBOutlet RWSPhotosViewController *photosController;
@property (nonatomic, weak) IBOutlet UICollectionView *photosView;
@property (nonatomic, weak) id<RWSItemDelegate> delegate;
@property (nonatomic, strong) id<RWSItem> item;

- (IBAction)save:(id)sender;
- (IBAction)delete:(id)sender;
- (IBAction)setCurrentLocation:(id)sender;
- (IBAction)dismissKeyboard:(id)sender;

- (IBAction)setUSD:(id)sender;
- (IBAction)setEUR:(id)sender;
- (IBAction)setGBP:(id)sender;
@end

@protocol RWSItemDelegate
- (void)itemController:(RWSItemViewController *)controller didMakeItem:(id<RWSItem>)itemOrNil;
- (void)itemController:(RWSItemViewController *)controller didDeleteItem:(id<RWSItem>)itemOrNil;
@end
