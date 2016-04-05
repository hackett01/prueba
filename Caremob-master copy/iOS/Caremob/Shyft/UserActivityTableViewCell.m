//
//  UserActivityTableViewCell.m
//  Shyft
//
//  Created by Rick Strom on 2/6/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import "UserActivityTableViewCell.h"

@implementation UserActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)setMyActivity:(PFObject*)activity {
    self.activity = activity;
    
    // Common to all activity types
    PFUser *user = [self.activity objectForKey:kActivityFieldUserKey];
    PFUser *targetUser = [self.activity objectForKey:kActivityFieldTargetUserKey];
    //PFObject *careMob = [self.activity objectForKey:kActivityFieldTargetCareMobKey];
    NSString *type = [self.activity objectForKey:kActivityFieldTypeKey];
    
    self.activityDescriptionLabel.text = @"description";
    
    self.activityTimeLabel.text = [NSString stringWithFormat:@"%@ ago", [NSDate shortTimeAgoSinceDate:self.activity.createdAt]];
    
    PFFile *userImage = (PFFile*)[user objectForKey:kUserFieldProfileImageKey];
    if ([userImage isDataAvailable]) {
        self.userProfileImageView.image = [UIImage imageWithData:[userImage getData]];
    } else {
        [userImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (error) {
                
            } else {
                self.userProfileImageView.image = [UIImage imageWithData:data];
            }
        }];
    }
    
    
    if ([type isEqualToString:kActivityTypeFollow]) {
        self.detailIndicatorImageView.hidden = YES;
        
        if ([targetUser.objectId isEqualToString:[PFUser currentUser].objectId]) {
            // Show follow button
            self.circleImageView.hidden = YES;
        } else {
            PFFile *targetUserImage = (PFFile*)[targetUser objectForKey:kUserFieldProfileImageKey];
            if ([targetUserImage isDataAvailable]) {
                self.circleImageView.image = [UIImage imageWithData:[targetUserImage getData]];
                self.circleImageView.hidden = NO;
            } else {
                [targetUserImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (error) {
                        
                    } else {
                        self.circleImageView.image = [UIImage imageWithData:data];
                        self.circleImageView.hidden = NO;
                    }
                }];
            }
            
        }
    }
    
    
    
    
}

@end
