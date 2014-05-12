//
//  RWSPhotosViewController.h
//  Manifest
//
//  Created by Samuel Goodwin on 22-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSProject.h"
#import "RWSPhotoCell.h"

@interface RWSPhotosViewController : UICollectionViewController<UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, RWSPhotoCellDelegate>
@property (nonatomic, strong) NSObject<RWSItem> *item;

- (IBAction)addPhoto:(id)sender;
@end
