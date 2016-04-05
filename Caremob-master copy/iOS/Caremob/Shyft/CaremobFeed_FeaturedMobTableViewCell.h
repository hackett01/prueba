//
//  CaremobFeed_FeaturedMobTableViewCell.h
//  Caremob
//
//  Created by Rick Strom on 9/21/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "CareMobConstants.h"
#import "CareMobHelper.h"
#import "NSDate+DateTools.h"

@interface CaremobFeed_FeaturedMobTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *caremobImageView;
@property (weak, nonatomic) IBOutlet UIImageView *caremobCategoryImageView;
@property (weak, nonatomic) IBOutlet UILabel *caremobCategoryLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalMobActionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMobActionValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobLevelLabel;

@property (weak, nonatomic) IBOutlet UILabel *caremobTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *caremobSourceLabel;


@property (weak, nonatomic) IBOutlet UIButton *caremobSourceIconButton;
@property (weak, nonatomic) IBOutlet UIButton *caremobSourceUserIconButton;
@property (weak, nonatomic) IBOutlet PFImageView *caremobSourceUserImageView;


- (IBAction)caremobSourceIconButtonHit:(id)sender;
- (IBAction)caremobSourceUserIconButtonHit:(id)sender;


//@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *trendingPointsMeterImageViews;

@property (weak, nonatomic) PFObject *careMob;

@property (nonatomic, strong) NSString *categoryContext;

-(void)initializeWithCareMob:(PFObject*)careMob andCategoryContext:(NSString*)categoryContext andRank:(int)rank andLevel:(int)level andMembers:(int)members andTotalValue:(double)totalValue andEffectivePoints:(float)effectivePoints;
@end
