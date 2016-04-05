//
//  Follow_RankedUserTableViewCell.m
//  Caremob
//
//  Created by Rick Strom on 7/24/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import "Follow_RankedUserTableViewCell.h"

@implementation Follow_RankedUserTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)followButtonHit:(id)sender {
    // Pass this on to the delegate
    [self.delegate follow:self.user];
}

-(void)setUser:(PFUser *)user andFollowing:(BOOL)following andRank:(int)rank {
    self.user = user;
    
    if ([self.user.objectId isEqualToString:[PFUser currentUser].objectId]) {
        self.followButton.enabled = NO;
        self.followButton.hidden = YES;
    } else {
        self.followButton.enabled = YES;
        self.followButton.hidden = NO;
    }
    
    PFFile *userImage = (PFFile*)[self.user objectForKey:kUserFieldProfileImageKey];
    if (userImage == nil) {
        self.userImageView.image = [UIImage imageNamed:@"default_user_image45"];
    } else if ([userImage isDataAvailable]) {
        self.userImageView.image = [UIImage imageWithData:[userImage getData]];
    } else {
        [userImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (error) {
                
            } else {
                self.userImageView.image = [UIImage imageWithData:data];
            }
        }];
    }
    
    NSString *location = [self.user objectForKey:kUserFieldLocationKey];
    if (location == nil) location = @"";
    self.locationLabel.text = location;
    
    NSString *name = [self.user objectForKey:kUserFieldNameKey];
    if (name == nil) name = @"Anonymous";
    self.nameLabel.text = name;
    
    self.rankLabel.text = [NSString stringWithFormat:@"%d", rank];
    
    
    NSNumber *totalMobActions = (NSNumber*)[self.user objectForKey:kUserFieldTotalMobActionsKey];
    if (totalMobActions == nil) totalMobActions = [NSNumber numberWithInt:0];
    
    NSNumber *totalMobActionValue = (NSNumber*)[self.user objectForKey:kUserFieldTotalMobActionValueKey];
    if (totalMobActionValue == nil) totalMobActionValue = [NSNumber numberWithInt:0];
    
    NSNumber *level = (NSNumber*)[self.user objectForKey:kUserFieldLevelKey];
    if (level == nil) level = [NSNumber numberWithInt:0];
    
    self.totalMobActionsLabel.text = [NSString stringWithFormat:@"%d", [totalMobActions intValue]];
    self.levelLabel.text = [NSString stringWithFormat:@"%d", [level intValue]];
    
    NSString *totalTimeString;
    int totalTime = [totalMobActionValue intValue];
    int totalTimeMinutes = (int)totalTime / 60;
    int totalTimeSeconds = (int)totalTime - 60 * totalTimeMinutes;
    
    if (totalTimeMinutes > 0) totalTimeString = [NSString stringWithFormat:@"%dm %ds", totalTimeMinutes, totalTimeSeconds];
    else totalTimeString = [NSString stringWithFormat:@"%ds", totalTimeSeconds];
    
    self.totalMobActionValueLabel.text = [NSString stringWithFormat:@"%@", totalTimeString];
    
    
    //int numberOfCirclesJoined = [[self.user objectForKey:kUserFieldTotalCircleActions] intValue];
    //int numberOfCirclesCreated = [[self.user objectForKey:kUserFieldTotalCirclesCreated] intValue];
    //self.circlesJoinedLabel.text = [NSString stringWithFormat:@"Joined %d circle%@", numberOfCirclesJoined, numberOfCirclesJoined == 1?@"":@"s"];
    //self.circlesCreatedLabel.text = [NSString stringWithFormat:@"Created %d circle%@", numberOfCirclesCreated, numberOfCirclesCreated == 1?@"":@"s"];
    
    [self setFollowButtonState:following];
}

-(void)setFollowButtonState:(BOOL)following {
    if (following) [self.followButton setBackgroundImage:[UIImage imageNamed:@"caremob_follow_button_unfollow"] forState:UIControlStateNormal];
    else [self.followButton setBackgroundImage:[UIImage imageNamed:@"caremob_follow_button_follow"] forState:UIControlStateNormal];
}

@end
