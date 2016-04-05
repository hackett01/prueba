//
//  UserActivityTableViewCell.h
//  Shyft
//
//  Created by Rick Strom on 2/6/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CareMobConstants.h"
#import "NSDate+DateTools.h"

@interface UserActivityTableViewCell : UITableViewCell
@property (nonatomic, weak) PFObject *activity;

@property (weak, nonatomic) IBOutlet UIImageView *detailIndicatorImageView;

@property (weak, nonatomic) IBOutlet UIImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;

@property (weak, nonatomic) IBOutlet UILabel *activityTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityDescriptionLabel;

-(void)setMyActivity:(PFObject*)activity;
@end
