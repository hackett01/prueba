//
//  CaremobUserListViewController.h
//  Caremob
//
//  Created by Rick Strom on 10/23/15.
//  Copyright © 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CareMobConstants.h"
#import "CareMobHelper.h"
#import "NSDate+DateTools.h"

#import "CaremobUserList_NoUsersTableViewCell.h"
#import "CaremobUserList_GenericUserTableViewCell.h"

#import "UserProfileViewController.h"

#define kCaremobUserListTableModeTopMobbers 0
#define kCaremobUserListTableModeFirstMobbers 1
#define kCaremobUserListTableModeNearbyMobbers 2

@interface CaremobUserListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) int selectedMode;
@property (nonatomic, strong) PFObject *selectedUser;
@property (nonatomic, strong) PFObject *careMob;
@property (nonatomic, strong) PFObject *subMob;
@property (nonatomic, strong) PFGeoPoint *location;

@property (nonatomic, strong) NSArray *mobActions;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, assign) BOOL isRefreshing;

@end
