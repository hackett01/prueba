//
//  ActivityFeedViewController.h
//  Shyft
//
//  Created by Rick Strom on 11/19/14.
//  Copyright (c) 2014 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CareMobConstants.h"
#import "CareMobHelper.h"
#import "SoundManager.h"

#import "UserLevelControlViewController.h"

#import "ActivityFeed_CareMobLeveledUpTableViewCell.h"
#import "ActivityFeed_SubMobLeveledUpTableViewCell.h"
#import "ActivityFeed_UserLeveledUpTableViewCell.h"
#import "ActivityFeed_UnknownTableViewCell.h"
#import "ActivityFeed_UserJoinedTableViewCell.h"
#import "ActivityFeed_UserFollowedTableViewCell.h"
#import "ActivityFeed_UserEnteredSubMobTableViewCell.h"
#import "ActivityFeed_UserFollowedIntoSubMobTableViewCell.h"
#import "ActivityFeed_UserCreatedCareMobTableViewCell.h"

#import "CaremobDisplayViewController.h"
#import "UserProfileViewController.h"

@interface ActivityFeedViewController : UIViewController <UITableViewDataSource, UITabBarDelegate>

@property (nonatomic, strong) UserLevelControlViewController *userLevelViewController;

@property (nonatomic, strong) NSArray *activities;
@property (nonatomic, weak) PFObject *selectedCareMob;
@property (nonatomic, weak) PFObject *selectedSubMob;
@property (nonatomic, weak) NSString *selectedCategoryContext;
@property (nonatomic, weak) PFUser *selectedUser;
@property (nonatomic, weak) PFUser *followingUser;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, assign) BOOL isRefreshing;
-(void)loadActivity:(BOOL)useCache;
@end
