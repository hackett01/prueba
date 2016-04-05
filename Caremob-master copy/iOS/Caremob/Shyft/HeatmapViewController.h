//
//  HeatmapViewController.h
//  Caremob
//
//  Created by Rick Strom on 9/1/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeatmapMobberPinViewController.h"
#import "HeatmapUserPinViewController.h"

@interface HeatmapViewController : UIViewController

@property (nonatomic,strong) HeatmapUserPinViewController *currentUserPin;
@property (nonatomic, strong) NSMutableArray *userPins;

-(void)addUserPin:(PFObject*)user atLatitude:(double)latitude andLongitude:(double)longitude isCurrentUser:(BOOL)isCurrentUser;
-(void)removeCurrentUserPin;
-(void)showUserPinsForMobActionFootprints:(NSArray*)mobActionFootprints;
-(void)showHeatForMobActions:(NSArray*)mobActions withMobType:(NSString*)mobType;
-(UIImage*)getFlattenedImage;
@end
