//
//  CameraViewController.m
//  arfun
//
//  Created by Evan Latner on 8/15/16.
//  Copyright © 2016 arfun. All rights reserved.
//

#import "CameraViewController.h"


typedef NS_ENUM(NSInteger, ArbiTrackState) {
    ARBI_PLACEMENT,
    ARBI_TRACKING,
};

@interface CameraViewController () {
    
    ArbiTrackState __arbiButtonState;
    float __lastScale;
    float __lastPanX;
}

@property (nonatomic) ARModelNode *modelNode;

@end

@implementation CameraViewController

- (void)setupContent
{
    [self setupModel];
    [self setupArbiTrack];
    [self setupLabel];
    
    // Add gesture recognisers.
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(arbiPinch:)];
    [self.cameraView addGestureRecognizer:pinchGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(arbiPan:)];
    [self.cameraView addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(arbiTap:)];
    [self.cameraView addGestureRecognizer:tapGesture];
    
}

- (void)setupModel
{
    // Import model from file.
    ARModelImporter *importer = [[ARModelImporter alloc] initWithBundled:@"samba_dancing.armodel"];
    ARModelNode *modelNode = [importer getNode];
    
    // Set up and add material to model.
    ARLightMaterial *material = [ARLightMaterial new];
    material.colour.texture = [[ARTexture alloc] initWithUIImage:[UIImage imageNamed:@"footballer_tex.png"]];
    material.diffuse.value = [ARVector3 vectorWithValuesX:0.2 y:0.2 z:0.2];
    material.ambient.value = [ARVector3 vectorWithValuesX:0.8 y:0.8 z:0.8];
    material.specular.value = [ARVector3 vectorWithValuesX:0.3 y:0.3 z:0.3];
    material.shininess = 20;
    material.reflection.reflectivity = 0.15;
    
    for (ARMeshNode *meshNode in modelNode.meshNodes) {
        meshNode.material = material;
    }
    
    self.modelNode = modelNode;
}

- (void)setupArbiTrack
{
    // Initialise gyro placement. Gyro placement positions content on a virtual floor plane where the device is aiming.
    ARGyroPlaceManager *gyroPlaceManager = [ARGyroPlaceManager getInstance];
    [gyroPlaceManager initialise];
    
    // Set up the target node on which the model is placed.
    ARNode *targetNode = [ARNode nodeWithName:@"targetNode"];
    [gyroPlaceManager.world addChild:targetNode];
    
    // Add a visual reticule to the target node for the user.
    ARImageNode *targetImageNode = [[ARImageNode alloc] initWithImage:[UIImage imageNamed:@"target.png"]];
    [targetNode addChild:targetImageNode];
    
    // Scale and rotate the image to the correct transformation.
    [targetImageNode scaleByUniform:0.1];
    [targetImageNode rotateByDegrees:90 axisX:1 y:0 z:0];
    
    // Initialise the arbiTracker, do not start until user placement.
    ARArbiTrackerManager *arbiTrack = [ARArbiTrackerManager getInstance];
    [arbiTrack initialise];
    
    // Set the arbiTracker target node to the node moved by the user.
    arbiTrack.targetNode = targetNode;
    
    [UIView animateWithDuration:1.0 animations:^{
        [arbiTrack.world addChild:_modelNode];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)setupLabel {
    
}

#pragma mark - Gesture Interactions.

- (void)arbiTap:(UITapGestureRecognizer *)gesture
{
    ARArbiTrackerManager *arbiTrack = [ARArbiTrackerManager getInstance];
    
    if (__arbiButtonState == ARBI_PLACEMENT) {
        
        [arbiTrack start];
        
        arbiTrack.targetNode.visible = NO;
        
        self.modelNode.scale = [ARVector3 vectorWithValuesX:1 y:1 z:1];
        
        __arbiButtonState = ARBI_TRACKING;
        
        //self.label.text = @"Pinch and pan to scale and rotate.";
        
        return;
    }
    
    else if (__arbiButtonState == ARBI_TRACKING) {
        
        [arbiTrack stop];
        
        arbiTrack.targetNode.visible = YES;
        
        __arbiButtonState = ARBI_PLACEMENT;
        
       //self.label.text = @"Tap the screen to place model on target.";
        
        return;
    }
}

- (void)arbiPinch:(UIPinchGestureRecognizer *)gesture
{
    float scaleFactor = gesture.scale;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        __lastScale = 1;
    }
    
    scaleFactor = 1 - (__lastScale - scaleFactor);
    
    __lastScale = gesture.scale;
    
    @synchronized ([ARRenderer getInstance]) {
        [self.modelNode scaleByUniform:scaleFactor];
    }
}

- (void)arbiPan:(UIPanGestureRecognizer *)gesture
{
    float x = [gesture translationInView:self.cameraView].x;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        __lastPanX = x;
    }
    
    float diff = x - __lastPanX;
    
    float deg = diff * 0.5;
    
    @synchronized ([ARRenderer getInstance]) {
        [self.modelNode rotateByDegrees:deg axisX:0 y:1 z:0];
    }
    
    __lastPanX = x;
}


@end
