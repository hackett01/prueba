//
//  CareMobHelper.h
//  Shyft
//
//  Created by Rick Strom on 2/7/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import "CareMobConstants.h"

// TODO: in next phase, move common methods (like follow, etc) to this helper class

@interface CareMobHelper : NSObject
+(void)setUser:(PFUser*)follower following:(PFUser*)followed active:(BOOL)active;

//+(double)mobActionTimeRequiredForPoints:(int)points;
//+(int)mobActionPointsForTime:(double)time;
+(NSDictionary*)sortCareMobArray:(NSArray*)careMobs intoCategoriesSortedBy:(NSString*)sortType;

// The following methods mirror backend methods for calculating points/level for MobActions, SubMobs and Caremobs
// They should only be used for pre-calculating what will be done in Parse after saving MobAction objects
// User time, points and level calculations
+(int)calculateMobActionPointsForTime:(float)time;
+(float)calculateMobActionTimeToPoints:(int)points;
+(int)calculateUserLevelForPoints:(int)points;
+(int)calculateUserPointsRequiredForLevel:(int)level;

// CareMob points and level calculations
+(int)calculateCareMobLevelForPoints:(int)points;
+(int)calculateCareMobPointsRequiredForLevel:(int)level;

// SubMob points and level calculations
+(int)calculateSubMobLevelForPoints:(int)points;
+(int)calculateSubMobPointsRequiredForLevel:(int)level;

// feed source string formatters
+(NSString*)feedSourceValueToPrintableString:(NSString*)feed;
+(NSString*)feedSourceValueToIconName:(NSString*)feed;
+(NSString*)feedSourceDescriptionString:(NSString*)feed;

// Helper methods
+(NSString*)timeToString:(double)time;
+(NSString*)getTopCategoryForCareMob:(PFObject*)careMob;
+(NSArray*)aggregateActivityArray:(NSArray*)activityArray;

@end
