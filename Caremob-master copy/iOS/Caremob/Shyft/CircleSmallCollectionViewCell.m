//
//  CircleSmallCollectionViewCell.m
//  Shyft
//
//  Created by Rick Strom on 11/15/14.
//  Copyright (c) 2014 Rick Strom. All rights reserved.
//

#import "CircleSmallCollectionViewCell.h"

@implementation CircleSmallCollectionViewCell
/*
-(void)setCircleObject:(PFObject*)circle {
    if (circle == nil) return;
    
    self.circleTitleLabel.text = [circle objectForKey:kCircleFieldTitleKey];
    self.circleMomentCountLabel.text = [NSString stringWithFormat:@"%d",[[circle objectForKey:kCircleFieldTotalCircleActions] intValue]];
   
    NSMutableAttributedString *circleTitleText = [[NSMutableAttributedString alloc] initWithString:[circle objectForKey:kCircleFieldTitleKey]];

    [circleTitleText addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:@"NettoOT" size:22.0]
                            range:NSMakeRange(0, [circleTitleText length])];

    NSMutableParagraphStyle *style  = [[NSMutableParagraphStyle alloc] init];
    style.lineHeightMultiple = 0.7f;
    style.alignment = NSTextAlignmentCenter;
    style.lineBreakMode = NSLineBreakByTruncatingTail;

    [circleTitleText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, [circleTitleText length])];
    
    [self.circleTitleLabel setAttributedText:circleTitleText];
    self.circleTitleLabel.adjustsFontSizeToFitWidth = YES;
    self.circleTitleLabel.numberOfLines = 2;
    self.circleTitleLabel.minimumScaleFactor = 0.5;
    
    self.circleCategoryLabel.text = [circle objectForKey:kCircleFieldCategoryKey];
    
    PFFile *circleImageFile = (PFFile*)[circle objectForKey:kCircleFieldImageKey];
    if ([circleImageFile isDataAvailable]) {
        self.circleImageView.image = [UIImage imageWithData:[circleImageFile getData]];
    } else {
        [circleImageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (error) {
                // TODO: show default image
            } else {
                self.circleImageView.image = [UIImage imageWithData:data];
            }
        }];
    }
}
 */
@end
