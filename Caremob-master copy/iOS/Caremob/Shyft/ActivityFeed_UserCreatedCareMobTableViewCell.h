//
//  ActivityFeed_UserCreatedCareMobTableViewCell.h
//  Caremob
//
//  Created by Rick Strom on 1/13/16.
//  Copyright © 2016 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "CareMobConstants.h"
#import "NSDate+DateTools.h"

@interface ActivityFeed_UserCreatedCareMobTableViewCell : UITableViewCell
@property (nonatomic, weak) PFObject *activity;

@property (weak, nonatomic) IBOutlet PFImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;
@property (weak, nonatomic) IBOutlet PFImageView *careMobImageView;
@property (weak, nonatomic) IBOutlet UIImageView *subMobCategoryImageView;
@property (weak, nonatomic) IBOutlet UIImageView *underlayImageView;

-(void)setMyActivity:(PFObject*)activity;

@end
