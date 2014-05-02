#import "RWSManagedPhoto.h"
#import "UIImage+CODImageScaling.h"


@interface RWSManagedPhoto ()

// Private interface goes here.

@end


@implementation RWSManagedPhoto

- (void)setImage:(UIImage *)image
{
    UIImage *fullImage = [image cod_imageScaledToFitSize:CGSizeMake(640.0, 640.0)];
    NSData *fullData = UIImagePNGRepresentation(fullImage);
    self.imageData = fullData;

    UIImage *thumbnailImage = [image cod_imageScaledToFitSize:CGSizeMake(160.0, 160.0)];
    NSData *thumbnailData = UIImagePNGRepresentation(thumbnailImage);
    self.thumbnailData = thumbnailData;
}

- (UIImage *)fullImage
{
    return [UIImage imageWithData:self.imageData];
}

- (UIImage *)thumbnailImage
{
    return [UIImage imageWithData:self.thumbnailData];
}

@end
