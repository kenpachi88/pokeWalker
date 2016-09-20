//
//  MainViewController.h
//  PokeWalker
//
//  Created by kenny on 8/8/16.
//  Copyright © 2016 kenny. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "caloriesBarView.h"
#import "MBCircularProgressBarView.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>
#import "User.h"
@interface MainViewController : UIViewController <CLLocationManagerDelegate,UIPopoverPresentationControllerDelegate>
@property (nonatomic,retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet caloriesBarView *caloriesBurnedBar;
@property (weak, nonatomic) IBOutlet UILabel *stepsCount;
@property (weak, nonatomic) IBOutlet UILabel *meters;
@property (strong, nonatomic) CMPedometer *pedometer;
@property (weak, nonatomic) IBOutlet UILabel *speed;
@property (strong, nonatomic) CMMotionActivityManager *motionActivityManager;
@property (weak, nonatomic) IBOutlet UILabel *motionStatus;
@property (nonatomic) CLLocation *location;
@property (weak, nonatomic) IBOutlet MBCircularProgressBarView *stepsProgressBar;

@end
