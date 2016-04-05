//
//  ActivityFeed_UserEnteredSubMobTableViewCell.h
//  Caremob
//
//  Created by Rick Strom on 7/20/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "CareMobConstants.h"
#import "CareMobHelper.h"
#import "NSDate+DateTools.h"

@interface ActivityFeed_UserEnteredSubMobTableViewCell : UITableViewCell
@property (nonatomic, weak) PFObject *activity;

@property (weak, nonatomic) IBOutlet PFImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *activitySubtitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *caremobTitleLabel;
@property (weak, nonatomic) IBOutlet PFImageView *careMobImageView;
@property (weak, nonatomic) IBOutlet UIImageView *subMobCategoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *caremobCategoryLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalMobActionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMobActionValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobLevelLabel;

@property (weak, nonatomic) IBOutlet UILabel *caremobSourceLabel;
@property (weak, nonatomic) IBOutlet UIButton *caremobSourceIconButton;
@property (weak, nonatomic) IBOutlet UIButton *caremobSourceUserIconButton;
@property (weak, nonatomic) IBOutlet PFImageView *caremobSourceUserImageView;
@property (weak, nonatomic) IBOutlet UIImageView *originalCategoryImageView;


- (IBAction)caremobSourceIconButtonHit:(id)sender;
- (IBAction)caremobSourceUserIconButtonHit:(id)sender;

-(void)setMyActivity:(PFObject*)activity;

@end
