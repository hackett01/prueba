//
//  ActivityFeed_UserCreatedCareMobTableViewCell.m
//  Caremob
//
//  Created by Rick Strom on 1/13/16.
//  Copyright © 2016 Rick Strom. All rights reserved.
//

#import "ActivityFeed_UserCreatedCareMobTableViewCell.h"

@implementation ActivityFeed_UserCreatedCareMobTableViewCell

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
    PFObject *careMob = [self.activity objectForKey:kActivityFieldTargetCareMobKey];
    NSString *category = [self.activity objectForKey:kActivityFieldStringValueKey];
    
    NSString *name = [user objectForKey:kUserFieldNameKey];
    
    NSString *activityTitle = [NSString stringWithFormat:@"%@ started a %@ mob", name, category];
    NSDate *activityTime = activity.createdAt;
    NSString *agoString = [activityTime shortTimeAgoSinceDate:[NSDate date]];
    
    NSMutableAttributedString *activityString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@ ago", activityTitle, agoString]];
    [activityString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"NettoOT" size:12.0] range:NSMakeRange(0, activityTitle.length)];
    [activityString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:104.0/255.0 green:104.0/255.0 blue:104.0/255.0 alpha:1.0] range:NSMakeRange(0, activityTitle.length)];
    [activityString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"NettoOT-Bold" size:10.0] range:NSMakeRange(activityTitle.length + 1, agoString.length + 4)];
    [activityString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:65.0/255.0 green:209.0/255.0 blue:240.0/255.0 alpha:1.0] range:NSMakeRange(activityTitle.length + 1, agoString.length + 4)];
    
    
    self.activityTitleLabel.attributedText = activityString;
    
    self.userImageView.image = [UIImage imageNamed:@"default_user_image45"];
    self.userImageView.file = [user objectForKey:kUserFieldProfileImageKey];
    [self.userImageView loadInBackground];
    
    self.careMobImageView.file = [careMob objectForKey:kCareMobImageKey];
    [self.careMobImageView loadInBackground];
    
    self.subMobCategoryImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"trending_mob_icon_%@_featured", category]];
    self.underlayImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"activity_collect_overlay_%@", category]];
}
@end
