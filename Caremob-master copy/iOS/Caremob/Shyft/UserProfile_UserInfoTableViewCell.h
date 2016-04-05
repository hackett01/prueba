//
//  UserProfile_UserInfoTableViewCell.h
//  Caremob
//
//  Created by Rick Strom on 10/15/15.
//  Copyright © 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "CareMobConstants.h"
#import "CareMobHelper.h"

@protocol UserProfile_UserInfoTableViewCellDelegate <NSObject>

@optional
-(void)chooseProfileImageButtonWasHit;
-(void)categoryButtonWasHitWithCategory:(NSString*)category;
-(void)logoutButtonWasHit;
@end

@interface UserProfile_UserInfoTableViewCell : UITableViewCell
@property (nonatomic, weak) id <UserProfile_UserInfoTableViewCellDelegate> delegate;

@property (nonatomic, strong) PFObject *user;

@property (nonatomic, strong) NSArray *categoryList;

@property (nonatomic, assign) BOOL isFollowing;

@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet PFImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UIButton *chooseProfileImageButton;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *userRankLabel;
@property (weak, nonatomic) IBOutlet UILabel *userMobsJoinedLabel;
@property (weak, nonatomic) IBOutlet UILabel *userTotalMobActionValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *userInfluenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *userFollowersLabel;
@property (weak, nonatomic) IBOutlet UILabel *userFollowingLabel;

@property (weak, nonatomic) IBOutlet UIImageView *levelMeterBackgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *levelMeterFillImage;
@property (weak, nonatomic) IBOutlet UILabel *nextLevelLabel;


@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *submobPointTotalLabels;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *categoryButtons;

- (IBAction)categoryButtonHit:(id)sender;

-(void)setCellUser:(PFObject*)user;

- (IBAction)followButtonHit:(id)sender;
- (IBAction)logoutButtonHit:(id)sender;
- (IBAction)chooseProfileImageButtonHit:(id)sender;

@end
