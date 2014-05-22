//
//  RWSPhotosViewController.m
//  Manifest
//
//  Created by Samuel Goodwin on 22-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSPhotosViewController.h"
#import "RWSPagedPhotosViewController.h"
@import AssetsLibrary;

@import MobileCoreServices;

@interface RWSPhotosViewController ()
@property (nonatomic, strong) ALAssetsLibrary *library;
@end

@implementation RWSPhotosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.collectionView.pagingEnabled = YES;

    [self.collectionView registerNib:[UINib nibWithNibName:@"RWSPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"photo"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"RWSAddPhotoCell" bundle:nil] forCellWithReuseIdentifier:@"add"];

    [self.item addObserver:self forKeyPath:@"photos" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc
{
    [_item removeObserver:self forKeyPath:@"photos"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([self presentedViewController]){
        return;
    }

    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section == 0){
        return [self.item photoCount];
    }

    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){
        return [collectionView dequeueReusableCellWithReuseIdentifier:@"add" forIndexPath:indexPath];
    }

    RWSPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];

    [cell setPhoto:[self.item photoAtIndexPath:indexPath]];
    cell.delegate = self;

    return cell;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    [self.item addPhotoWithImage:image];

    [self.parentViewController dismissViewControllerAnimated:YES completion:^{
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
    controller.allowsEditing = YES;
    controller.delegate = self;
    controller.mediaTypes = @[(NSString *)kUTTypeImage];
    if(buttonIndex == 2){
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        NSParameterAssert(buttonIndex == 1);
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    }

    [self.parentViewController presentViewController:controller animated:YES completion:nil];
}

- (IBAction)addPhoto:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Use Latest Photo", @"Take Photo", @"Choose From Library", nil];
    [sheet showInView:self.parentViewController.view];
}

- (void)useLatestPhotoFromCameraRoll
{
    self.library = [[ALAssetsLibrary alloc] init];
    [self.library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *libraryStop) {
        [group setAssetsFilter:[ALAssetsFilter allPhotos]];
        NSInteger assetCount = [group numberOfAssets];
        if(assetCount <= 0){
            return;
        }

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

    } failureBlock:^(NSError *error) {
        NSLog(@"Error: %@", error);
        if([error code] == -3311){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"We aren't allowed to access your photos." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert show];
        }
    }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){
        [self addPhoto:nil];
        return;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RWSPagedPhotosViewController *controller = [segue destinationViewController];
    controller.item = self.item;

    NSIndexPath *selectedIndexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
    controller.initialIndex = [selectedIndexPath item];
}

- (void)cellDidChoseDeleteAction:(RWSPhotoCell *)cell
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    [self.item deletePhotoAtIndexPath:indexPath];
}

@end
