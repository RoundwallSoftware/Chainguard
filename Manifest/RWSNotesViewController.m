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

    self.textView.text = self.item.notes;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.textView becomeFirstResponder];
}

- (void)textViewDidChange:(UITextView *)textView
{
    self.item.notes = textView.text;
}

@end
