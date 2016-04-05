//
//  FollowTableViewCell.h
//  Shyft
//
//  Created by Rick Strom on 2/2/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "CareMobConstants.h"
#import <Parse/Parse.h>
#import "Follow_BaseTableViewCell.h"

/*
@protocol FollowTableViewCellDelegate <NSObject>

@optional
-(void)follow:(PFUser*)user;
@end
*/

@interface Follow_UserTableViewCell : Follow_BaseTableViewCell
@property (nonatomic, weak) id <FollowTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMobActionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMobActionValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;


@property (nonatomic, weak) PFUser *user;
@property (nonatomic, assign) BOOL isFollowing;

- (IBAction)followButtonHit:(id)sender;

-(void)setUser:(PFUser *)user andFollowing:(BOOL)following;
-(void)setFollowButtonState:(BOOL)following;
@end
