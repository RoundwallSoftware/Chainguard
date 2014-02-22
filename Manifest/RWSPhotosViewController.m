//
//  RWSPhotosViewController.m
//  Manifest
//
//  Created by Samuel Goodwin on 22-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSPhotosViewController.h"
#import "RWSPhotoCell.h"
@import MobileCoreServices;

@interface RWSPhotosViewController ()

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
    
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.delegate = self;
    controller.mediaTypes = @[(NSString *)kUTTypeImage];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;

    [self presentViewController:controller animated:YES completion:nil];
}

- (IBAction)addPhoto:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Use Latest Photo", @"Take Photo", @"Choose From Library", nil];
    [sheet showInView:self.view];
}

@end
