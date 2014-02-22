//
//  RWSPhotosViewController.h
//  Manifest
//
//  Created by Samuel Goodwin on 22-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSProject.h"

@interface RWSPhotosViewController : UICollectionViewController<UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) id<RWSItem> item;

- (IBAction)addPhoto:(id)sender;
@end
