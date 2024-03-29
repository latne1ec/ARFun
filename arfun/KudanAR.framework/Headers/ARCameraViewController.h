#import <Foundation/Foundation.h>
#import <KudanAR/KudanAR.h>
#import <KudanAR/ARCameraView.h>

/**
 View controller encapsulating the AR.
 */
@interface ARCameraViewController : UIViewController

/**
 The ARView associated with this view controller.
 */
@property (nonatomic) ARCameraView *cameraView;

- (void)didReceiveNewFrame:(NSData *)data timeStamp:(NSTimeInterval)timeStamp;
- (void)setupContent;

@end
