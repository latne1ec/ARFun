//
//  InitialViewController.m
//  arfun
//
//  Created by Evan Latner on 8/25/16.
//  Copyright © 2016 arfun. All rights reserved.
//

#import "InitialViewController.h"
#import "MapViewController.h"

@interface InitialViewController ()

@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ARGPSManager *GPSManager = [ARGPSManager getInstance];
    [GPSManager initialise];
    [GPSManager start];
    [GPSManager getCurrentLocation];
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    self.dasButton.backgroundColor = [UIColor colorWithRed:0.93 green:0.15 blue:0.42 alpha:1.0];
    [self.dasButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.dasButton.layer.cornerRadius = 12;
    self.dasButton.clipsToBounds = true;
    self.dasButton.alpha = 0.7;
    [self.dasButton setTitle:@"Preparing.." forState:UIControlStateNormal];
    self.dasButton.userInteractionEnabled = false;
    
    [self.mapButton setTitle:@"Preparing.." forState:UIControlStateNormal];
    self.mapButton.userInteractionEnabled = false;
    
    [self.mapButton setTitleColor:[UIColor colorWithRed:0.93 green:0.15 blue:0.42 alpha:1.0] forState:UIControlStateNormal];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    [locationManager stopUpdatingLocation];
    self.currentLocation = newLocation;
    [self getAddressFromLatLon:self.currentLocation];
}

-(void)getNearbyVenues {
    
    NSString *term = @"food";
    NSString *location = self.userCity;
    NSString *category = @"coffee";
    NSString *userLocation = [NSString stringWithFormat:@"%f,%f", self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude];
    
    YPAPISample *APISample = [[YPAPISample alloc] init];
    [APISample queryVenues:term location:location coordinates:userLocation category:category completionHandler:^(NSMutableArray *venues, NSError *error) {
        if (error) {
        } else {
            
            NSLog(@"Got all venues");
            self.venues = [venues mutableCopy];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.dasButton setTitle:@"Coffee Shops AR Mode" forState:UIControlStateNormal];
                self.dasButton.alpha = 1.0;
                self.dasButton.userInteractionEnabled = true;
                
                [self.mapButton setTitle:@"show on map" forState:UIControlStateNormal];
                self.mapButton.userInteractionEnabled = true;
            });
        }
    }];
}

- (void)getAddressFromLatLon:(CLLocation *)location {
    
    CLLocation *loca = [[CLLocation alloc] initWithLatitude:location.coordinate.latitude longitude:location.coordinate.longitude];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:loca
                   completionHandler:^(NSArray *placemarks, NSError *error) {
         if (error) {
             return;
         }
         CLPlacemark *placemark = [placemarks objectAtIndex:0];
         self.userCity = placemark.locality;
         [self getNearbyVenues];
     }];
}

- (IBAction)dasButtonTapped:(id)sender {
    
    [self.dasButton setTitle:@"Loading.." forState:UIControlStateNormal];
    CameraFourViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"GPS"];
    cvc.venues = self.venues;
    
    // Camera slow to start?? Let's delay it to make it prettier
    [self performSelector:@selector(pushView:) withObject:cvc afterDelay:2.0];

}

- (IBAction)showMap:(id)sender {
    
    MapViewController *mvc = [self.storyboard instantiateViewControllerWithIdentifier:@"Map"];
    mvc.venues = self.venues;
    mvc.currentLocation = self.currentLocation;
    [self presentViewController:mvc animated:NO completion:^{
        
    }];

}

-(void)pushView:(CameraFourViewController*)cvc {
    
    [self presentViewController:cvc animated:NO completion:^{
    }];
}


@end
