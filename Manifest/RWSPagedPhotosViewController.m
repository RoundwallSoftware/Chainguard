//
//  RWSPagedPhotosViewController.m
//  Manifest
//
//  Created by Samuel Goodwin on 28-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSPagedPhotosViewController.h"
#import "RWSBigImageViewController.h"

@interface RWSPagedPhotosViewController ()
@property (nonatomic, weak) IBOutlet UIPageViewController *pageController;
@end

@implementation RWSPagedPhotosViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIPageViewController *controller = [self.childViewControllers firstObject];
    controller.dataSource = self;

    self.pageController = controller;

    RWSBigImageViewController *imageController = [self.storyboard instantiateViewControllerWithIdentifier:@"bigImage"];
    id<RWSPhoto> photo = [self.item photoAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    imageController.index = 0;
    imageController.photo = photo;
    [controller setViewControllers:@[imageController] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    RWSBigImageViewController *lastController = (RWSBigImageViewController *)viewController;
    NSInteger index = lastController.index+1;

    if(index >= [self.item photoCount]){
        return nil;
    }

    id<RWSPhoto> photo = [self.item photoAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    RWSBigImageViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"bigImage"];
    controller.photo = photo;
    controller.index = index;
    return controller;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    RWSBigImageViewController *previousController = (RWSBigImageViewController *)viewController;
    NSInteger index = previousController.index-1;

    if(index <= 0){
        return nil;
    }

    id<RWSPhoto> photo = [self.item photoAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    RWSBigImageViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"bigImage"];
    controller.photo = photo;
    return controller;
}

- (IBAction)tapOnScreen:(id)sender
{
    BOOL hidden = self.navigationController.isNavigationBarHidden;
    [self.navigationController setNavigationBarHidden:!hidden animated:YES];
}

@end
