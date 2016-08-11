//
//  ViewController.m
//  PokeWalker
//
//  Created by kenny on 7/17/16.
//  Copyright © 2016 kenny. All rights reserved.
//AIzaSyAoFqie1qfMp14qq9tp9Mr-psEFI5H0o58
#import "ViewController.h"
#import "CustomInfoWindow.h"
@import CoreMotion;
@import CoreLocation;
@interface ViewController ()
@end

@implementation ViewController {
    
    CLLocationManager *locationManager;
    GMSMapView *mapView_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self turnOnGps];
    self.searchBar.delegate = self;
    self.searchBar.layer.cornerRadius = 10.8f;
    self.searchBar.layer.borderColor = [UIColor blueColor].CGColor;
    
}
-(void)viewDidAppear:(BOOL)animated {
    [self addMap];
    
}
- (void) addMap {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:locationManager.location.coordinate zoom:15];
    mapView_ = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.settings.myLocationButton = true;
    mapView_.delegate = self;
    [self.mapView addSubview:mapView_];
}
- (void)turnOnGps {
    if (nil == locationManager) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest; // 100 m
        [locationManager startUpdatingLocation];
    }
    
}


- (void) showButtons {
    [UIView beginAnimations:@"buttonShowUp" context:nil];
    [UIView setAnimationDuration:0.5]; // Set it as you want, it's the length of your animation
    
    self.label.alpha = 1.0f;
    self.label.text = @"hello";
    
    // If you want to move them from right to left, here is how we gonna do it :
    float move = 100.0f; // Set it the way you want it
    self.label.frame = CGRectMake(self.label.frame.origin.x - move,
                                  self.label.frame.origin.y,
                                  self.label.frame.size.width,
                                  self.label.frame.size.height);
    
    
    // If you want to set them in the exact center of your view, you can replace
    // self.label.frame.origin.x - move
    // by the following
    // (self.view.center - self.label.frame.size.width/2)
    // This way, your button will be centered horizontally
    
    [UIView commitAnimations];
}
-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar becomeFirstResponder];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.searchText = [self.searchBar.text stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    [self performSearch];
    
    [self.searchBar resignFirstResponder];
}
-(void)performSearch
{
    [mapView_ clear];
    
    NSString *searchURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=1000&keyword=%@&key=AIzaSyB6zOuMSRbmPrHrYvI59NvHpyH5VRe6A_E",mapView_.camera.target.latitude,mapView_.camera.target.longitude,self.searchText];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:searchURL]
            completionHandler:^(NSData *data,
                                NSURLResponse *response,
                                NSError *error) {
                // handle response
                self.json = [NSJSONSerialization JSONObjectWithData: data
                                                            options:0
                                                              error:nil];
                NSArray *places = [self.json objectForKey:@"results"];
                [self createMarkerWithJson:places];
            }] resume];
    
}




-(void)performSearchwithCoordinate:(CLLocationCoordinate2D)coordinate
{
    
    
    NSString *searchURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&key=AIzaSyDynVv-Ko_Xmg48bRdk4HbfUiDjq3g9UT4"
                           ,coordinate.latitude,coordinate.longitude];
    NSLog(@"%@",searchURL);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:searchURL]
            completionHandler:^(NSData *data, NSURLResponse *response, NSError *e) {
                self.json = [NSJSONSerialization JSONObjectWithData: data
                                                            options:0
                                                              error:nil];
                
                NSArray *placeData = [[self.json valueForKey:@"results"] valueForKey:@"formatted_address"];
                self.addressOftouched = placeData.firstObject;
                GMSMarker *marker = [GMSMarker new];
                marker.userData = [[NSDictionary alloc] initWithObjectsAndKeys:self.addressOftouched,@"address",
                                   nil];
                marker.position = coordinate;
                marker.appearAnimation = kGMSMarkerAnimationPop;
                marker.map=mapView_;
            }] resume];
    
    
}
-(void)calculateDistance: (CLLocationCoordinate2D )destination {
    NSString *searchURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=%f,%f&destinations=%f,%f&mode=walking&key=AIzaSyAoFqie1qfMp14qq9tp9Mr-psEFI5H0o58",
                           self.location.coordinate.latitude,
                           self.location.coordinate.longitude,
                           destination.latitude,
                           destination.longitude];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:searchURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *e) {
        self.distanceJson = [NSJSONSerialization JSONObjectWithData: data
                                                            options:0
                                                              error:nil];
        NSArray *distance = [self.distanceJson objectForKey:@"rows"];
        NSLog(@"%@",distance);
        
        for (NSDictionary *distanceData in distance) {
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:[distanceData valueForKeyPath:@"elements.distance.text"]];
            self.calculatedDistance = array.firstObject;
            
            [self performSearchwithCoordinate:destination];
            
        }
    }] resume];
    
    
    
    
    
}

