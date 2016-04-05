//
//  PostSignupForceFollow_InfluencerTableViewCell.h
//  Caremob
//
//  Created by Rick Strom on 1/20/16.
//  Copyright © 2016 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "CareMobConstants.h"

@protocol PostSignupForceFollow_InfluencerTableViewCellDelegate <NSObject>

@required
-(BOOL)follow:(PFObject*)user;
@end

@interface PostSignupForceFollow_InfluencerTableViewCell : UITableViewCell
@property (nonatomic, weak) id <PostSignupForceFollow_InfluencerTableViewCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet PFImageView *userProfileImageView;
@property (weak, nonatomic) IBOutlet UILabel *userInfluenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (nonatomic, strong) PFObject *user;

-(void)initializeWithUser:(PFObject*)user andRank:(int)rank andIsFollowing:(BOOL)isFollowing ;
- (IBAction)followButtonHit:(id)sender;
@end
