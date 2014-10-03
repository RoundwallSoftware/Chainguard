//
//  RWProjectViewController.h
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSProject.h"
#import "RWSItemViewController.h"
#import "RWSItemCell.h"

@interface RWSProjectViewController : UITableViewController<UITextFieldDelegate, RWSItemDelegate>
@property (nonatomic, strong) id<RWSProject> project;

- (IBAction)share:(id)sender;
- (IBAction)changePrice:(id)sender;
@end