-(void)createInfoWindow {
    
}
-(UIView *) mapView:(GMSMapView *)mapView markerInfoWindow:(nonnull GMSMarker *)marker
{
    
    
    
    CustomInfoWindow *infoWindow = [[[NSBundle mainBundle]loadNibNamed:@"InfoWindow" owner:self options:nil]objectAtIndex:0];
    infoWindow.coordinates = [[marker.userData objectForKey:@"coordinate"] MKCoordinateValue];
    infoWindow.title.text = [marker.userData objectForKey:@"name"];
    infoWindow.address.text = [marker.userData objectForKey:@"address"];
    infoWindow.imageView.image = [UIImage imageNamed:@"box.png"];
    infoWindow.distance.text = self.calculatedDistance;
    
    infoWindow.layer.cornerRadius = 10.8f;
    
    
    
    
    
    return infoWindow;
    
}
-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    
}
-(void)calculateDistanceFromSearch: (CLLocationCoordinate2D) destination {
    NSString *searchURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=%f,%f&destinations=%f,%f&mode=walking&key=AIzaSyAoFqie1qfMp14qq9tp9Mr-psEFI5H0o58",
                           self.location.coordinate.latitude,
                           self.location.coordinate.longitude,
                           destination.latitude,
                           destination.longitude];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:searchURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *e) {
        self.distanceJson = [NSJSONSerialization JSONObjectWithData: data
                                                            options:0
                                                              error:nil];
        NSArray *distance = [self.distanceJson objectForKey:@"rows"];
        NSLog(@"%@",distance);
        
        for (NSDictionary *distanceData in distance) {
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:[distanceData valueForKeyPath:@"elements.distance.text"]];
            self.calculatedDistance = array.firstObject;
            
        }
    }] resume];
    
    
    
    
}
- (void)mapView:(GMSMapView *)mapView
didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate {
    dispatch_async(dispatch_get_main_queue(), ^{
        [mapView_ clear];
        [self calculateDistance:coordinate];
        
    });
    
    
}

-(void)createMarkerWithJson:(NSArray *)json
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        for (NSDictionary *markerData in json) {
            
            GMSMarker *marker = [GMSMarker new];
            marker.position = CLLocationCoordinate2DMake([[markerData valueForKeyPath:@"geometry.location.lat"]doubleValue], [[markerData valueForKeyPath:@"geometry.location.lng"]doubleValue]);
            NSValue *coordinate = [NSValue valueWithMKCoordinate:marker.position];
            marker.userData = [[NSDictionary alloc] initWithObjectsAndKeys:coordinate,@"coordinate",
                               markerData[@"name"],@"name",
                               markerData[@"vicinity"],@"address",
                               nil];
            marker.groundAnchor = CGPointMake(0.5, 0.5);
            marker.appearAnimation = kGMSMarkerAnimationPop;
            marker.map = mapView_;
            
            
        }
    });
    
}
- (BOOL)mapView:(GMSMapView *)mapView
   didTapMarker:(nonnull GMSMarker *)marker {
    
    return NO;
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    self.location = [locations lastObject];
    //    NSDate* eventDate = self.location.timestamp;
    //    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    //    if (abs(howRecent) < 15.0) {
    //        GMSCircle *shortDistance = [[GMSCircle alloc]init];
    //        shortDistance.position = self.location.coordinate;
    //        shortDistance.radius = 2000;
    //        shortDistance.strokeColor = [UIColor redColor];
    //        shortDistance.strokeWidth = 3;
    //        shortDistance.map = mapView_;
    //        GMSCircle *mediumDistance = [[GMSCircle alloc]init];
    //        mediumDistance.position = self.location.coordinate;
    //        mediumDistance.radius = 5000;
    //        mediumDistance.strokeColor = [UIColor blueColor];
    //        mediumDistance.strokeWidth = 3;
    //        mediumDistance.map = mapView_;
    //        GMSCircle *longDistance = [[GMSCircle alloc]init];
    //        longDistance.position = self.location.coordinate;
    //        longDistance.radius = 10000;
    //        longDistance.strokeWidth = 3;
    //        longDistance.strokeColor = [UIColor orangeColor];
    //        longDistance.map = mapView_;
    //        self.speed.text = [NSString stringWithFormat:@"%f",self.location.speed];
}
-(void)drawCircles {
    
    GMSCircle *shortDistance = [[GMSCircle alloc]init];
    shortDistance.position = self.location.coordinate;
    shortDistance.radius = 2000;
    shortDistance.strokeColor = [UIColor redColor];
    shortDistance.strokeWidth = 3;
    shortDistance.map = mapView_;
    GMSCircle *mediumDistance = [[GMSCircle alloc]init];
    mediumDistance.position = self.location.coordinate;
    mediumDistance.radius = 5000;
    mediumDistance.strokeColor = [UIColor blueColor];
    mediumDistance.strokeWidth = 3;
    mediumDistance.map = mapView_;
    GMSCircle *longDistance = [[GMSCircle alloc]init];
    longDistance.position = self.location.coordinate;
    longDistance.radius = 10000;
    longDistance.strokeWidth = 3;
    longDistance.strokeColor = [UIColor orangeColor];
    longDistance.map = mapView_;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getPokestops {
    NSMutableArray *colA = [[NSMutableArray alloc]init];
    NSMutableArray *colB = [[NSMutableArray alloc]init];
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"PokeStop" ofType:@"csv"];
    NSString* content = [NSString stringWithContentsOfFile:filepath
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    NSString *newString = [content stringByReplacingOccurrencesOfString:@"\"" withString:@""];

    NSArray* rows = [newString componentsSeparatedByString:@"\n"];
    for (NSString *coordinates in rows) {
        NSArray *latlon = [coordinates componentsSeparatedByString:@","];
        [colA addObject:latlon.firstObject];
        [colB addObject:latlon.lastObject];
//        NSLog(@"%@",colA);

    }


    
}
- (IBAction)showLabelButton:(id)sender {
    [self showButtons];
    [self getPokestops];

    self.calculatedDistance = 0;
}

@end
