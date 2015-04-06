//
//  RWSPagedLayout.m
//  Manifest
//
//  Created by Samuel Goodwin on 03-05-14.
//
//

#import "RWSPagedLayout.h"
#import "RWSPageAttributes.h"

@interface RWSPagedLayout()
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@end


@implementation RWSPagedLayout

- (instancetype)init
{
    self = [super init];
    if(self){
        [self registerNib:[UINib nibWithNibName:@"RWSPageControlView" bundle:nil] forDecorationViewOfKind:@"pagecontrol"];
    }
    return self;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *pages = [super layoutAttributesForElementsInRect:rect];

    RWSPageAttributes *pageControlAttributes = [RWSPageAttributes layoutAttributesForDecorationViewOfKind:@"pagecontrol" withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    CGSize itemSize = [self itemSize];
    CGSize contentSize = [self collectionViewContentSize];
    CGPoint offset = [[self collectionView] contentOffset];
    pageControlAttributes.frame = CGRectMake(offset.x, itemSize.height-44.0, itemSize.width, 44.0);
    pageControlAttributes.zIndex = 37;
    pageControlAttributes.pageCount = contentSize.width/itemSize.width;
    pageControlAttributes.pageIndex = floor(offset.x/itemSize.width);

    return [pages arrayByAddingObject:pageControlAttributes];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
