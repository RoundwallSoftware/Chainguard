//
//  UIImage+CODImageScaling.m
//  ImageScaler
//
//  Created by Collin Donnell on 9/21/13.
//

#import "UIImage+CODImageScaling.h"

@implementation UIImage (CODImageScaling)

- (UIImage *)cod_imageScaledToFitSize:(CGSize)size
{
    CGRect drawingRect = [self cod_centeredRectForSize:self.size scaledToFitSize:size];
    UIGraphicsBeginImageContextWithOptions(drawingRect.size, NO, 0.0f);
    [self drawInRect:drawingRect];
    
    return UIGraphicsGetImageFromCurrentImageContext();
}

- (CGRect)cod_centeredRectForSize:(CGSize)originalSize scaledToFitSize:(CGSize)constrainingSize
{
    CGFloat largerDimension = fmaxf(originalSize.width, originalSize.height);
    CGFloat constrainingDimension = (largerDimension == originalSize.width) ? constrainingSize.height : constrainingSize.width;
    CGFloat scale = constrainingDimension / largerDimension;
    
    CGFloat scaledWidth = originalSize.width * scale;
    CGFloat scaledHeight = originalSize.height * scale;

    return CGRectMake(0.0f, 0.0f, scaledWidth, scaledHeight);
}

@end
