//
//  RWSPhotoCell.m
//  Manifest
//
//  Created by Samuel Goodwin on 22-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSPhotoCell.h"

@interface RWSPhotoCell()
@property (nonatomic, weak) IBOutlet UIImageView *imageView;
@property (nonatomic, weak) IBOutlet UIButton *deleteButton;
@property (nonatomic, weak) IBOutlet UIButton *shareButton;
@end

@implementation RWSPhotoCell

- (void)setPhoto:(id<RWSPhoto>)photo
{
    UIImage *thumbnailImage = [photo thumbnailImage];
    NSParameterAssert(thumbnailImage);
    self.imageView.image = thumbnailImage;
}

- (IBAction)delete:(id)sender
{
    [self.delegate cellDidChoseDeleteAction:self];
}

- (IBAction)share:(id)sender
{
    [self.delegate cellDidChoseShareAction:self];
}

- (void)setSelected:(BOOL)selected
{
    CGFloat opacityValue = 0.0f;
    if(selected){
        opacityValue = 1.0f;
    }

    [UIView animateWithDuration:0.3 animations:^{
        self.deleteButton.alpha = opacityValue;
        self.shareButton.alpha = opacityValue;
    } completion:^(BOOL finished) {
        if(selected){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self setSelected:NO];
            });
        }
    }];
}

@end
