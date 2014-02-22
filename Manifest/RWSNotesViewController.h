//
//  RWSNotesViewController.h
//  Manifest
//
//  Created by Samuel Goodwin on 22-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSProject.h"

@interface RWSNotesViewController : UIViewController<UITextViewDelegate>
@property (nonatomic, weak) IBOutlet UITextView *textView;
@property (nonatomic, strong) id<RWSItem> item;
@end
