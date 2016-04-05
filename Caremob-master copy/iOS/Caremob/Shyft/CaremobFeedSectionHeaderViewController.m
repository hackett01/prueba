//
//  CaremobFeedSectionHeaderViewController.m
//  Caremob
//
//  Created by Rick Strom on 6/1/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import "CaremobFeedSectionHeaderViewController.h"

@interface CaremobFeedSectionHeaderViewController ()

@end

@implementation CaremobFeedSectionHeaderViewController

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)expandButtonHit:(id)sender {
    // Call delegate
    NSLog(@"Section %d expanded", self.section);
    if (self.delegate != nil) {
        BOOL isExpanded = [self.delegate expandButtonWasHitForSection:self.section];
        if (isExpanded) {
            [self.expandButton setImage:[UIImage imageNamed:@"caremob_feed_section_header_button_collapse"] forState:UIControlStateNormal];
            //NSLog(@"Showing collapse");
        } else {
            [self.expandButton setImage:[UIImage imageNamed:@"caremob_feed_section_header_button_expand"] forState:UIControlStateNormal];
            //NSLog(@"Showing expand");
        }
    }
}

-(void)setExpandButtonState:(BOOL)isExpanded {
    if (isExpanded) {
        [self.expandButton setImage:[UIImage imageNamed:@"caremob_feed_section_header_button_collapse"] forState:UIControlStateNormal];
        //NSLog(@"Showing collapse");
    } else {
        [self.expandButton setImage:[UIImage imageNamed:@"caremob_feed_section_header_button_expand"] forState:UIControlStateNormal];
        //NSLog(@"Showing expand");
    }
}
@end
