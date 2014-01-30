//
//  RWSNewPartViewController.h
//  Manifest
//
//  Created by Samuel Goodwin on 30-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSProject.h"

@protocol RWSNewItemDelegate;

@interface RWSNewItemViewController : UIViewController
@property (nonatomic, weak) id<RWSNewItemDelegate> delegate;

- (IBAction)save:(id)sender;
@end

@protocol RWSNewItemDelegate
- (void)newItemController:(RWSNewItemViewController *)controller didMakeItem:(id<RWSItem>)item;
@end
