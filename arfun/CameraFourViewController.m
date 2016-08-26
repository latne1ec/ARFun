//
//  CameraFourViewController.m
//  arfun
//
//  Created by Evan Latner on 8/23/16.
//  Copyright © 2016 arfun. All rights reserved.
//

#import "CameraFourViewController.h"
#import "MapViewController.h"

@implementation CameraFourViewController

- (void)setupContent {
    
    ARGPSManager *GPSManager = [ARGPSManager getInstance];
    [GPSManager initialise];
    [GPSManager start];
    [GPSManager getCurrentLocation];
    
//    Hardcoded Millbrae Locations
//    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:37.60014457 longitude:-122.39557998];
//    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:37.60156489 longitude:-122.39259621];
    
    CLLocation *dasLocation;
    
    for (int i = 0; i < self.venues.count; i++) {
        NSMutableDictionary *object = [[self.venues objectAtIndex:i] mutableCopy];
        CLLocationDegrees lat = [[[[object objectForKey:@"location"] valueForKey:@"coordinate"] valueForKey:@"latitude"] doubleValue];
        CLLocationDegrees lon = [[[[object objectForKey:@"location"] valueForKey:@"coordinate"] valueForKey:@"longitude"] doubleValue];
        CLLocation *venueLocation = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        dasLocation = venueLocation;
    
        ARGPSNode *GPSNode = [[ARGPSNode alloc] initWithLocation:dasLocation];
        
        [GPSManager.world addChild:GPSNode];
        [GPSNode setBearing:180];
        
        ARModelImporter *modelImporter = [[ARModelImporter alloc] initWithBundled:@"ben.armodel"];
        ARModelNode *modelNode = [modelImporter getNode];
        [GPSNode addChild:modelNode];
        
        ARModelImporter *modelImporter2 = [[ARModelImporter alloc] initWithBundled:@"ben.armodel"];
        ARModelNode *modelNode2 = [modelImporter2 getNode];
        
        ARTexture *modelTexture = [[ARTexture alloc] initWithUIImage:[UIImage imageNamed:@"Big_Ben_diffuse.png"]];
        
        ARLightMaterial *modelMaterial = [[ARLightMaterial alloc] init];
        modelMaterial.colour.texture = modelTexture;
        modelMaterial.ambient.value = [ARVector3 vectorWithValuesX:0.5 y:0.5 z:0.5];
        modelMaterial.diffuse.value = [ARVector3 vectorWithValuesX:0.5 y:0.5 z:0.5];
        
        for (ARMeshNode *meshNode in modelNode.meshNodes) {
            meshNode.material = modelMaterial;
        }

        [modelNode scaleByUniform:(96.0 / 11008.0)];
        [modelNode2 scaleByUniform:(96.0 / 11008.0)];
    }
    
}

@end
