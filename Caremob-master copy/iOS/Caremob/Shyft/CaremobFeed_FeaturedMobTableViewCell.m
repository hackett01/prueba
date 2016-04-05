//
//  CaremobFeed_FeaturedMobTableViewCell.m
//  Caremob
//
//  Created by Rick Strom on 9/21/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import "CaremobFeed_FeaturedMobTableViewCell.h"

@implementation CaremobFeed_FeaturedMobTableViewCell


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)initializeWithCareMob:(PFObject*)careMob andCategoryContext:(NSString*)categoryContext andRank:(int)rank andLevel:(int)level andMembers:(int)members andTotalValue:(double)totalValue  andEffectivePoints:(float)effectivePoints {
    if (careMob != nil) {
        self.careMob = careMob;
        
        NSNumber *levelNumber = (NSNumber*)[careMob objectForKey:kCareMobLevelKey];
        level = [levelNumber intValue];
        
        PFFile *careMobImage = (PFFile*)[careMob objectForKey:kCareMobImageKey];
        
        self.caremobImageView.file = careMobImage;
        [self.caremobImageView loadInBackground];
        
        self.caremobTitleLabel.text = [careMob objectForKey:kCareMobTitleKey];
        
        self.totalMobActionValueLabel.text = [NSString stringWithFormat:@"%@",[CareMobHelper timeToString:totalValue]];
        
        self.totalMobActionsLabel.text = [NSString stringWithFormat:@"%d", members];
        
        self.mobLevelLabel.text = [NSString stringWithFormat:@"Level %d", level];
        self.categoryContext = categoryContext;
        
        if (categoryContext == nil) self.caremobCategoryImageView.hidden = YES;
        else {
            self.caremobCategoryImageView.hidden = NO;
            self.caremobCategoryImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"caremob_category_icon_64_%@", categoryContext]];
            self.caremobCategoryLabel.text = [categoryContext uppercaseString];
        }
        
        NSString *source = (NSString*)[careMob objectForKey:kCareMobSourceKey];
        PFObject *sourceUser = (PFObject*)[careMob objectForKey:kCareMobSourceUserKey];
        
        if (source != nil) {
            NSString *sourceString = @"Other";
            
            if ([source isEqualToString:@"the_guardian_world_protest"]) source = @"theguardian";
            
            sourceString = [CareMobHelper feedSourceValueToPrintableString:source];
            
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
            
            NSDateFormatter *nowDateFormatter = [[NSDateFormatter alloc] init];
            [nowDateFormatter setDateFormat:@"MMMM d, yyyy"];
            NSString *dateString = [nowDateFormatter stringFromDate:careMob.createdAt];
            
            self.caremobSourceLabel.text = [NSString stringWithFormat:@"Source: %@, %@", sourceUserUsername, dateString];
        } else {
            self.caremobSourceIconButton.enabled = NO;
            self.caremobSourceIconButton.hidden = YES;
            
            self.caremobSourceUserIconButton.enabled = NO;
            self.caremobSourceUserIconButton.hidden = YES;
            
            self.caremobSourceUserImageView.hidden = YES;
            
            self.caremobSourceLabel.text = @"";
        }
    }

}


- (IBAction)caremobSourceIconButtonHit:(id)sender {
}

- (IBAction)caremobSourceUserIconButtonHit:(id)sender {
}
@end
