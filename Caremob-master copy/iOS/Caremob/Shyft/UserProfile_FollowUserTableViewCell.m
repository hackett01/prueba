//
//  UserProfile_FollowUserTableViewCell.m
//  Caremob
//
//  Created by Rick Strom on 10/19/15.
//  Copyright © 2015 Rick Strom. All rights reserved.
//

#import "UserProfile_FollowUserTableViewCell.h"

@implementation UserProfile_FollowUserTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setCellUser:(PFObject*)user {
    if (user == nil) return;
    self.user = user;
    
    NSString *name = (NSString*)[user objectForKey:kUserFieldNameKey];
    //NSString *location = (NSString*)[user objectForKey:kUserFieldLocationKey];
    
    NSLog(@"Loading user %@", name);
    
    if (name != nil) self.userNameLabel.text = name;

    
    self.userProfileImage.file = (PFFile*)[user objectForKey:kUserFieldProfileImageKey];
    [self.userProfileImage loadInBackground];
}

@end
