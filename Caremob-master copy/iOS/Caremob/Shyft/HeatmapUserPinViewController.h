//
//  HeatmapUserPinViewController.h
//  Caremob
//
//  Created by Rick Strom on 9/2/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "CareMobConstants.h"
#import "SoundManager.h"
@interface HeatmapUserPinViewController : UIViewController
@property (strong, nonatomic) PFObject *user;
@property (assign, nonatomic) BOOL isCurrentUser;

-(void)initializeWithUser:(PFObject*)user isCurrentUser:(BOOL)isCurrentUser;
-(void)hideAndRemoveFromSuperview;
@end
