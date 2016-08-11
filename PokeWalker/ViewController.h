//
//  ViewController.h
//  PokeWalker
//
//  Created by kenny on 7/17/16.
//  Copyright © 2016 kenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreMotion/CoreMotion.h>
#import <MapKit/MapKit.h>
#import "CustomInfoWindow.h"
#import "SettingsViewController.h"
@interface ViewController : UIViewController <CLLocationManagerDelegate, GMSMapViewDelegate,UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (nonatomic,retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *stepsCount;
@property (weak, nonatomic) IBOutlet UILabel *meters;
@property (strong, nonatomic) CMPedometer *pedometer;
@property (weak, nonatomic) IBOutlet UILabel *speed;
@property (strong, nonatomic) CMMotionActivityManager *motionActivityManager;
@property (weak, nonatomic) IBOutlet UIView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *motionStatus;

@property (strong, nonatomic) NSString *searchText;
@property (strong, nonatomic) NSURLSession *markerSession;
@property (strong, nonatomic) NSURLSession *urlSession;
@property (strong, nonatomic) NSURLSession *distanceSession;
@property (strong , nonatomic) NSDictionary *json;
@property (strong , nonatomic) NSDictionary *json2;
@property (strong, nonatomic)   NSDictionary *distanceJson;
- (IBAction)showLabelButton:(id)sender;
@property (strong, nonatomic) NSURL *url;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic) CLLocation *location;
@property (nonatomic) CLLocationCoordinate2D destination;
@property (strong, nonatomic) NSString *addressOftouched;
@property (nonatomic) NSString *calculatedDistance;
@property (nonatomic) ViewController *viewController;
-(void)calculateDistance: (CLLocationCoordinate2D )destination;


@end

