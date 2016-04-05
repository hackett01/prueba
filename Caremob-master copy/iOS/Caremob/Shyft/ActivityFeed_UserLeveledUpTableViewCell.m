//
//  ActivityFeed_UserLeveledUpTableViewCell.m
//  Caremob
//
//  Created by Rick Strom on 7/9/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import "ActivityFeed_UserLeveledUpTableViewCell.h"

@implementation ActivityFeed_UserLeveledUpTableViewCell

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
    NSNumber *level = [self.activity objectForKey:kActivityFieldNumberValueKey];
    
    if ([user.objectId isEqualToString:[PFUser currentUser].objectId]) {
        self.activityTitleLabel.text = [NSString stringWithFormat:@"Your unity level as a mobber grew to %d!", [level intValue]];

    } else {
        NSString *name = [user objectForKey:kUserFieldNameKey];
        self.activityTitleLabel.text = [NSString stringWithFormat:@"%@'s participation level as a mobber grew to %d!", name, [level intValue]];
    }
    
    self.userLevelLabel.text = [NSString stringWithFormat:@"%d", [level intValue]];
    
    self.userImageView.image = [UIImage imageNamed:@"default_user_image45"];
    self.userImageView.file = [user objectForKey:kUserFieldProfileImageKey];
    [self.userImageView loadInBackground];
}



@end
