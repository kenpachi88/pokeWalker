//
//  MainViewController.m
//  PokeWalker
//
//  Created by kenny on 8/8/16.
//  Copyright © 2016 kenny. All rights reserved.
//
#import "MainViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self turnOnGps];
    [self turnOnTelemetry];
    [self cameraLiveView];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *archivedObject = [defaults objectForKey:@"user"];
    User *obj = (User *)[NSKeyedUnarchiver unarchiveObjectWithData:archivedObject];
    NSLog(@"%@", obj.name);
}
-(void)cameraLiveView {

    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetHigh;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (input == NULL) {
        NSLog(@"nil camera");
    }

    [session addInput:input];
    
    AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    newCaptureVideoPreviewLayer.frame = self.view.bounds;
    
    [self.view.layer insertSublayer:newCaptureVideoPreviewLayer atIndex:0];
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    
    // add effect to an effect view

    
    // add the effect view to the image view
    UIVibrancyEffect *vibrancy = [UIVibrancyEffect effectForBlurEffect:blur];
    
    // add blur to an effect view
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:blur];
    effectView.frame = self.view.frame;
    
    // add vibrancy to yet another effect view
    UIVisualEffectView *vibrantView = [[UIVisualEffectView alloc]initWithEffect:vibrancy];
    vibrantView.frame = self.view.frame;
    
    // add both effect views to the image view
//    [self.view insertSubview:effectView atIndex:1];

//    [self.view insertSubview:vibrantView atIndex:2];
    [session startRunning];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"popoverMap"]) {
        ViewController *vc = [segue destinationViewController];
        UIPopoverPresentationController *mapPop = vc.popoverPresentationController;
        vc.modalPresentationStyle = UIModalPresentationPopover;
        vc.popoverPresentationController.delegate = self;
        vc.preferredContentSize = self.view.frame.size;
        mapPop.sourceRect = ((UIView *)sender).bounds;
        
    }
    if ([segue.identifier isEqualToString:@"popSettings"]) {
        SettingsViewController *svc = [segue destinationViewController];
        UIPopoverPresentationController *settingsPop = svc.popoverPresentationController;
        svc.modalPresentationStyle = UIModalPresentationPopover;
        svc.preferredContentSize = self.view.frame.size;
        settingsPop.delegate = self;
        settingsPop.sourceRect = ((UIView *)sender).bounds;
        

    }
    
}
- (void)turnOnTelemetry {
    if ([CMMotionActivityManager isActivityAvailable]) {
        NSLog(@"hihi");
        self.pedometer = [[CMPedometer alloc]init];
        self.motionActivityManager = [[CMMotionActivityManager alloc]init];
        [self.motionActivityManager startActivityUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMMotionActivity *activity)
         {
             [self updateMotion:activity];
         }];
        
        
        [self.pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable pedometerData, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                // this block is called for each live update
                [self updateLabels:pedometerData];
            });
        }];
    }
    
}
- (void)updateMotion:(CMMotionActivity *)activity {
    if (activity.walking == true)
    {
        self.motionStatus.text = @"Walking!";
        
    }
    else if
        (activity.running == true) {
            self.motionStatus.text = @"Running!";
            
        }
    else if
        (activity.automotive == true) {
            self.motionStatus.text = @"Vehicle!";
        }
    else if
        (activity.cycling == true) {
            self.motionStatus.text = @"cycling!";
        }
    
}

- (void)updateLabels:(CMPedometerData *)pedometerData {
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc]init];
    formatter.maximumFractionDigits = 2;
    
    // step counting
    [self.stepsProgressBar setValue:pedometerData.numberOfSteps.floatValue animateWithDuration:1];

    
    
    // calories burned
    [self.caloriesBurnedBar setValue:pedometerData.numberOfSteps.floatValue/20 animateWithDuration:1];
    
    self.meters.text = [NSString stringWithFormat:@"Meters: %@ ", [formatter stringFromNumber:pedometerData.distance]];
    // pace
    
    
    
}
- (void)turnOnGps {
    if (nil == self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
       self.locationManager.delegate = self;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest; // 100 m
        [self.locationManager startUpdatingLocation];
    }
    
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    self.location = [locations lastObject];
    self.speed.text = [NSString stringWithFormat:@"%f",self.location.speed];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
