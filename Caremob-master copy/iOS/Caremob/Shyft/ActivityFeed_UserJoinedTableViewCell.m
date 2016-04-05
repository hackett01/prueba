//
//  ActivityFeed_UserJoinedTableViewCel.m
//  Caremob
//
//  Created by Rick Strom on 7/19/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import "ActivityFeed_UserJoinedTableViewCell.h"

@implementation ActivityFeed_UserJoinedTableViewCell

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
    PFObject *user = [self.activity objectForKey:kActivityFieldTargetUserKey];
    
    NSString *name = [user objectForKey:kUserFieldNameKey];
    self.activityTitleLabel.text = [NSString stringWithFormat:@"Your friend %@ just joined Caremob!", name];
    
    self.userImageView.image = [UIImage imageNamed:@"default_user_image45"];
    self.userImageView.file = [user objectForKey:kUserFieldProfileImageKey];
    [self.userImageView loadInBackground];
}

@end
