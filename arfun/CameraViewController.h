//
//  CameraViewController.h
//  arfun
//
//  Created by Evan Latner on 8/15/16.
//  Copyright © 2016 arfun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KudanAR/KudanAR.h>

@protocol KudanExamplesProtocol <NSObject>

@required

+ (NSString *)getExampleName;

+ (NSInteger)getExampleImportance;

@end

@interface CameraViewController : ARCameraViewController <KudanExamplesProtocol>


@end
