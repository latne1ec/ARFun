//
//  MapViewController.h
//  arfun
//
//  Created by Evan Latner on 8/25/16.
//  Copyright © 2016 arfun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *map;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) NSArray *venues;
@property (strong, nonatomic) IBOutlet UIButton *goBackButton;

- (IBAction)goBackButtonTapped:(id)sender;

@end
