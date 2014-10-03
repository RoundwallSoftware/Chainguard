//
//  RWSPhotosViewController.m
//  Manifest
//
//  Created by Samuel Goodwin on 22-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSPhotosViewController.h"
@import MobileCoreServices;

@interface RWSPhotosViewController ()
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

- (IBAction)addPhoto:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = YES;
    picker.delegate = self;
    picker.mediaTypes = @[(NSString *)kUTTypeImage];

    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [controller addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [controller addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:nil];
        }]];
    }
    
    [controller addAction:[UIAlertAction actionWithTitle:@"Choose From Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }]];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){
        [self addPhoto:nil];
        return;
    }
}

- (void)cellDidChoseDeleteAction:(RWSPhotoCell *)cell
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    [self.item deletePhotoAtIndexPath:indexPath];
}

- (void)cellDidChoseShareAction:(RWSPhotoCell *)cell
{
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    id<RWSPhoto>photo = [self.item photoAtIndexPath:indexPath];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:@[[photo fullImage]] applicationActivities:nil];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
