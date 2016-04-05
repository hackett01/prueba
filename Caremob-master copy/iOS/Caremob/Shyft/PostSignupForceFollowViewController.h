//
//  PostSignupForceFollowViewController.h
//  Caremob
//
//  Created by Rick Strom on 1/20/16.
//  Copyright © 2016 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CareMobConstants.h"
#import "MBProgressHUD.h"

#import "PostSignupForceFollow_InfluencerTableViewCell.h"

@interface PostSignupForceFollowViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, PostSignupForceFollow_InfluencerTableViewCellDelegate>
@property (nonatomic, strong) NSArray *influencers;
@property (nonatomic, strong) NSMutableArray *usersToFollow;
@end
