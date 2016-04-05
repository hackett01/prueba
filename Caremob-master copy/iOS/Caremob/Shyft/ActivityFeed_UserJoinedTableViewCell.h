//
//  ActivityFeed_UserJoinedTableViewCel.h
//  Caremob
//
//  Created by Rick Strom on 7/19/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "CareMobConstants.h"

@interface ActivityFeed_UserJoinedTableViewCell : UITableViewCell
@property (nonatomic, weak) PFObject *activity;

@property (weak, nonatomic) IBOutlet PFImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *activityTitleLabel;

-(void)setMyActivity:(PFObject*)activity;
@end
