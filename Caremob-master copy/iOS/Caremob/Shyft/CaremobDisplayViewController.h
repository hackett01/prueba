//
//  CaremobDisplayViewController.h
//  Caremob
//
//  Created by Rick Strom on 6/2/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <CoreLocation/CoreLocation.h>
#import "CareMobConstants.h"
#import "CareMobHelper.h"
#import "MCPercentageDoughnutView.h"
#import "CRToast.h"
#import "HeatmapViewController.h"
#import "SoundManager.h"

#import "SocialShareViewController.h"
#import "CaremobUserListViewController.h"

@interface CaremobDisplayViewController : UIViewController <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, strong) PFObject *careMob;
@property (nonatomic, strong) NSString *categoryContext;
@property (nonatomic, strong) PFUser *followingUser;
@property (nonatomic, assign) int displayMode;
@property (nonatomic, strong) PFObject *selectedSubMob;
@property (nonatomic, strong) PFObject *activeMobAction;
@property (nonatomic, assign) int selectedCaremobUserListMode;
@property (nonatomic, strong) NSDate *pressStartTime;
@property (nonatomic, strong) NSArray *subMobs;
@property (nonatomic, strong) NSMutableArray *mobActions;
@property (nonatomic, strong) NSMutableDictionary *categoryButtonInitialFrames;
@property (nonatomic, strong) NSMutableDictionary *categoryButtonInitialCenters;

@property (nonatomic, assign) double newTimeEarned;
@property (nonatomic, assign) int newPointsEarned;

@property (nonatomic, assign) BOOL didPreInitialize;
@property (nonatomic, assign) BOOL didPostInitialize;

@end
