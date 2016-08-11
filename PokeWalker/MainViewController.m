//
//  MainViewController.m
//  PokeWalker
//
//  Created by kenny on 8/8/16.
//  Copyright © 2016 kenny. All rights reserved.
//

#import "MainViewController.h"
@import CoreMotion;
@import CoreLocation;
@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self turnOnGps];
    [self turnOnTelemetry];
    
    // Do any additional setup after loading the view.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"popoverMap"]) {
        ViewController *vc = [segue destinationViewController];
        
        vc.modalPresentationStyle = UIModalPresentationPopover;
        vc.popoverPresentationController.delegate = self;
        
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
    
    self.stepsCount.text = [NSString stringWithFormat:@"Steps: %@", [formatter stringFromNumber:pedometerData.numberOfSteps]];
    
    // distance
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
