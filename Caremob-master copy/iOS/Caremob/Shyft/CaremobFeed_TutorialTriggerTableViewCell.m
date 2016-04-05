//
//  CaremobFeed_TutorialTriggerTableViewCell.m
//  Caremob
//
//  Created by Rick Strom on 1/21/16.
//  Copyright © 2016 Rick Strom. All rights reserved.
//

#import "CaremobFeed_TutorialTriggerTableViewCell.h"

@implementation CaremobFeed_TutorialTriggerTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)doneButtonHit:(id)sender {
    if (self.delegate != nil) [self.delegate tutorialTriggerDoneButtonHit];
}
@end
