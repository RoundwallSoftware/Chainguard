//
//  RWSPhotoCell.m
//  Manifest
//
//  Created by Samuel Goodwin on 22-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSPhotoCell.h"
#import "UIColor+iOS7Colors.h"

@interface RWSPhotoCell()
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@end

@implementation RWSPhotoCell

- (void)setPhoto:(id<RWSPhoto>)photo
{
    self.imageView.image = [photo image];
}

@end
