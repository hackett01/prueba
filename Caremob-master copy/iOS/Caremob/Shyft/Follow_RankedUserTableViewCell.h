//
//  Follow_RankedUserTableViewCell.h
//  Caremob
//
//  Created by Rick Strom on 7/24/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CareMobConstants.h"
#import <Parse/Parse.h>
#import "Follow_BaseTableViewCell.h"

@interface Follow_RankedUserTableViewCell : Follow_BaseTableViewCell
@property (nonatomic, weak) id <FollowTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMobActionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMobActionValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;


@property (nonatomic, weak) PFUser *user;
@property (nonatomic, assign) BOOL isFollowing;

- (IBAction)followButtonHit:(id)sender;

-(void)setUser:(PFUser *)user andFollowing:(BOOL)following andRank:(int)rank;
-(void)setFollowButtonState:(BOOL)following;

@end
