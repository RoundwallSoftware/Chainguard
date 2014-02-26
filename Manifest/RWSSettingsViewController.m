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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section != 1){
        return;
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://google.com"]];
    }
    if(indexPath.row == 0){
        MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
        mailController.mailComposeDelegate = self;
        [mailController setToRecipients:@[@"samuel@roundwallsoftare.com"]];
        [mailController setSubject:@"Manifest Feedback"];

        [self presentViewController:mailController animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
