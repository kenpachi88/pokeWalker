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
    
    GMSMapView *mapView_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self turnOnGps];
    self.searchBar.delegate = self;
    self.searchBar.layer.cornerRadius = 10.8f;
    self.searchBar.layer.borderColor = [UIColor blueColor].CGColor;
    [self updateRadius];

}
-(void)viewDidAppear:(BOOL)animated {
    [self addMap];
    
}
- (void) addMap {
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithTarget:self.locationManager.location.coordinate zoom:15];
    
    mapView_ = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.settings.myLocationButton = true;
    mapView_.delegate = self;
    [self.mapView addSubview:mapView_];
}
- (void)turnOnGps {
    if (nil == self.locationManager) {
        self.self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest; // 100 m
        [self.locationManager startUpdatingLocation];
    }
    
}
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    self.location = [locations lastObject];
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
    
    
    
    [UIView commitAnimations];
}
-(void) searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.searchBar becomeFirstResponder];
}

-(void) searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"bar pressed");
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





-(void)calculateDistance: (CLLocationCoordinate2D )destination {
    NSString *searchURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=%f,%f&destinations=%f,%f&mode=walking&key=AIzaSyAoFqie1qfMp14qq9tp9Mr-psEFI5H0o58",
                           self.location.coordinate.latitude,
                           self.location.coordinate.longitude,
                           destination.latitude,
                           destination.longitude];
    
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:searchURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^{
        self.distanceJson = [NSJSONSerialization JSONObjectWithData: data
                                                            options:0
                                                              error:nil];
        NSArray *distance = [self.distanceJson objectForKey:@"rows"];
        NSLog(@"distance: %@",distance);
        
        for (NSDictionary *distanceData in distance) {
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:[distanceData valueForKeyPath:@"elements.distance.text"]];
            self.calculatedDistance = array.firstObject;
        }
        });
    }] resume];
    
    
    
    
    
}
-(void)reverseGeocodeCoordinate: (CLLocationCoordinate2D) coordinate completionHandler:(nonnull GMSReverseGeocodeCallback)handler {
    
}
-(void)calculateDistanceForPokestop: (CLLocationCoordinate2D )destination {
    NSString *searchURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=%f,%f&destinations=%f,%f&mode=walking&key=AIzaSyAoFqie1qfMp14qq9tp9Mr-psEFI5H0o58",
                           self.location.coordinate.latitude,
                           self.location.coordinate.longitude,
                           destination.latitude,
                           destination.longitude];
    NSLog(@"url for calculate distance %@",searchURL);
    NSURLSession *session = [NSURLSession sharedSession];
    [[session dataTaskWithURL:[NSURL URLWithString:searchURL] completionHandler:^(NSData *data, NSURLResponse *response, NSError *e) {
        dispatch_async(dispatch_get_main_queue(), ^ {
        self.distanceJson = [NSJSONSerialization JSONObjectWithData: data
                                                            options:0
                                                              error:nil];
        NSArray *distance = [self.distanceJson objectForKey:@"rows"];
        NSLog(@"distance: %@",distance);
        
        for (NSDictionary *distanceData in distance) {
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:[distanceData valueForKeyPath:@"elements.distance.text"]];
            self.calculatedDistance = array.firstObject;
            
        }
        });
    }] resume];
    
    
    
    
    
}

-(UIView *) mapView:(GMSMapView *)mapView markerInfoWindow:(nonnull GMSMarker *)marker
{
    
    

    CustomInfoWindow *infoWindow = [[[NSBundle mainBundle]loadNibNamed:@"InfoWindow" owner:self options:nil]objectAtIndex:0];
    infoWindow.coordinates = [[marker.userData objectForKey:@"coordinate"] MKCoordinateValue];
    infoWindow.title.font = [UIFont fontWithName:@"PokemonGB" size:8 ];
    infoWindow.title.text = [marker.userData objectForKey:@"name"];
    infoWindow.address.text = [marker.userData objectForKey:@"address"];
    infoWindow.address.font = [UIFont fontWithName:@"PokemonGB" size:8 ];
    infoWindow.imageView.image = [UIImage imageNamed:@"box.png"];
    infoWindow.distance.text = self.calculatedDistance;
    infoWindow.distance.font = [UIFont fontWithName:@"PokemonGB" size:8 ];
    
    
    return infoWindow;
    
}
-(void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
    [self calculateDistanceForPokestop:marker.position];
    });

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
        NSLog(@"distance json:%@",distance);
        
        for (NSDictionary *distanceData in distance) {
            
            NSMutableArray *array = [NSMutableArray arrayWithArray:[distanceData valueForKeyPath:@"elements.distance.text"]];
            self.calculatedDistance = array.firstObject;
            
        }
    }] resume];
    
    
    
    
}
- (void)mapView:(GMSMapView *)mapView
didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [self calculateDistance:coordinate];
    [[GMSGeocoder geocoder]reverseGeocodeCoordinate:coordinate completionHandler:^(GMSReverseGeocodeResponse *response, NSError *error) {
        if (error) {
            NSLog(@"%@",[error description]);
        }
        dispatch_async(dispatch_get_main_queue(), ^ {
        NSLog(@"%@",response.firstResult.thoroughfare);
        NSString *address = [NSString stringWithFormat:@"%@ %@,%@ %@",response.firstResult.thoroughfare,response.firstResult.subLocality,response.firstResult.administrativeArea,response.firstResult.postalCode];
        GMSMarker *tapMarker = [GMSMarker new];
        tapMarker.position = CLLocationCoordinate2DMake(response.firstResult.coordinate.latitude, response.firstResult.coordinate.longitude);
        NSValue *coordinate = [NSValue valueWithMKCoordinate:response.firstResult.coordinate];
        tapMarker.userData = [[NSDictionary alloc] initWithObjectsAndKeys:coordinate,@"coordinate",
                    address,@"address",
                              @"",@"name",
                           nil];
        
        tapMarker.map = mapView_;
        });
    }];

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
    mapView.selectedMarker = marker;
    return TRUE;
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


