//
//  CaremobUserList_GenericUserTableViewCell.m
//  Caremob
//
//  Created by Rick Strom on 10/23/15.
//  Copyright © 2015 Rick Strom. All rights reserved.
//

#import "CaremobUserList_GenericUserTableViewCell.h"

@implementation CaremobUserList_GenericUserTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setUser:(PFObject*)user {
    PFFile *userImage = (PFFile*)[user objectForKey:kUserFieldProfileImageKey];
    if (userImage != nil) {
        self.userImageView.file = userImage;
        [self.userImageView loadInBackground];
    }
    
    NSString *name = (NSString*)[user objectForKey:kUserFieldNameKey];
    if (name != nil) self.userNameLabel.text = name;
    else self.userNameLabel.text = @"";
}

@end
