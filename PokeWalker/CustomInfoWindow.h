//
//  CustomInfoWindow.h
//  PokeWalker
//
//  Created by kenny on 8/3/16.
//  Copyright © 2016 kenny. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"

@interface CustomInfoWindow : UIView
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *caloriesEstimate;
@property (nonatomic) CLLocationCoordinate2D coordinates;

@end
