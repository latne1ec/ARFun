//
//  CameraFourViewController.h
//  arfun
//
//  Created by Evan Latner on 8/23/16.
//  Copyright © 2016 arfun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KudanAR/KudanAR.h>


@interface CameraFourViewController : ARCameraViewController

@property (strong, nonatomic) CLLocation *objectCoordinate;
@property (nonatomic, strong) NSArray *venues;

@end
