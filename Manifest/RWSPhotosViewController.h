//
//  RWSPhotosViewController.h
//  Manifest
//
//  Created by Samuel Goodwin on 22-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSProject.h"

@interface RWSPhotosViewController : NSObject<UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) id<RWSItem> item;
@property (nonatomic, weak) IBOutlet UIViewController *parentViewController;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;

- (IBAction)addPhoto:(id)sender;
@end
