//
//  InitialViewController.h
//  arfun
//
//  Created by Evan Latner on 8/25/16.
//  Copyright © 2016 arfun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KudanAR/KudanAR.h>
#import <CoreLocation/CoreLocation.h>
#import "YPAPISample.h"
#import "CameraFourViewController.h"

@interface InitialViewController : UIViewController <CLLocationManagerDelegate> {
 
    CLLocationManager *locationManager;
    
}

@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) CLLocation *venueLocation;
@property (nonatomic, strong) NSString *userCity;
@property (nonatomic, strong) NSArray *venues;
@property (weak, nonatomic) IBOutlet UIButton *dasButton;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
- (IBAction)dasButtonTapped:(id)sender;
- (IBAction)showMap:(id)sender;

@end
