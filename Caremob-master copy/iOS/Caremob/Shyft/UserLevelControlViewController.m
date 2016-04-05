//
//  UserLevelControlViewController.m
//  Caremob
//
//  Created by Rick Strom on 6/1/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import "UserLevelControlViewController.h"

@interface UserLevelControlViewController ()

@end

@implementation UserLevelControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    // Load defaults (cached values)
    self.points =               (int)[defaults integerForKey:kNSUserDefaultsUserPoints];
    self.level =                (int)[defaults integerForKey:kNSUserDefaultsUserLevel];
    self.pointsToCurrentLevel = (int)[defaults integerForKey:kNSUserDefaultsUserPointsToCurrentLevel];
    self.pointsToNextLevel =    (int)[defaults integerForKey:kNSUserDefaultsUserPointsToNextLevel];
    
    if ([PFUser currentUser] != nil) {
        PFFile *imageFile = (PFFile*)[[PFUser currentUser] objectForKey:kUserFieldProfileImageKey];
        self.userImageView.file = imageFile;
        [self.userImageView loadInBackground];
    }
}

-(void)userNeedsRefresh {
    /*
    [[PFUser currentUser] fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (error) {
            
        } else {
            
            [self updateCount];
        }
        
        NSLog(@"Fetched current user!");
    }];
    */
    
    // REMOVED: 10.27.2015
    /*
    // Pull points/level values from cloud function
    NSDictionary *params = [[NSDictionary alloc] init];
    [PFCloud callFunctionInBackground:kCloudFunctionGetUserPointsAndLevelKey withParameters:params block:^(id object, NSError *error) {
        if (error) {
            NSLog(@"Errr %@", error.localizedDescription);
        } else {
            NSDictionary *result        = (NSDictionary*)object;
            self.points                 = [(NSNumber*)result[kCloudFunctionGetUserPointsAndLevelResultPoints] intValue];
            self.level                  = [(NSNumber*)result[kCloudFunctionGetUserPointsAndLevelResultLevel] intValue];
            self.pointsToCurrentLevel   = [(NSNumber*)result[kCloudFunctionGetUserPointsAndLevelResultPointsToCurrentLevel] intValue];
            self.pointsToNextLevel      = [(NSNumber*)result[kCloudFunctionGetUserPointsAndLevelResultPointsToNextLevel] intValue];
            
            NSLog(@"Fetched user points and got: %d, %d, %d, %d", self.points, self.level, self.pointsToCurrentLevel, self.pointsToNextLevel);
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            [defaults setInteger:self.points forKey:kNSUserDefaultsUserPoints];
            [defaults setInteger:self.level forKey:kNSUserDefaultsUserLevel];
            [defaults setInteger:self.pointsToCurrentLevel forKey:kNSUserDefaultsUserPointsToCurrentLevel];
            [defaults setInteger:self.pointsToNextLevel forKey:kNSUserDefaultsUserPointsToNextLevel];
            
            [defaults synchronize];
        
            [self updateCount];
        }
    }];
    */
    
    // Refresh the image if we need to
    if ([PFUser currentUser] != nil) {
        PFFile *imageFile = (PFFile*)[[PFUser currentUser] objectForKey:kUserFieldProfileImageKey];
        self.userImageView.file = imageFile;
        [self.userImageView loadInBackground];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initialize {    
    self.FGProgressView.linePercentage = 0.2;
    self.FGProgressView.animatesBegining = NO;
    self.FGProgressView.animationEnabled = YES;
    self.FGProgressView.borderColorForFilledArc = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    self.FGProgressView.borderColorForUnfilledArc = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    self.FGProgressView.unfillColor = [UIColor colorWithRed:9.0/255.0 green:64.0/255.0 blue:89.0/255.0 alpha:1.0];
    self.FGProgressView.fillColor = [UIColor colorWithRed:65.0/255.0 green:209.0/255.0 blue:240.0/255.0 alpha:1.0];
    self.FGProgressView.showTextLabel = NO;
    
    self.numberLabel.text = @"0";
    
    [self updateCount];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)setFrameRelativeTo:(UIView*)view {
    //NSLog(@"View's frame is %f,%f %fx%f", view.frame.origin.x,view.frame.origin.y, view.frame.size.width,view.frame.size.height);
    //NSLog(@"My frame is %f,%f %fx%f", self.view.frame.origin.x,self.view.frame.origin.y, self.view.frame.size.width,self.view.frame.size.height);
    
    self.view.frame = CGRectMake(view.frame.size.width - 44.0, 0.0, 44.0, view.frame.size.height);
    
    //[self performSelector:@selector(updateCount) withObject:nil afterDelay:0.5];
}

-(void)updateCount {
    //self.numberLabel.text = [NSString stringWithFormat:@"%d", self.count];
    /*
    if ([PFUser currentUser] != nil) {
        PFObject *userObject = (PFObject*)[PFUser currentUser];
        NSNumber *userPoints = [userObject objectForKey:kUserFieldPointsKey];
        self.numberLabel.text = [NSString stringWithFormat:@"%d", [userPoints intValue]];
        self.FGProgressView.percentage = [userPoints doubleValue] / 20.0;
        
        NSLog(@"User points is %d", [userPoints intValue]);
    } else {
        NSLog(@"User is nil!");
        self.numberLabel.text = @"0";
        self.FGProgressView.percentage = 0;
    }
     */
    
    self.numberLabel.text = [NSString stringWithFormat:@"%d", self.level];
    self.FGProgressView.percentage = (float)(self.points - self.pointsToCurrentLevel) / (float)(self.pointsToNextLevel - self.pointsToCurrentLevel);
}
@end
