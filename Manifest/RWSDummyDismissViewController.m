//
//  RWSDummyDismissViewController.m
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSDummyDismissViewController.h"

@interface RWSDummyDismissViewController ()

@end

@implementation RWSDummyDismissViewController

- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
