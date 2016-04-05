//
//  UserLevelControlViewController.h
//  Caremob
//
//  Created by Rick Strom on 6/1/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "CareMobConstants.h"
#import "MCPercentageDoughnutView.h"

@interface UserLevelControlViewController : UIViewController
@property (weak, nonatomic) IBOutlet PFImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
//@property (nonatomic, assign) float count;
@property (nonatomic, assign) int points;
@property (nonatomic, assign) int level;
@property (nonatomic, assign) int pointsToCurrentLevel;
@property (nonatomic, assign) int pointsToNextLevel;

@property (weak, nonatomic) IBOutlet MCPercentageDoughnutView *FGProgressView;

-(void)setFrameRelativeTo:(UIView*)view;
-(void)initialize;
-(void)userNeedsRefresh;
@end
