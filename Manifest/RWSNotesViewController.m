//
//  RWSNotesViewController.m
//  Manifest
//
//  Created by Samuel Goodwin on 22-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSNotesViewController.h"

@interface RWSNotesViewController ()

@end

@implementation RWSNotesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.textView.text = self.initialText;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.textView becomeFirstResponder];
}

@end
