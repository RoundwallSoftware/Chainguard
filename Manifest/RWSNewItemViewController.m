//
//  RWSNewPartViewController.m
//  Manifest
//
//  Created by Samuel Goodwin on 30-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSNewItemViewController.h"

@interface RWSNewItemViewController ()

@end

@implementation RWSNewItemViewController

- (IBAction)save:(id)sender
{
    [self.delegate newItemController:self didMakeItem:nil];
}

@end
