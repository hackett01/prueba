//
//  UserProfile_FollowUserTableViewCell.h
//  Caremob
//
//  Created by Rick Strom on 10/19/15.
//  Copyright © 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "CareMobConstants.h"

@interface UserProfile_FollowUserTableViewCell : UITableViewCell
@property (nonatomic, strong) PFObject *user;

@property (weak, nonatomic) IBOutlet PFImageView *userProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

-(void)setCellUser:(PFObject*)user;
@end
