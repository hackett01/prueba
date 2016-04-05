//
//  ActivityFeed_UserLeveledUpTableViewCell.h
//  Caremob
//
//  Created by Rick Strom on 7/9/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "CareMobConstants.h"
#import "NSDate+DateTools.h"

@interface ActivityFeed_UserLeveledUpTableViewCell : UITableViewCell
@property (nonatomic, weak) PFObject *activity;

@property (weak, nonatomic) IBOutlet PFImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLevelLabel;

-(void)setMyActivity:(PFObject*)activity;

@end
