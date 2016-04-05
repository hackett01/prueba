//
//  RootViewController.h
//  Shyft
//
//  Created by Rick Strom on 11/15/14.
//  Copyright (c) 2014 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import "CareMobConstants.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "SoundManager.h"
#import "CareMobHelper.h"

#import "UserProfileViewController.h"

@interface RootViewController : UITabBarController

-(void)doLogin;
-(void)doLogout;
-(void)switchToActivityTab;
@end
