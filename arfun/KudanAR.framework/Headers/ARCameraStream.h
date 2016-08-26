#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

/**
 Protocol for camera events.
 */
@protocol ARCameraStreamEvent <NSObject>

/**
 The camera received a new frame.
 @param data Contains the greyscale camera image.
 @param timeStamp the time the frame was captured.
 */
- (void)didReceiveNewFrame:(NSData *)data timeStamp:(NSTimeInterval)timeStamp;

@end

@class ARTexture;

/**
 A manager class for handling the camera stream.
 */
@interface ARCameraStream : NSObject <AVCaptureVideoDataOutputSampleBufferDelegate>

/**
 Get the manager singleton.
 @return the singleton instance.
 */
+ (ARCameraStream *)getInstance;

/**
 Initialise the camera. This is usually handled automatically.
 */
- (void)initialise;

/**
 Deinitialise the camera. This is usually handled automatically.
 */
- (void)deinitialise;

/**
 Start the camera stream. This is usually handled automatically.
 */
- (void)start;

/**
 Stop the camera stream. This is usually handled automatically.
 */
- (void)stop;

/**
 The width of the camera image in pixels.
 */
@property (nonatomic) float width;

/**
 The height of the camera image in pixels.
 */
@property (nonatomic) float height;

@property (nonatomic) float padding;

@property (nonatomic) ARTexture *cameraTexture;

@property (nonatomic) NSArray *delegates;
- (void)addDelegate:(id<ARCameraStreamEvent>)delegate;
- (void)removeDelegate:(id<ARCameraStreamEvent>)delegate;

@property (nonatomic) ARTexture *cameraTextureY;
@property (nonatomic) ARTexture *cameraTextureUV;

/**
 Removes delegates for ARCameraStream Event
 */
- (void) removeDelegates;

@end
