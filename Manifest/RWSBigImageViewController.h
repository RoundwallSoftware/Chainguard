//
//  RWSBigImageViewController.h
//  Manifest
//
//  Created by Samuel Goodwin on 28-02-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSProject.h"

@interface RWSBigImageViewController : UIViewController
@property (nonatomic, strong) id<RWSPhoto> photo;
@property (nonatomic, assign) NSInteger index;
@end
