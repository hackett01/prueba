//
//  PostSignupForceFollow_InfluencerTableViewCell.m
//  Caremob
//
//  Created by Rick Strom on 1/20/16.
//  Copyright © 2016 Rick Strom. All rights reserved.
//

#import "PostSignupForceFollow_InfluencerTableViewCell.h"

@implementation PostSignupForceFollow_InfluencerTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initializeWithUser:(PFObject*)user andRank:(int)rank andIsFollowing:(BOOL)isFollowing {
    if (user == nil) return;
    
    self.user = user;
    
    self.userProfileImageView.file = (PFFile*)[self.user objectForKey:kUserFieldProfileImageKey];
    [self.userProfileImageView loadInBackground];
    
    self.rankLabel.text = [NSString stringWithFormat:@"%d.", rank];
    
    self.userNameLabel.text = (NSString*)[self.user objectForKey:kUserFieldNameKey];
    
    NSNumber *influenceNumber = (NSNumber*)[self.user objectForKey:kUserFieldInfluenceKey];
    int influence = 0;
    if (influenceNumber != nil) influence = [influenceNumber intValue];
    
    self.userInfluenceLabel.text = [NSString stringWithFormat:@"Influence %d", influence];
    
    [self updateFollowButton:isFollowing];
    
}

- (IBAction)followButtonHit:(id)sender {
    // Notify the delegate
    if (self.delegate != nil) {
        BOOL isFollowing = [self.delegate follow:self.user];
        
        [self updateFollowButton:isFollowing];
    }
}

-(void)updateFollowButton:(BOOL)isFollowing {
    if (isFollowing) {
        [self.followButton setTitle:@"UNFOLLOW" forState:UIControlStateNormal];
        [self.followButton setTitleColor:[UIColor colorWithRed:12.0/255.0 green:105.0/255.0 blue:148.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.followButton setBackgroundImage:[UIImage imageNamed:@"user_button_unfollow"] forState:UIControlStateNormal];
    } else {
        [self.followButton setTitle:@"FOLLOW" forState:UIControlStateNormal];
        [self.followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.followButton setBackgroundImage:[UIImage imageNamed:@"user_button_follow"] forState:UIControlStateNormal];        
    }
}
@end
