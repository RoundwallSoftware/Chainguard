//
//  RWSDummyDismissViewController.m
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSMapViewController.h"
#import "MKMapView+Centering.h"

NSString *const RWSMapCenterLatitude = @"RWSMapCenterLatitude";
NSString *const RWSMapCenterLongitude = @"RWSMapCenterLongitude";
NSString *const RWSMapCenterLatitudeDelta = @"RWSMapCenterLatitudeDelta";
NSString *const RWSMapCenterLongitudeDelta = @"RWSMapCenterLongitudeDelta";

@interface RWSMapViewController ()

@end

@implementation RWSMapViewController

- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    MKMapView *map = self.mapView;
    [map addAnnotations:[self.itemSource annotations]];
    [map centerMapProperly];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    self.closeButton.alpha = 1.0;
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    self.closeButton.alpha = 0.2;
}

@end
