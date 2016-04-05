//
//  UserProfile_UserInfoTableViewCell.m
//  Caremob
//
//  Created by Rick Strom on 10/15/15.
//  Copyright © 2015 Rick Strom. All rights reserved.
//

#import "UserProfile_UserInfoTableViewCell.h"

@implementation UserProfile_UserInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)categoryButtonHit:(id)sender {
    int index = -1;
    
    for (int i = 0; i < self.categoryButtons.count; i++) {
        if (sender == self.categoryButtons[i]) {
            index = i;
            break;
        }
    }
    
    if (index >= 0 && index < self.categoryList.count) {
        [self.delegate categoryButtonWasHitWithCategory:self.categoryList[index]];
    }
}

-(void)setCellUser:(PFObject*)user {
    if (user == nil) return;
    if ([PFUser currentUser] == nil) return;
    
    self.user = user;
    
    if ([self.user.objectId isEqualToString:[PFUser currentUser].objectId]) {
        self.chooseProfileImageButton.enabled = YES;
        self.chooseProfileImageButton.hidden = NO;
    } else {
        self.chooseProfileImageButton.enabled = NO;
        self.chooseProfileImageButton.hidden = YES;
    }
    
    NSString *name = (NSString*)[user objectForKey:kUserFieldNameKey];
    NSString *location = (NSString*)[user objectForKey:kUserFieldLocationKey];
    
    NSLog(@"Loading user %@", name);
    
    if (name != nil) self.userNameLabel.text = name;
    if (location != nil) self.userLocationLabel.text = location;
    
    self.userProfileImage.file = (PFFile*)[user objectForKey:kUserFieldProfileImageKey];
    [self.userProfileImage loadInBackground];
    
    NSNumber *userLevel = (NSNumber*)[user objectForKey:kUserFieldLevelKey];
    NSNumber *totalMobActions = (NSNumber*)[user objectForKey:kUserFieldTotalMobActionsKey];
    NSNumber *totalMobActionValue = (NSNumber*)[user objectForKey:kUserFieldTotalMobActionValueKey];
    NSNumber *influence = (NSNumber*)[user objectForKey:kUserFieldInfluenceKey];
    NSNumber *followerCount = (NSNumber*)[user objectForKey:kUserFieldFollowerCountKey];
    NSNumber *followingCount = (NSNumber*)[user objectForKey:kUserFieldFollowingCountKey];
    
    NSLog(@"Influence is %@", influence);
    
    if (userLevel != nil) self.userLevelLabel.text = [NSString stringWithFormat:@"%d", [userLevel intValue]];
    if (totalMobActions != nil) self.userMobsJoinedLabel.text = [NSString stringWithFormat:@"%d", [totalMobActions intValue]];
    if (totalMobActionValue != nil) self.userTotalMobActionValueLabel.text = [NSString stringWithFormat:@"%@", [CareMobHelper timeToString:[totalMobActionValue doubleValue]]];
    if (influence != nil) self.userInfluenceLabel.text = [NSString stringWithFormat:@"%d", [influence intValue]];
    if (followerCount != nil) self.userFollowersLabel.text = [NSString stringWithFormat:@"%d", [followerCount intValue]];
    if (followingCount != nil) self.userFollowingLabel.text = [NSString stringWithFormat:@"%d", [followingCount intValue]];
    
    NSLog(@"Following %d users and followed by %d users", [followingCount intValue], [followerCount intValue]);
    
    // Set up the category list (used to iterate through the submobPointTotalLabels and pull data from our cloud function
    self.categoryList = @[@"empathy",@"peace",@"protest",@"celebration",@"support",@"mourning"];
    
    // Initialize all submob point totals to 0
    for (int i = 0; i < self.submobPointTotalLabels.count; i++) {
        UILabel *l = (UILabel*)self.submobPointTotalLabels[i];
        l.text = @"";
    }
    
    self.followButton.hidden = YES;
    self.followButton.enabled = NO;
    
    if ([user.objectId isEqualToString:[PFUser currentUser].objectId]) {
        // We are showing our own profile
        self.logoutButton.hidden = NO;
        self.logoutButton.enabled = YES;
        
    } else {
        self.logoutButton.hidden = YES;
        self.logoutButton.enabled = NO;
        
        // Determine if we're following this user or not, and then show the button
        PFQuery *followQuery = [PFQuery queryWithClassName:kFollowClassKey];
        [followQuery setCachePolicy:kPFCachePolicyNetworkOnly];
        [followQuery whereKey:kFollowFieldFollowedKey equalTo:self.user];
        [followQuery whereKey:kFollowFieldFollowingKey equalTo:[PFUser currentUser]];
        [followQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            if (error) {
                // Do nothing
            } else {
                if (number > 0) {
                    [self.followButton setBackgroundImage:[UIImage imageNamed:@"user_button_unfollow"] forState:UIControlStateNormal];
                    [self.followButton setTitle:@"UNFOLLOW" forState:UIControlStateNormal];
                    self.followButton.hidden = NO;
                    self.followButton.enabled = YES;
                    self.isFollowing = YES;
                } else {
                    [self.followButton setBackgroundImage:[UIImage imageNamed:@"user_button_follow"] forState:UIControlStateNormal];
                    [self.followButton setTitle:@"FOLLOW" forState:UIControlStateNormal];
                    self.followButton.hidden = NO;
                    self.followButton.enabled = YES;
                    self.isFollowing = NO;
                }
            }
        }];
    }

    // Fetch point totals
    NSNumber *userPoints = (NSNumber*)[self.user objectForKey:kUserFieldPointsKey];
    if (userPoints == nil) userPoints = [NSNumber numberWithInt:0];

    NSDictionary *params = @{@"userId":self.user.objectId, @"userPoints":userPoints};
    
    [PFCloud callFunctionInBackground:kCloudFunctionGetUserSubmobPointTotalsKey withParameters:params block:^(id object, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error.localizedDescription);
        } else {
            NSDictionary *result = (NSDictionary*)object;
            NSLog(@"%@", result);
            // Iterate through result and set any matching labels to point totals
            for (id key in result) {
                NSString *category = (NSString*)key;
                NSNumber *points = (NSNumber*)result[key];
                int pointsInt = [points intValue];
                
                // Find the index
                int index = -1;
                for (int i = 0; i < self.categoryList.count; i++) {
                    if ([self.categoryList[i] isEqualToString:category]) index = i;
                }
                
                if (index >= 0) {
                    UILabel *l = (UILabel*)self.submobPointTotalLabels[index];
                    l.text = [NSString stringWithFormat:@"%d", pointsInt];
                }
                
            }
            
            
        }
        
        // Now try to get the user's rank (using the same params dict)
        // TODO: Update cloud function to only return rank since its all we need now
        [PFCloud callFunctionInBackground:kCloudFunctionGetUserRankKey withParameters:params block:^(id object, NSError *error) {
            if (error) {
                NSLog(@"Error %@", error.localizedDescription);
            } else {
                NSDictionary *result = (NSDictionary*)object;
                NSNumber *rank = result[@"rank"];
                
                if (rank != nil) self.userRankLabel.text = [NSString stringWithFormat:@"#%d", [rank intValue]];
            }
        }];
    }];
    
    //REMOVED 10.27.2015
    /*
    // Configure the fill meter
    if ([self.user.objectId isEqualToString:[PFUser currentUser].objectId]) {
        self.levelMeterBackgroundImage.hidden = NO;
        self.levelMeterFillImage.hidden = NO;
        self.nextLevelLabel.hidden = NO;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
 
        long points = [defaults integerForKey:kNSUserDefaultsUserPoints];
        //long level = [defaults integerForKey:kNSUserDefaultsUserLevel];
        long pointsToCurrentLevel = [defaults integerForKey:kNSUserDefaultsUserPointsToCurrentLevel];
        long pointsToNextLevel = [defaults integerForKey:kNSUserDefaultsUserPointsToNextLevel];
        
        long pointsToGo = pointsToNextLevel - pointsToCurrentLevel;
        self.nextLevelLabel.text = [NSString stringWithFormat:@"Next Lvl %ld", pointsToGo];
        
        float percent = (float)(points - pointsToCurrentLevel) / (float)(pointsToNextLevel - pointsToCurrentLevel);
        NSLog(@"Percent to go is %f", percent);
        
        CGRect frame = self.levelMeterFillImage.frame;
        double placement = percent * frame.size.width;
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        CGRect maskRect = CGRectMake(0, 0, placement, frame.size.height);
        
        // Create a path with the rectangle in it.
        CGPathRef path = CGPathCreateWithRect(maskRect, NULL);
        
        // Set the path to the mask layer.
        maskLayer.path = path;
        
        // Release the path since it's not covered by ARC.
        CGPathRelease(path);
        
        // Set the mask of the view.
        self.levelMeterFillImage.layer.mask = maskLayer;
    } else {
        self.levelMeterBackgroundImage.hidden = YES;
        self.levelMeterFillImage.hidden = YES;
        self.nextLevelLabel.hidden = YES;
    }
     */
}

