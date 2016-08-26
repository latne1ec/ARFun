//
//  MapViewController.m
//  arfun
//
//  Created by Evan Latner on 8/25/16.
//  Copyright © 2016 arfun. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.goBackButton = [[UIButton alloc] initWithFrame:CGRectMake(30, self.view.frame.size.height-60, 100, 30)];
    [self.goBackButton setTitle:@"Go Back" forState:UIControlStateNormal];
    self.goBackButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Bold" size:16];
    [self.goBackButton setBackgroundColor:[UIColor colorWithRed:0.93 green:0.15 blue:0.42 alpha:1.0]];
    self.goBackButton.layer.cornerRadius = 6;
    [self.goBackButton addTarget:self action:@selector(goBackButtonTapped:) forControlEvents:UIControlEventTouchUpInside];

}

-(void)viewWillAppear:(BOOL)animated {
    
    [self setUpMap];
}

-(void)setUpMap {
    
    self.map = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CLLocationCoordinate2D coordinates;
    coordinates.latitude = self.currentLocation.coordinate.latitude;
    coordinates.longitude = self.currentLocation.coordinate.longitude;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinates, 5*100, 5*100);
    region.span.longitudeDelta = 0.06f;
    region.span.latitudeDelta = 0.06f;
    [self.map setRegion:region animated:NO];
    self.map.showsUserLocation = YES;
    self.map.opaque = true;
    self.map.alpha = 0.0;
    self.map.delegate = self;
    self.map.showsPointsOfInterest = false;
    self.map.showsBuildings = false;
    self.map.userInteractionEnabled = true;
    [self.view addSubview:self.map];
    [UIView animateWithDuration:0.12 delay:0.22 options:0 animations:^{
        self.map.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self.view addSubview:self.map];
        //}];
        
        self.map.showsUserLocation = YES;
        
    }];
    
    [self addMapAnnotations];
    
    [self.map addSubview:self.goBackButton];
}

-(void)addMapAnnotations {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.venues.count; i++) {
        
        NSMutableDictionary *object = [self.venues objectAtIndex:i];
        CLLocationDegrees lat = [[[[object objectForKey:@"location"] valueForKey:@"coordinate"] valueForKey:@"latitude"] doubleValue];
        CLLocationDegrees lon = [[[[object objectForKey:@"location"] valueForKey:@"coordinate"] valueForKey:@"longitude"] doubleValue];
        CLLocationCoordinate2D coordinates;
        coordinates.latitude = lat;
        coordinates.longitude = lon;
        
        CLLocationCoordinate2D userCoordinates;
        userCoordinates.latitude = self.currentLocation.coordinate.latitude;
        userCoordinates.longitude = self.currentLocation.coordinate.longitude;
        
        //NSString *venueName = [object objectForKey:@"name"];
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.title = [object objectForKey:@"name"];
        //annotation.subtitle = @"Tap For Directions";
        [annotation setCoordinate:coordinates];
        [array addObject:annotation];
    }
    
    [self.map showAnnotations:array animated:YES];
    //[self.map selectAnnotation:[array objectAtIndex:0] animated:YES];
    
    [self performSelector:@selector(setCamera:) withObject:self.map afterDelay:0.30];
}

-(void)setCamera: (MKMapView *)map {
    
    MKMapCamera *newCamera = [[map camera] copy];
    [newCamera setPitch:45.0];
    //[newCamera setHeading:27.0];
    //[newCamera setAltitude:500.0];
    [map setCamera:newCamera animated:YES];
}

- (IBAction)goBackButtonTapped:(id)sender {
    
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}
@end
