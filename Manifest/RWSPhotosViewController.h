//
//  RWSPhotosViewController.h
//  Manifest
//
//  Created by Samuel Goodwin on 22-02-14.
//
//

#import "RWSProject.h"
#import "RWSPhotoCell.h"

@interface RWSPhotosViewController : UICollectionViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate, RWSPhotoCellDelegate>
@property (nonatomic, strong) NSObject<RWSItem> *item;

- (IBAction)addPhoto:(id)sender;
@end
