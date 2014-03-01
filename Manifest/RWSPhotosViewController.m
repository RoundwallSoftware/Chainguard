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

@end

@implementation RWSPhotosViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if(![self.item photoCount]){
        [self addPhoto:nil];
    }
}

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
        [self addLatestPhotoFromCameraRoll];
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

- (void)addLatestPhotoFromCameraRoll
{
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *libraryStop) {
        NSInteger assetCount = [group numberOfAssets];
        if(assetCount <= 0){
            return;
        }

        NSIndexSet *indexes = [NSIndexSet indexSetWithIndex:assetCount-1];
        [group enumerateAssetsAtIndexes:indexes options:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *groupStop) {
            if(result){
                CGImageRef imageRef = [[result defaultRepresentation] fullResolutionImage];
                [self.item addPhotoWithImage:[UIImage imageWithCGImage:imageRef]];

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
