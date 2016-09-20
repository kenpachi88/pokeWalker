//
//  SettingsViewController.h
//  PokeWalker
//
//  Created by kenny on 8/8/16.
//  Copyright © 2016 kenny. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "User.h"
@interface SettingsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *ageField;
@property (weak, nonatomic) IBOutlet UITextField *feetField;
@property (weak, nonatomic) IBOutlet UITextField *inchesField;
@property (weak, nonatomic) IBOutlet UITextField *weightField;



@end
