//
//  RWSPagedPhotosViewController.h
//  Manifest
//
//  Created by Samuel Goodwin on 28-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSProject.h"

@interface RWSPagedPhotosViewController : UIViewController<UIPageViewControllerDataSource>
@property (nonatomic, strong) id<RWSItem> item;
@property (nonatomic, assign) NSInteger initialIndex;

- (IBAction)tapOnScreen:(id)sender;
@end
