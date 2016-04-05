//
//  CircleActionCollectionViewCell.h
//  Shyft
//
//  Created by Rick Strom on 2/4/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CareMobConstants.h"

@interface CircleActionCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *circleFriendOverlayImageView;
@property (weak, nonatomic) IBOutlet UIImageView *circleUserImageView;

@property (nonatomic, strong) NSArray *userList;
@property (nonatomic, assign) float delay;
@property (nonatomic, assign) float showTime;
@property (nonatomic, assign) int currentUserIndex;
@property (nonatomic, assign) BOOL isShowing;

-(void)initializeWithUsers:(NSArray*)userList andDelay:(float)delay andShowTime:(float)showTime;
-(void)showNewUser;
-(void)show;
-(void)hide;
@end