-(void)getPokestops {
    [mapView_ setMinZoom:15 maxZoom:19];

    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"moreMarkers" ofType:@"csv"];
    NSString* content = [NSString stringWithContentsOfFile:filepath
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    NSArray *allLines = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    self.markers = [[NSMutableArray alloc]init];
    
    for (NSString *coordinates in allLines) {
        
        NSArray* rows = [coordinates componentsSeparatedByString:@","];

        CLLocationCoordinate2D markers = CLLocationCoordinate2DMake([[rows firstObject]floatValue], [[rows lastObject]floatValue]);
        CLLocation *markerLocations = [[CLLocation alloc] initWithLatitude:markers.latitude longitude:markers.longitude];
        [self.markers addObject:markerLocations];
        
        
    }
    NSLog(@"marker:%@",self.markers);
    
    
}

-(void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {
    [mapView_ clear];
    GMSVisibleRegion region = mapView_.projection.visibleRegion;
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithRegion:region];
    for (CLLocation *location in self.markers) {
        if ([bounds containsCoordinate:location.coordinate]) {
            GMSMarker *nyMarker = [GMSMarker new];
            nyMarker.position = location.coordinate;
            [nyMarker setTappable:NO];
            nyMarker.map = mapView_;
            
        }
    }
    
}

- (IBAction)showLabelButton:(id)sender {
    [self showButtons];
    [self getPokestops];
    [self.searchBar removeFromSuperview];
}
-(void)updateRadius {
    NSDate* eventDate = self.location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        GMSCircle *shortDistance = [[GMSCircle alloc]init];
        shortDistance.position = self.location.coordinate;
        shortDistance.radius = 2000;
        shortDistance.strokeColor = [UIColor redColor];
        shortDistance.strokeWidth = 3;
        shortDistance.map = mapView_;
        GMSCircle *longDistance = [[GMSCircle alloc]init];
        longDistance.position = self.location.coordinate;
        longDistance.radius = 10000;
        longDistance.strokeWidth = 3;
        longDistance.strokeColor = [UIColor orangeColor];
        longDistance.map = mapView_;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//-(void)performSearchwithCoordinate:(CLLocationCoordinate2D)coordinate
//{
//
//
//    NSString *searchURL = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&key=AIzaSyDynVv-Ko_Xmg48bRdk4HbfUiDjq3g9UT4"
//                           ,coordinate.latitude,coordinate.longitude];
//    NSLog(@"coordinate search : %@",searchURL);
//    NSURLSession *session = [NSURLSession sharedSession];
//    [[session dataTaskWithURL:[NSURL URLWithString:searchURL]
//            completionHandler:^(NSData *data, NSURLResponse *response, NSError *e) {
//                self.json = [NSJSONSerialization JSONObjectWithData: data
//                                                            options:0
//                                                              error:nil];
//
//                NSArray *placeData = [[self.json valueForKey:@"results"] valueForKey:@"formatted_address"];
//                self.addressOftouched = placeData.firstObject;
//                GMSMarker *marker = [GMSMarker new];
//                marker.userData = [[NSDictionary alloc] initWithObjectsAndKeys:self.addressOftouched,@"address",
//                                   nil];
//                marker.position = coordinate;
//                marker.appearAnimation = kGMSMarkerAnimationPop;
//                marker.map=mapView_;
//            }] resume];
//
//
//}
@end
