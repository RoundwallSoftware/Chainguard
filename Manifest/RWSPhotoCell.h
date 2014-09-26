//
//  RWSPhotoCell.h
//  Manifest
//
//  Created by Samuel Goodwin on 22-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSProject.h"

@protocol RWSPhotoCellDelegate;

@interface RWSPhotoCell : UICollectionViewCell
@property (nonatomic, weak) id<RWSPhotoCellDelegate> delegate;

- (void)setPhoto:(id<RWSPhoto>)photo;
- (IBAction)delete:(id)sender;
- (IBAction)share:(id)sender;
@end

@protocol RWSPhotoCellDelegate
- (void)cellDidChoseDeleteAction:(RWSPhotoCell *)cell;
- (void)cellDidChoseShareAction:(RWSPhotoCell *)cell;
@end
