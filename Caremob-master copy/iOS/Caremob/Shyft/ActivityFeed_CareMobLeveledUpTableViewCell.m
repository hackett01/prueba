//
//  ActivityFeedTableViewCell.m
//  Shyft
//
//  Created by Rick Strom on 11/19/14.
//  Copyright (c) 2014 Rick Strom. All rights reserved.
//

#import "ActivityFeed_CareMobLeveledUpTableViewCell.h"

@implementation ActivityFeed_CareMobLeveledUpTableViewCell

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
    PFObject *careMob = [self.activity objectForKey:kActivityFieldTargetCareMobKey];
    NSNumber *level = [self.activity objectForKey:kActivityFieldNumberValueKey];
    
    self.activityTitleLabel.text = @"Your Caremob leveled up!";
    self.activityDescriptionLabel.text = [careMob objectForKey:kCareMobTitleKey];
    self.levelLabel.text = [NSString stringWithFormat:@"%d", [level intValue]];
    
    self.careMobImageView.file = [careMob objectForKey:kCareMobImageKey];
    [self.careMobImageView loadInBackground];
}

- (IBAction)redeemablePointsButtonHit:(id)sender {
}
@end
