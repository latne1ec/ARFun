//
//  CameraThreeViewController.h
//  arfun
//
//  Created by Evan Latner on 8/17/16.
//  Copyright © 2016 arfun. All rights reserved.
//

#import <KudanAR/KudanAR.h>

@protocol KudanExamplesProtocol <NSObject>

@required

+ (NSString *)getExampleName;

+ (NSInteger)getExampleImportance;

@end

@interface CameraThreeViewController : ARCameraViewController

@end
