//
//  UserProfile_MobTableViewCell.m
//  Caremob
//
//  Created by Rick Strom on 10/20/15.
//  Copyright © 2015 Rick Strom. All rights reserved.
//

#import "UserProfile_MobTableViewCell.h"

@implementation UserProfile_MobTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initializeWithCareMob:(PFObject*)careMob andCategoryContext:(NSString*)categoryContext andMobActionValue:(NSNumber*)mobActionValue {
    self.categoryContext = categoryContext;
    
    self.caremobCategoryIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"caremob_category_icon_%@", self.categoryContext]];
    
    PFFile *careMobImage = (PFFile*)[careMob objectForKey:kCareMobImageKey];
    
    self.caremobImageView.file = careMobImage;
    [self.caremobImageView loadInBackground];

    NSString *careMobTitle = [careMob objectForKey:kCareMobTitleKey];
    self.caremobTitleLabel.text = careMobTitle;
    
    NSString *source = (NSString*)[careMob objectForKey:kCareMobSourceKey];
    if (source != nil) {
        NSString *sourceString = @"Other";
        
        if ([source isEqualToString:@"theguardian_world_protest"]) source = @"theguardian";
        
        sourceString = [CareMobHelper feedSourceValueToPrintableString:source];
                
        NSDateFormatter *nowDateFormatter = [[NSDateFormatter alloc] init];
        [nowDateFormatter setDateFormat:@"MMMM d, yyyy"];
        NSString *dateString = [nowDateFormatter stringFromDate:careMob.createdAt];
        
        self.caremobSourceLabel.text = [NSString stringWithFormat:@"Source: %@, %@", sourceString, dateString];
    } else self.caremobSourceLabel.text = @"";

    if (mobActionValue != nil) {
        double mav = [mobActionValue doubleValue];
        NSString *mavFormatted = [CareMobHelper timeToString:mav];
        self.mobActionValueLabel.text = mavFormatted;
    } else {
        self.mobActionValueLabel.text = @"";
    }
}
@end
