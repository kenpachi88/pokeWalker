//
//  SettingsViewController.m
//  PokeWalker
//
//  Created by kenny on 8/8/16.
//  Copyright © 2016 kenny. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    User *newUser = [User new];
    newUser.name = self.nameField.text;
    newUser.weight = [NSNumber numberWithInteger:self.weightField.text.integerValue];
    float feet = self.feetField.text.integerValue;
    float inches = self.inchesField.text.integerValue;
    newUser.height = [NSNumber numberWithFloat:((feet*12)+inches)*2.54];
    NSData *archivedObject = [  NSKeyedArchiver archivedDataWithRootObject:newUser];
    newUser.age = [NSNumber numberWithInteger:self.ageField.text.integerValue];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:archivedObject forKey:@"user"];
    [defaults synchronize];
    
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
