//
//  CircleSmallCollectionViewCell.h
//  Shyft
//
//  Created by Rick Strom on 11/15/14.
//  Copyright (c) 2014 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CareMobConstants.h"

@interface CircleSmallCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;
@property (weak, nonatomic) IBOutlet UILabel *circleTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *circleCategoryLabel;


@property (weak, nonatomic) IBOutlet UILabel *circleMomentCountLabel;

-(void)setCircleObject:(PFObject*)circle;
@end
