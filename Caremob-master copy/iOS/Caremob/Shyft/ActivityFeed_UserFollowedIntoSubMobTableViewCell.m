//
//  ActivityFeed_UserFollowedIntoSubMobTableViewCell.m
//  Caremob
//
//  Created by Rick Strom on 9/30/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import "ActivityFeed_UserFollowedIntoSubMobTableViewCell.h"

@implementation ActivityFeed_UserFollowedIntoSubMobTableViewCell

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
    PFObject *subMob = [self.activity objectForKey:kActivityFieldTargetSubMobKey];
    PFObject *careMob = [self.activity objectForKey:kActivityFieldTargetCareMobKey];
    
    NSString *name = [user objectForKey:kUserFieldNameKey];
    NSString *subMobCategory = [subMob objectForKey:kSubMobCategoryKey];
    //NSString *careMobTitle = [careMob objectForKey:kCareMobTitleKey];
    
    //self.activityTitleLabel.text = [NSString stringWithFormat:@"%@ followed you into a %@ mob", name, subMobCategory];
    NSString *activityTitle = [NSString stringWithFormat:@"%@ followed you into a %@ mob", name, subMobCategory];
    NSDate *activityTime = activity.createdAt;
    NSString *agoString = [activityTime shortTimeAgoSinceDate:[NSDate date]];
    
    NSMutableAttributedString *activityString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %@ ago", activityTitle, agoString]];
    [activityString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"NettoOT" size:12.0] range:NSMakeRange(0, activityTitle.length)];
    [activityString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:12.0/255.0 green:105.0/255.0 blue:148.0/255.0 alpha:1.0] range:NSMakeRange(0, activityTitle.length)];
    [activityString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"NettoOT-Bold" size:10.0] range:NSMakeRange(activityTitle.length + 1, agoString.length + 4)];
    [activityString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:65.0/255.0 green:209.0/255.0 blue:240.0/255.0 alpha:1.0] range:NSMakeRange(activityTitle.length + 1, agoString.length + 4)];
    
    
    self.activityTitleLabel.attributedText = activityString;

    self.userImageView.image = [UIImage imageNamed:@"default_user_image45"];
    self.userImageView.file = [user objectForKey:kUserFieldProfileImageKey];
    [self.userImageView loadInBackground];
    
    self.careMobImageView.file = [careMob objectForKey:kCareMobImageKey];
    [self.careMobImageView loadInBackground];
    
    self.subMobCategoryImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"activity_mob_image_overlay_%@", subMobCategory]];

    // Redeemable points view
    self.redeemablePointsActivityIndicator.hidden = YES;
    [self.redeemablePointsActivityIndicator stopAnimating];

    PFObject *redeemablePoints = (PFObject*)[self.activity objectForKey:kActivityFieldTargetRedeemablePointsKey];
    if (redeemablePoints != nil) {
        NSNumber *points = [redeemablePoints objectForKey:kRedeemablePointsFieldPointsKey];
        NSNumber *wasRedeemed = (NSNumber*)[redeemablePoints objectForKey:kRedeemablePointsFieldWasRedeemedKey];
        
        if ([wasRedeemed boolValue]) {
            self.redeemablePointsView.alpha = 0.0;
        } else {

            self.redeemablePointsLabel.text = [NSString stringWithFormat:@"+%d", [points intValue]];
            self.redeemablePointsIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"activity_collect_icon_%@", subMobCategory]];
            
            if ([subMobCategory isEqualToString:@"protest"]) {
                [self.redeemablePointsView setBackgroundColor:[UIColor colorWithRed:208.0/255.0 green:2.0/255.0 blue:27.0/255.0 alpha:1.0]];
            } else if ([subMobCategory isEqualToString:@"support"]) {
                [self.redeemablePointsView setBackgroundColor:[UIColor colorWithRed:100.0/255.0 green:187.0/255.0 blue:0.0/255.0 alpha:1.0]];
            } else if ([subMobCategory isEqualToString:@"mourning"]) {
                [self.redeemablePointsView setBackgroundColor:[UIColor colorWithRed:189.0/255.0 green:16.0/255.0 blue:224.0/255.0 alpha:1.0]];
            } else if ([subMobCategory isEqualToString:@"celebration"]) {
                [self.redeemablePointsView setBackgroundColor:[UIColor colorWithRed:245.0/255.0 green:166.0/255.0 blue:35.0/255.0 alpha:1.0]];
            } else if ([subMobCategory isEqualToString:@"peace"]) {
                [self.redeemablePointsView setBackgroundColor:[UIColor colorWithRed:61.0/255.0 green:200.0/255.0 blue:169.0/255.0 alpha:1.0]];
            } else if ([subMobCategory isEqualToString:@"empathy"]) {
                [self.redeemablePointsView setBackgroundColor:[UIColor colorWithRed:53.0/255.0 green:135.0/255.0 blue:192.0/255.0 alpha:1.0]];
            }
            
            self.redeemablePointsView.alpha = 1.0;
            
        }
        
        // Set the redeemed points (already redeemed) label and icon
        //self.redeemedPointsIcon.hidden = NO;
        self.redeemedPointsLabel.text = [NSString stringWithFormat:@"+%d", [points intValue]];
        
        self.influenceIcon.hidden = NO;
        self.influenceLabel.text = @"+1";


    } else {
        self.redeemablePointsView.alpha = 0.0;
        
        self.redeemedPointsIcon.hidden = YES;
        self.redeemedPointsLabel.text = @"";
        
        //self.influenceIcon.hidden = YES;
        //self.influenceLabel.text = @"";
        self.influenceIcon.hidden = NO;
        self.influenceLabel.text = @"+1";
    }
    
    self.isBusy = NO;
}

-(void)showActivityIndicator {
    self.redeemablePointsActivityIndicator.hidden = NO;
    [self.redeemablePointsActivityIndicator startAnimating];
    
    self.isBusy = YES;
}

-(void)hideActivityIndicator {
    self.redeemablePointsActivityIndicator.hidden = YES;
    [self.redeemablePointsActivityIndicator stopAnimating];
    
    self.isBusy = NO;
}

-(void)hideRedeemablePointsView {
    [UIView animateWithDuration:1.0 animations:^{
        self.redeemablePointsView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.redeemablePointsView.alpha = 0.0;
        [self.redeemablePointsActivityIndicator stopAnimating];
        self.redeemablePointsActivityIndicator.hidden = YES;
    }];
}

@end
