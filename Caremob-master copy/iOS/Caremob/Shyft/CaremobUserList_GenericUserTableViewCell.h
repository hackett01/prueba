//
//  CaremobUserList_GenericUserTableViewCell.h
//  Caremob
//
//  Created by Rick Strom on 10/23/15.
//  Copyright © 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "CareMobConstants.h"

@interface CaremobUserList_GenericUserTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet PFImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *valueIcon;

-(void)setUser:(PFObject*)user;

@end
