//
//  Follow_GenericUserTableViewCell.m
//  Caremob
//
//  Created by Rick Strom on 10/13/15.
//  Copyright © 2015 Rick Strom. All rights reserved.
//

#import "Follow_GenericUserTableViewCell.h"

@implementation Follow_GenericUserTableViewCell

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
    } else  {
        NSLog(@"Image was nil!");
        /*
        UIImage *image = [UIImage imageNamed:@"defaultCirclImageLarge"];
        PFFile *defaultImage = [PFFile fileWithData:UIImagePNGRepresentation(image)];
        
        self.userImageView.file = defaultImage;
        [self.userImageView loadInBackground];
         */
        self.userImageView.image = [UIImage imageNamed:@"default_user_image45"];
    }
    
    NSString *name = (NSString*)[user objectForKey:kUserFieldNameKey];
    if (name != nil) self.userNameLabel.text = name;
    else self.userNameLabel.text = @"";
    
    NSNumber *didSetUsername = (NSNumber*)[user objectForKey:kUserFieldDidSetUsernameKey];
    if (didSetUsername == nil || [didSetUsername boolValue] == NO) self.userUsernameLabel.text = @"";
    else {
        NSString *username = (NSString*)[user objectForKey:kUserFieldUsernameKey];
        if (username != nil) self.userUsernameLabel.text = username;
        else self.userUsernameLabel.text = @"";
    }

}
@end
