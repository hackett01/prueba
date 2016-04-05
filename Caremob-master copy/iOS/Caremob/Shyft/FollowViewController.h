//
//  FollowViewController.h
//  Shyft
//
//  Created by Rick Strom on 2/2/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Follow_NoUsersTableViewCell.h"
#import "Follow_UserTableViewCell.h"
#import "Follow_RankedUserTableViewCell.h"
#import "Follow_GenericUserTableViewCell.h"

#import "UserProfileViewController.h"
#import "CareMobConstants.h"
#import "CareMobHelper.h"
#import <Parse/Parse.h>


#define kFollowTableModeTopMobbers 0
#define kFollowTableModeTopInfluencers 1
#define kFollowTableModeTopTodayMobbers 2
#define kFollowTableModeLatestMobbers 3
#define kFollowTableModeSearch 4  

@interface FollowViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, FollowTableViewCellDelegate, UITextFieldDelegate>
@property (nonatomic, assign) int selectedSelectorIndex;
@property (nonatomic, strong) PFObject *selectedUser;

@property (nonatomic, strong) NSArray *topMobbers;                // Top users
@property (nonatomic, strong) NSArray *topInfluencers;
@property (nonatomic, strong) NSArray *topTodayMobbers;
@property (nonatomic, strong) NSArray *latestMobbers;             // Top users
@property (nonatomic, strong) NSArray *searchedMobbers;
//@property (nonatomic, strong) NSMutableArray *followers;        // Users following me
//@property (nonatomic, strong) NSMutableArray *following;        // Users I'm following

//@property (nonatomic, assign) int tableMode;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, assign) BOOL isRefreshing;

@end
