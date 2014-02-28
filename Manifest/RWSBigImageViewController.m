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
@end

@implementation RWSBigImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.imageView.image = [self.photo fullImage];
}

@end
