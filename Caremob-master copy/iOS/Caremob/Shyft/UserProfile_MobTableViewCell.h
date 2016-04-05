//
//  UserProfile_MobTableViewCell.h
//  Caremob
//
//  Created by Rick Strom on 10/20/15.
//  Copyright © 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "CareMobConstants.h"
#import "CareMobHelper.h"

@interface UserProfile_MobTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *caremobImageView;
@property (weak, nonatomic) IBOutlet UILabel *caremobTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *caremobSourceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *caremobCategoryIcon;
@property (weak, nonatomic) IBOutlet UILabel *mobActionValueLabel;


@property (nonatomic, strong) NSString *categoryContext;

-(void)initializeWithCareMob:(PFObject*)careMob andCategoryContext:(NSString*)categoryContext andMobActionValue:(NSNumber*)mobActionValue;
@end
