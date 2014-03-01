//
//  RWSBigImageViewController.m
//  Manifest
//
//  Created by Samuel Goodwin on 28-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSBigImageViewController.h"

@interface RWSBigImageViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@end

@implementation RWSBigImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImageView *imageView = self.imageView;
    UIScrollView *scrollView = self.scrollView;
    UIImage *image = [self.photo fullImage];

    [scrollView removeConstraints:[scrollView constraints]];
    [imageView removeConstraints:[imageView constraints]];

    imageView.image = image;

    imageView.frame = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    [self centerImageView];

    CGFloat scaleFactor = 1.0f/fmaxf(image.size.width/CGRectGetWidth(scrollView.bounds), image.size.height/CGRectGetHeight(scrollView.bounds));

    scrollView.minimumZoomScale = scaleFactor;
    [scrollView setZoomScale:scaleFactor animated:NO];

    scrollView.contentSize = image.size;

    [scrollView setNeedsLayout];
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self centerImageView];
}

- (void)centerImageView
{
    UIImageView *imageView = self.imageView;
    UIScrollView *scrollView = self.scrollView;

    CGRect innerFrame = imageView.frame;
    CGRect scrollerBounds = scrollView.bounds;

    if ( ( innerFrame.size.width < scrollerBounds.size.width ) || ( innerFrame.size.height < scrollerBounds.size.height ) )
    {
        CGFloat tempx = imageView.center.x - ( scrollerBounds.size.width / 2.0f );
        CGFloat tempy = imageView.center.y - ( scrollerBounds.size.height / 2.0f );
        CGPoint myScrollViewOffset = CGPointMake( tempx, tempy);

        scrollView.contentOffset = myScrollViewOffset;

    }

    UIEdgeInsets anEdgeInset = { 0.0f, 0.0f, 0.0f, 0.0f};
    if ( scrollerBounds.size.width > innerFrame.size.width )
    {
        anEdgeInset.left = (scrollerBounds.size.width - innerFrame.size.width) / 2.0f;
        anEdgeInset.right = -anEdgeInset.left;  // I don't know why this needs to be negative, but that's what works
    }
    if ( scrollerBounds.size.height > innerFrame.size.height )
    {
        anEdgeInset.top = (scrollerBounds.size.height - innerFrame.size.height) / 2.0f;
        anEdgeInset.bottom = -anEdgeInset.top;  // I don't know why this needs to be negative, but that's what works
    }
    scrollView.contentInset = anEdgeInset;
}

@end
