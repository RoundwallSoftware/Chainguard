//
//  RWSSettingsViewController.m
//  Manifest
//
//  Created by Samuel Goodwin on 26-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSSettingsViewController.h"
#import "RWSLocationManager.h"

@interface RWSSettingsViewController ()
@property (nonatomic, weak) IBOutlet UITableViewCell *autoLocationCell;
@end

@implementation RWSSettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UISwitch *locationSwitch = [[UISwitch alloc] init];
    [locationSwitch setOn:[RWSLocationManager isAutoLocationEnabled]];
    [locationSwitch addTarget:self action:@selector(locationSwitchChanged:) forControlEvents:UIControlEventValueChanged];
    self.autoLocationCell.accessoryView = locationSwitch;
}

- (void)locationSwitchChanged:(UISwitch *)locationSwitch
{
    [[NSUserDefaults standardUserDefaults] setBool:[locationSwitch isOn] forKey:RWSAutoLocationEnabled];
}

@end
