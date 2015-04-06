//
//  RWSPageControlView.m
//  Manifest
//
//  Created by Samuel Goodwin on 03-05-14.
//
//

#import "RWSPageControlView.h"
#import "RWSPageAttributes.h"
#import "UIColor+RWSAppColors.h"

@implementation RWSPageControlView

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    RWSPageAttributes *attributes = (RWSPageAttributes*)layoutAttributes;

    self.pageControl.numberOfPages = attributes.pageCount;
    self.pageControl.currentPage = attributes.pageIndex;
    self.pageControl.tintColor = [UIColor tintColor];
}

@end
