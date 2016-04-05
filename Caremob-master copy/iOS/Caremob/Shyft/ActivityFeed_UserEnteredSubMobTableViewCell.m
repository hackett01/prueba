//
//  ActivityFeed_UserEnteredSubMobTableViewCell.m
//  Caremob
//
//  Created by Rick Strom on 7/20/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import "ActivityFeed_UserEnteredSubMobTableViewCell.h"

@implementation ActivityFeed_UserEnteredSubMobTableViewCell

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
    NSString *careMobTitle = [careMob objectForKey:kCareMobTitleKey];
    
    NSString *activityTitle = [NSString stringWithFormat:@"%@ united in a %@ mob", name, subMobCategory];
    NSString *activitySubtitle = @"";
    
    // See if we have a subtitle to show
    NSNumber *countNumber = (NSNumber*)[activity objectForKey:kActivityFieldNumberValueKey];
    int count = 0;
    if (countNumber != nil) {
        count = [countNumber intValue];
        if (count > 0)
            activitySubtitle = [NSString stringWithFormat:@"together with %d other%@ you are following ", count, (count == 1)?@"":@"s"];
    } else {
    
     //[NSString stringWithFormat:@"together with 4 others you are following"];
    }
    
    NSDate *activityTime = activity.createdAt;
    NSString *agoString = [activityTime shortTimeAgoSinceDate:[NSDate date]];
    
    NSMutableAttributedString *activityTitleString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", activityTitle]];
    [activityTitleString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"NettoOT" size:14.0] range:NSMakeRange(0, activityTitle.length)];
    [activityTitleString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:104.0/255.0 green:104.0/255.0 blue:104.0/255.0 alpha:1.0] range:NSMakeRange(0, activityTitle.length)];
    
    NSMutableAttributedString *activitySubtitleString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@ ago", activitySubtitle, agoString]];
    [activitySubtitleString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"NettoOT" size:12.0] range:NSMakeRange(0, activitySubtitle.length)];
    [activitySubtitleString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:12.0/255.0 green:105.0/255.0 blue:148.0/255.0 alpha:1.0] range:NSMakeRange(0, activitySubtitle.length)];
    [activitySubtitleString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"NettoOT-Bold" size:10.0] range:NSMakeRange(activitySubtitle.length, agoString.length + 4)];
    [activitySubtitleString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:65.0/255.0 green:209.0/255.0 blue:240.0/255.0 alpha:1.0] range:NSMakeRange(activitySubtitle.length, agoString.length + 4)];
    
    self.activityTitleLabel.attributedText = activityTitleString;
    self.activitySubtitleLabel.attributedText = activitySubtitleString;
    self.caremobTitleLabel.text = careMobTitle;
    
    self.userImageView.image = [UIImage imageNamed:@"default_user_image45"];
    self.userImageView.file = [user objectForKey:kUserFieldProfileImageKey];
    [self.userImageView loadInBackground];
    
    self.careMobImageView.file = [careMob objectForKey:kCareMobImageKey];
    [self.careMobImageView loadInBackground];
    
    self.subMobCategoryImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"caremob_category_icon_64_%@", subMobCategory]];
    self.caremobCategoryLabel.text = [subMobCategory uppercaseString];
    
    NSString *source = (NSString*)[careMob objectForKey:kCareMobSourceKey];
    PFObject *sourceUser = (PFObject*)[careMob objectForKey:kCareMobSourceUserKey];
    if (source != nil) {
        NSString *sourceString = @"Other";
        
        
        // Required to simplify the source string
        if ([source isEqualToString:@"theguardian_world_protest"])
            source = @"theguardian";
            
        sourceString = [CareMobHelper feedSourceValueToPrintableString:source];
            
        //self.caremobSourceIconImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@Logo", source]];
        //self.caremobSourceIconImageView.hidden = NO;
        
        //[self.caremobSourceIconButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@Logo", source]] forState:UIControlStateNormal];
        [self.caremobSourceIconButton setBackgroundImage:[UIImage imageNamed:[CareMobHelper feedSourceValueToIconName:source]] forState:UIControlStateNormal];
        self.caremobSourceIconButton.enabled = YES;
        self.caremobSourceIconButton.hidden = NO;
        
        self.caremobSourceUserIconButton.enabled = NO;
        self.caremobSourceUserIconButton.hidden = YES;
        
        self.caremobSourceUserImageView.hidden = YES;

        NSDateFormatter *nowDateFormatter = [[NSDateFormatter alloc] init];
        [nowDateFormatter setDateFormat:@"MMMM d, yyyy"];
        NSString *dateString = [nowDateFormatter stringFromDate:careMob.createdAt];
        
        self.caremobSourceLabel.text = [NSString stringWithFormat:@"Source: %@, %@", sourceString, dateString];
    } else if (sourceUser != nil) {
        self.caremobSourceIconButton.enabled = NO;
        self.caremobSourceIconButton.hidden = YES;
        
        self.caremobSourceUserIconButton.enabled = YES;
        self.caremobSourceUserIconButton.hidden = NO;
        
        self.caremobSourceUserImageView.image = [UIImage imageNamed:@"blank"];
        self.caremobSourceUserImageView.file = (PFFile*)[sourceUser objectForKey:kUserFieldProfileImageKey];
        [self.caremobSourceUserImageView loadInBackground];
        self.caremobSourceUserImageView.hidden = NO;
        
        NSString *sourceUserUsername = (NSString*)[sourceUser objectForKey:kUserFieldNameKey];
        self.caremobSourceLabel.text = [NSString stringWithFormat:@"Source: %@", sourceUserUsername];
    } else {
        self.caremobSourceIconButton.enabled = NO;
        self.caremobSourceIconButton.hidden = YES;
        
        self.caremobSourceUserIconButton.enabled = NO;
        self.caremobSourceUserIconButton.hidden = YES;
        
        self.caremobSourceUserImageView.hidden = YES;
        
        self.caremobSourceLabel.text = @"";
    }

    NSNumber *totalValueNumber = (NSNumber*)[subMob objectForKey:kSubMobTotalMobActionValueKey];
    double totalValue = [totalValueNumber doubleValue];
    
    NSNumber *membersNumber = (NSNumber*)[subMob objectForKey:kSubMobTotalMobActionsKey];
    int members = [membersNumber intValue];
    
    NSNumber *levelNumber = (NSNumber*)[subMob objectForKey:kSubMobLevelKey];
    int level = [levelNumber intValue];
    
    self.totalMobActionValueLabel.text = [CareMobHelper timeToString:totalValue];
    self.totalMobActionsLabel.text = [NSString stringWithFormat:@"%d", members];
    self.mobLevelLabel.text = [NSString stringWithFormat:@"Level %d", level];
    
    NSString *originalCategory = (NSString*)[careMob objectForKey:kCareMobOriginalCategoryKey];
    if (originalCategory != nil && sourceUser != nil) {
        self.originalCategoryImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"caremob_category_icon_%@", originalCategory]];
        self.originalCategoryImageView.hidden = NO;
    } else {
        self.originalCategoryImageView.hidden = YES;
    }
}

- (IBAction)caremobSourceIconButtonHit:(id)sender {
    
}

- (IBAction)caremobSourceUserIconButtonHit:(id)sender {
    
}

@end
