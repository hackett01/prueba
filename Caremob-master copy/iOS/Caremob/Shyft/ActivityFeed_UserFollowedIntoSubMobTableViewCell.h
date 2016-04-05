//
//  ActivityFeed_UserFollowedIntoSubMobTableViewCell.h
//  Caremob
//
//  Created by Rick Strom on 9/30/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "CareMobConstants.h"
#import "NSDate+DateTools.h"

@interface ActivityFeed_UserFollowedIntoSubMobTableViewCell : UITableViewCell
@property (nonatomic, weak) PFObject *activity;

@property (weak, nonatomic) IBOutlet PFImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (weak, nonatomic) IBOutlet PFImageView *careMobImageView;
@property (weak, nonatomic) IBOutlet UIImageView *subMobCategoryImageView;

@property (weak, nonatomic) IBOutlet UIView *redeemablePointsView;
@property (weak, nonatomic) IBOutlet UILabel *redeemablePointsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *redeemablePointsIcon;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *redeemablePointsActivityIndicator;

@property (weak, nonatomic) IBOutlet UIImageView *redeemedPointsIcon;
@property (weak, nonatomic) IBOutlet UILabel *redeemedPointsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *influenceIcon;
@property (weak, nonatomic) IBOutlet UILabel *influenceLabel;


@property (nonatomic, assign) BOOL isBusy;

-(void)setMyActivity:(PFObject*)activity;
-(void)showActivityIndicator;
-(void)hideActivityIndicator;
-(void)hideRedeemablePointsView;
@end
