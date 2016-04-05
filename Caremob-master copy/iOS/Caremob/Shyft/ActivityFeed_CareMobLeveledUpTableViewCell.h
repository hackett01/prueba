//
//  ActivityFeedTableViewCell.h
//  Shyft
//
//  Created by Rick Strom on 11/19/14.
//  Copyright (c) 2014 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "CareMobConstants.h"
#import "NSDate+DateTools.h"

@interface ActivityFeed_CareMobLeveledUpTableViewCell : UITableViewCell
@property (nonatomic, weak) PFObject *activity;

@property (weak, nonatomic) IBOutlet PFImageView *careMobImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *activityDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIButton *redeemablePointsButton;

-(void)setMyActivity:(PFObject*)activity;
- (IBAction)redeemablePointsButtonHit:(id)sender;
@end
