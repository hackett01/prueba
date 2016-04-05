//
//  UserProfileViewController.h
//  Caremob
//
//  Created by Rick Strom on 10/15/15.
//  Copyright © 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "CareMobConstants.h"

#import "RootViewController.h"

#import "UserProfile_UserInfoTableViewCell.h"
#import "UserProfile_FollowUserTableViewCell.h"
#import "UserProfile_NoMobsTableViewCell.h"
#import "UserProfile_MobTableViewCell.h"

#import "UserProfile_LatestMobsSectionHeaderViewController.h"

#import "CaremobDisplayViewController.h"

#define kUserProfileTableModeProfile 0
#define kUserProfileTableModeFollowers 1
#define kUserProfileTableModeFollowing 2


@interface UserProfileViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UserProfile_UserInfoTableViewCellDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
@property (nonatomic, assign) int selectedSelectorIndex;
@property (nonatomic, strong) NSMutableArray *followers;
@property (nonatomic, strong) NSMutableArray *following;
@property (nonatomic, strong) NSArray *userMobActions;
@property (nonatomic, strong) NSMutableArray *prunedMobActions;

@property (nonatomic, weak) PFObject *selectedCareMob;
@property (nonatomic, weak) PFObject *selectedSubMob;
@property (nonatomic, weak) NSString *selectedCategoryContext;
@property (nonatomic, weak) PFUser *followingUser;
@property (nonatomic, strong) PFObject *selectedUser;

@property (nonatomic, strong) PFObject *user;

@property (nonatomic, strong) NSString *selectedCategory;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, assign) BOOL isRefreshing;

@property (nonatomic, strong) PFFile *imageFile;
@end
