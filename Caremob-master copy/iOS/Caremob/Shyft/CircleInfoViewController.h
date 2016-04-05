//
//  CircleInfoViewController.h
//  Shyft
//
//  Created by Rick Strom on 11/18/14.
//  Copyright (c) 2014 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CareMobConstants.h"
#import "PlayMomentViewController.h"
#import "KTCenterFlowLayout.h"

// Destination View Controllers
#import "RecordMomentOfSilenceViewController.h"
#import "SocialShareViewController.h"

// Collection View Cells
#import "CircleActionCollectionViewCell.h"

@interface CircleInfoViewController : UIViewController
@property (nonatomic, strong) PFObject *circle;
@property (nonatomic, strong) PFObject *circleAction;
@property (nonatomic, assign) int totalFriendsInCircle;
@property (nonatomic, strong) NSDate *pressStartTime;
@property (nonatomic, assign) float totalTime;
@property (nonatomic, strong) NSArray *circleActions;

@property (nonatomic, assign) BOOL fingerIsDown;
@property (nonatomic, assign) float timeAccumulator;
@property (nonatomic, assign) CGRect progressFillTopRect;
@property (nonatomic, assign) CGRect progressFillBottomRect;

-(void)showInteractionView;
-(void)hideInteractionView;
-(void)showShareView;
-(void)hideShareView;
@end
