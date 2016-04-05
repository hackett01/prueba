//
//  ActivityFeed_UserFollowedTableViewCell.m
//  Caremob
//
//  Created by Rick Strom on 7/20/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import "ActivityFeed_UserFollowedTableViewCell.h"

@implementation ActivityFeed_UserFollowedTableViewCell

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
    //self.activityTitleLabel.text = [NSString stringWithFormat:@"%@ started following you!", name];
    NSString *activityTitle = [NSString stringWithFormat:@"%@ started following you!", name];
    NSDate *activityTime = activity.createdAt;
    NSString *agoString = [activityTime shortTimeAgoSinceDate:[NSDate date]];
    
    NSMutableAttributedString *activityString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@ ago", activityTitle, agoString]];
    [activityString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"NettoOT" size:12.0] range:NSMakeRange(0, activityTitle.length)];
    [activityString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:61.0/255.0 green:61.0/255.0 blue:61.0/255.0 alpha:1.0] range:NSMakeRange(0, activityTitle.length)];
    [activityString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"NettoOT-Bold" size:10.0] range:NSMakeRange(activityTitle.length + 1, agoString.length + 4)];
    [activityString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:65.0/255.0 green:209.0/255.0 blue:240.0/255.0 alpha:1.0] range:NSMakeRange(activityTitle.length + 1, agoString.length + 4)];
    
    
    self.activityTitleLabel.attributedText = activityString;
    
    self.userImageView.image = [UIImage imageNamed:@"default_user_image45"];
    self.userImageView.file = [user objectForKey:kUserFieldProfileImageKey];
    [self.userImageView loadInBackground];
}

@end