- (IBAction)followButtonHit:(id)sender {
    NSLog(@"Follow button hit");
    self.followButton.enabled = NO;
    
    if (self.isFollowing) {
        NSLog(@"Attempting to delete the follow");
        // Delete the follow
        PFQuery *followQuery = [PFQuery queryWithClassName:kFollowClassKey];
        [followQuery setCachePolicy:kPFCachePolicyNetworkOnly];
        [followQuery whereKey:kFollowFieldFollowedKey equalTo:self.user];
        [followQuery whereKey:kFollowFieldFollowingKey equalTo:[PFUser currentUser]];
        [followQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            NSLog(@"Completed!");
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
                self.followButton.enabled = YES;
            } else {
                if (objects.count == 0) {
                    NSLog(@"Found no objects!");
                } else {
                    NSLog(@"Now attemtping to delete found follow");
                    PFObject *follow = (PFObject*)objects[0];
                    [follow deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (error) {
                            NSLog(@"Error: %@", error.localizedDescription);
                            self.followButton.enabled = YES;
                        } else {
                            self.isFollowing = NO;
                            [self.followButton setBackgroundImage:[UIImage imageNamed:@"user_button_follow"]    forState:UIControlStateNormal];
                            [self.followButton setTitle:@"FOLLOW" forState:UIControlStateNormal];
                            self.followButton.enabled = YES;
                        }
                    }];
                }
            }
        }];
    } else {
        // Create a new follow
        NSLog(@"Attempting to create a follow");
        
        PFObject *follow = [PFObject objectWithClassName:kFollowClassKey];
        [follow setObject:[PFUser currentUser] forKey:kFollowFieldFollowingKey];
        [follow setObject:self.user forKey:kFollowFieldFollowedKey];
        [follow saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error.localizedDescription);
                self.followButton.enabled = YES;
            } else {
                NSLog(@"Now following");
                self.isFollowing = YES;
                [self.followButton setBackgroundImage:[UIImage imageNamed:@"user_button_unfollow"] forState:UIControlStateNormal];
                [self.followButton setTitle:@"UNFOLLOW" forState:UIControlStateNormal];
                self.followButton.enabled = YES;
            }
        }];
    }
}

- (IBAction)logoutButtonHit:(id)sender {
    if (self.delegate != nil) [self.delegate logoutButtonWasHit];
}

- (IBAction)chooseProfileImageButtonHit:(id)sender {
    if (self.delegate != nil) [self.delegate chooseProfileImageButtonWasHit];
}

@end
