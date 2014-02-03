//
//  RWSDummyDismissViewController.h
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

@import MapKit;
#import "RWSMapItemSource.h"

@interface RWSMapViewController : UIViewController<MKMapViewDelegate>
@property (nonatomic, weak) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) id<RWSMapItemSource> itemSource;
@property (nonatomic, weak) IBOutlet UIButton *closeButton;

- (IBAction)close:(id)sender;
@end
