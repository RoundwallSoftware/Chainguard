//
//  RWSPhotosViewController.m
//  Manifest
//
//  Created by Samuel Goodwin on 22-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSPhotosViewController.h"
#import "RWSPhotoCell.h"
#import "RWSPagedPhotosViewController.h"
@import AssetsLibrary;

@import MobileCoreServices;

@interface RWSPhotosViewController ()
@property (nonatomic, strong) ALAssetsLibrary *library;
@end

@implementation RWSPhotosViewController

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.item photoCount];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RWSPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];

    [cell setPhoto:[self.item photoAtIndexPath:indexPath]];

    return cell;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.item addPhotoWithImage:image];

    [self dismissViewControllerAnimated:YES completion:^{
        [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
    }];
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == [actionSheet cancelButtonIndex]){
        return;
    }

    if(buttonIndex == 0){
        [self useLatestPhotoFromCameraRoll];
        return;
    }

    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.mediaTypes = @[(NSString *)kUTTypeImage];
    if(buttonIndex == 2){
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        NSParameterAssert(buttonIndex == 1);
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    }

    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)addPhoto:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Use Latest Photo", @"Take Photo", @"Choose From Library", nil];
    [sheet showInView:self.view];
}

- (void)useLatestPhotoFromCameraRoll
{
    self.library = [[ALAssetsLibrary alloc] init];
    [self.library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *libraryStop) {
        NSInteger assetCount = [group numberOfAssets];
        if(assetCount <= 0){
            return;
        }

        [group setAssetsFilter:[ALAssetsFilter allPhotos]];

        NSIndexSet *indexes = [NSIndexSet indexSetWithIndex:assetCount-1];
        [group enumerateAssetsAtIndexes:indexes options:NSEnumerationReverse usingBlock:^(ALAsset *asset, NSUInteger index, BOOL *groupStop) {
            if(asset){
                ALAssetRepresentation *imageRep = [asset defaultRepresentation];
                CGImageRef imageRef = [imageRep fullScreenImage];
                UIImage *image = [UIImage imageWithCGImage:imageRef];
                
                [self.item addPhotoWithImage:image];

                [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
            }
        }];

    } failureBlock:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RWSPagedPhotosViewController *controller = [segue destinationViewController];
    controller.item = self.item;

    NSIndexPath *selectedIndexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
    controller.initialIndex = [selectedIndexPath item];
}

@end
