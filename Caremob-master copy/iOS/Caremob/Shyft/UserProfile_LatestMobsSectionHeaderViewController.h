//
//  UserProfile_LatestMobsSectionHeaderViewController.h
//  Caremob
//
//  Created by Rick Strom on 10/20/15.
//  Copyright © 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfile_LatestMobsSectionHeaderViewController : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *sectionTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sectionHeaderBackgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@end
