//
//  RWSDummyDismissViewController.m
//  Manifest
//
//  Created by Samuel Goodwin on 27-01-14.
//  Copyright (c) 2014 Roundwall Software. All rights reserved.
//

#import "RWSMapViewController.h"
#import "MKMapView+Centering.h"
#import "RWSProject.h"
#import "RWSItemViewController.h"

NSString *const RWSMapCenterLatitude = @"RWSMapCenterLatitude";
NSString *const RWSMapCenterLongitude = @"RWSMapCenterLongitude";
NSString *const RWSMapCenterLatitudeDelta = @"RWSMapCenterLatitudeDelta";
NSString *const RWSMapCenterLongitudeDelta = @"RWSMapCenterLongitudeDelta";

@interface RWSMapViewController ()
@property (nonatomic, strong) CLLocationManager *manager;
@end

@implementation RWSMapViewController

- (IBAction)close:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if(status != kCLAuthorizationStatusAuthorizedAlways && status != kCLAuthorizationStatusAuthorizedWhenInUse){
        self.manager = [[CLLocationManager alloc] init];
        [self.manager  requestWhenInUseAuthorization];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

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

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    pin.canShowCallout = YES;
    if([[[self  itemSource] annotations] count] > 1){
        pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    return pin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"toItem" sender:self];
}

- (void)showViewController:(UIViewController *)vc sender:(id)sender
{
    UIViewController *controller = [self presentingViewController];
    
    [controller dismissViewControllerAnimated:YES completion:^{
        [controller showViewController:vc sender:sender];
    }];
}

- (id<RWSItem>)selectedItem
{
    return [[self.mapView selectedAnnotations] firstObject];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSString *identifier = [segue identifier];
    if([identifier isEqualToString:@"toItem"]){
        RWSItemViewController *controller = [segue destinationViewController];
        
        controller.item = [self selectedItem];
        NSParameterAssert(controller.item);
    }
}

@end
