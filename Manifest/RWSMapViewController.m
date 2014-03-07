//
//  RWSDummyDismissViewController.m
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSMapViewController.h"

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

    [self.mapView addAnnotations:[self.itemSource annotations]];
}

- (void)encodeRestorableStateWithCoder:(NSCoder *)coder
{
    MKCoordinateRegion region = [self.mapView region];
    [coder encodeDouble:region.center.latitude forKey:RWSMapCenterLatitude];
    [coder encodeDouble:region.center.longitude forKey:RWSMapCenterLongitude];
    [coder encodeDouble:region.span.latitudeDelta forKey:RWSMapCenterLatitudeDelta];
    [coder encodeDouble:region.span.longitudeDelta forKey:RWSMapCenterLongitudeDelta];

    [super encodeRestorableStateWithCoder:coder];
}

- (void)decodeRestorableStateWithCoder:(NSCoder *)coder
{
    MKCoordinateRegion region;
    CLLocationCoordinate2D center;
    center.latitude = [coder decodeDoubleForKey:RWSMapCenterLatitude];
    center.longitude = [coder decodeDoubleForKey:RWSMapCenterLongitude];
    region.center = center;
    MKCoordinateSpan span;
    span.latitudeDelta = [coder decodeDoubleForKey:RWSMapCenterLatitudeDelta];
    span.longitudeDelta = [coder decodeDoubleForKey:RWSMapCenterLongitudeDelta];
    region.span = span;

    self.mapView.region = region;

    [super decodeRestorableStateWithCoder:coder];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    self.closeButton.alpha = 1.0;
}

- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    self.closeButton.alpha = 0.2;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    [mapView setCenterCoordinate:userLocation.coordinate animated:YES];
}

@end
