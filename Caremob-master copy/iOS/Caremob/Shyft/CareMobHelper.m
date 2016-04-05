//
//  CareMobHelper.m
//  Shyft
//
//  Created by Rick Strom on 2/7/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import "CareMobHelper.h"

@implementation CareMobHelper
+(void)setUser:(PFUser*)follower following:(PFUser*)followed active:(BOOL)active {

}

/*
+(double)mobActionTimeRequiredForPoints:(int)points {
    int multiplier = 0;
    
    for (int i = 1; i <= points; i++) {
        multiplier += i;
    }
    
    return kMobActionPointsTimeIncrement * (double)multiplier;
}
*/

/*
+(int)mobActionPointsForTime:(double)time {
    int points = 0;
    
    while (points < HUGE_VAL) {
        if ([CareMobHelper mobActionTimeRequiredForPoints:points] > time) return points - 1;
        points++;
    }
    
    return -1;
}
*/

+(NSDictionary*)sortCareMobArray:(NSArray*)careMobs intoCategoriesSortedBy:(NSString*)sortType {
    NSArray *categoryList = kSubMobCategoryList;
    
    NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
    
    if (careMobs == nil || careMobs.count == 0) return resultDict;
    
    // First get the top mobs
    NSArray *topMobs = [careMobs sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        PFObject *mob1 = (PFObject*)obj1;
        PFObject *mob2 = (PFObject*)obj2;
        
        if ([sortType isEqualToString:kCareMobSortTypeTop]) {
            NSNumber *points1 = [mob1 objectForKey:kCareMobPointsKey];
            NSNumber *points2 = [mob2 objectForKey:kCareMobPointsKey];
            
            if ([points1 floatValue] < [points2 floatValue]) return NSOrderedDescending;
            else if ([points1 floatValue] > [points2 floatValue]) return NSOrderedAscending;
            else return NSOrderedSame;
        } else if ([sortType isEqualToString:kCareMobSortTypeTrending]) {
            NSNumber *effectivePoints1 = [mob1 objectForKey:kCareMobEffectivePointsKey];
            NSNumber *effectivePoints2 = [mob2 objectForKey:kCareMobEffectivePointsKey];
            
            if ([effectivePoints1 floatValue] < [effectivePoints2 floatValue]) return NSOrderedDescending;
            else if ([effectivePoints1 floatValue] > [effectivePoints2 floatValue]) return NSOrderedAscending;
            else return NSOrderedSame;
        } else {
            NSNumber *todayPoints1 = [mob1 objectForKey:kCareMobTodayPointsKey];
            NSNumber *todayPoints2 = [mob2 objectForKey:kCareMobTodayPointsKey];
            
            if ([todayPoints1 floatValue] < [todayPoints2 floatValue]) return NSOrderedDescending;
            else if ([todayPoints1 floatValue] > [todayPoints2 floatValue]) return NSOrderedAscending;
            else return NSOrderedSame;
        }
    }];
    
    resultDict[@"topMobs"] = topMobs;
    
    // Next loop through the mobs and sort out each submob grouping
    for (NSString *category in categoryList) {
        NSMutableArray *prunedCareMobs = [[NSMutableArray alloc] init];
        
        // First prune the list to only include CareMobs with a SubMob matching the category with points > 0
        for (int i = 0; i < careMobs.count; i++) {
            PFObject *careMob = (PFObject*)careMobs[i];
            NSArray *subMobs = (NSArray*)[careMob objectForKey:kCareMobSubMobsKey];
            BOOL careMobHasActiveCategory = NO;
            
            for (int j = 0; j <  subMobs.count; j++) {
                PFObject *subMob = (PFObject*)subMobs[j];
                if ([[subMob objectForKey:kSubMobCategoryKey] isEqualToString:category]) {
                    NSNumber *points = [subMob objectForKey:kSubMobPointsKey];
                
                    if (points != nil && [points intValue] > 0) {
                        careMobHasActiveCategory = YES;
                        break;
                    }
                }
            }
            
            if (careMobHasActiveCategory) {
                //NSLog(@"When looking at category %@ we found CareMob with title %@", category, (NSString*)[careMob objectForKey:kCareMobTitleKey]);
                [prunedCareMobs insertObject:careMob atIndex:0];
            }
        }
        
        //NSLog(@"After pruning, we have %d caremobs", (int)prunedCareMobs.count);
        
        // Now that prunedCareMobs only contains CareMobs with an active SubMob matching the current category, we can sort THAT array to get the top submobs
        NSArray *topCategoryMobs =  [prunedCareMobs sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            PFObject *mob1 = (PFObject*)obj1;
            PFObject *mob2 = (PFObject*)obj2;

            NSArray *subMobs1 = (NSArray*)[mob1 objectForKey:kCareMobSubMobsKey];
            NSArray *subMobs2 = (NSArray*)[mob2 objectForKey:kCareMobSubMobsKey];
            
            // Grab the submobs as well
            PFObject *subMob1 = nil;
            PFObject *subMob2 = nil;
            
            for (int j = 0; j <  subMobs1.count; j++) {
                PFObject *subMob = (PFObject*)subMobs1[j];
                if ([[subMob objectForKey:kSubMobCategoryKey] isEqualToString:category]) {
                    subMob1 = subMob;
                    break;
                }
            }

            for (int j = 0; j <  subMobs2.count; j++) {
                PFObject *subMob = (PFObject*)subMobs2[j];
                if ([[subMob objectForKey:kSubMobCategoryKey] isEqualToString:category]) {
                    subMob2 = subMob;
                    break;
                }
            }
            
            // Handle nil submobs here just in case!
            if (subMob1 == nil && subMob2 != nil) return NSOrderedDescending;
            else if (subMob1 != nil && subMob2 == nil) return NSOrderedAscending;
            else if (subMob1 == nil && subMob2 == nil) return NSOrderedSame;
            
            // Now properly sort these caremobs by looking at the points for the submob
            if ([sortType isEqualToString:kCareMobSortTypeTop]) {
                NSNumber *points1 = [subMob1 objectForKey:kCareMobPointsKey];
                NSNumber *points2 = [subMob2 objectForKey:kCareMobPointsKey];
                
                if ([points1 floatValue] < [points2 floatValue]) return NSOrderedDescending;
                else if ([points1 floatValue] > [points2 floatValue]) return NSOrderedAscending;
                else return NSOrderedSame;
            } else if ([sortType isEqualToString:kCareMobSortTypeTrending]) {
                NSNumber *effectivePoints1 = [subMob1 objectForKey:kCareMobEffectivePointsKey];
                NSNumber *effectivePoints2 = [subMob2 objectForKey:kCareMobEffectivePointsKey];
                
                if ([effectivePoints1 floatValue] < [effectivePoints2 floatValue]) return NSOrderedDescending;
                else if ([effectivePoints1 floatValue] > [effectivePoints2 floatValue]) return NSOrderedAscending;
                else return NSOrderedSame;
            } else {
                NSNumber *todayPoints1 = [subMob1 objectForKey:kCareMobTodayPointsKey];
                NSNumber *todayPoints2 = [subMob2 objectForKey:kCareMobTodayPointsKey];
                
                if ([todayPoints1 floatValue] < [todayPoints2 floatValue]) return NSOrderedDescending;
                else if ([todayPoints1 floatValue] > [todayPoints2 floatValue]) return NSOrderedAscending;
                else return NSOrderedSame;
            }

        }];
        
        resultDict[[NSString stringWithFormat:@"top%@Mobs", category]] = topCategoryMobs;
    }
    
    return resultDict;
}

// The following methods mirror backend methods for calculating points/level for MobActions, SubMobs and Caremobs
// They should only be used for pre-calculating what will be done in Parse after saving MobAction objects
// User time, points and level calculations
+(int)calculateMobActionPointsForTime:(float)time {
    int points = 0;
    
    while (points < 10000000) {
        if ([CareMobHelper calculateMobActionTimeToPoints:points] > time) return points - 1;
        points++;
    }
    
    return -1;
}

+(float)calculateMobActionTimeToPoints:(int)points {
    float b = 5.0;
    
    float multiplier = 0.0;
    
    for (int i = 1; i <= points; i++) {
        multiplier += (float)i;
    }
    
    return b * multiplier;
}

+(int)calculateUserLevelForPoints:(int)points {
    int level = 0;
    
    while  (level < 10000000) {
        if ([CareMobHelper calculateUserPointsRequiredForLevel:level] > points) return level - 1;
        level++;
    }
    
    return -1;

}

+(int)calculateUserPointsRequiredForLevel:(int)level {
    if (level == 0) return 0;
    
    float a = 5.0;
    float e = 1.14;
    float m = 1.0;
    float b = -4.0;
    
    //int points = (int)floor(pow(e,level)) + (int)(m * level) + b;
    int points = (int)floor(a*pow(e,(float)level) + (m * (float)level * (float)level) + b);
    
    return points;
}

// CareMob points and level calculations
+(int)calculateCareMobLevelForPoints:(int)points {
    int level = 0;
    
    while  (level < 10000000) {
        if ([CareMobHelper calculateCareMobPointsRequiredForLevel:level] > points) return level - 1;
        level++;
    }
    
    return -1;

}

+(int)calculateCareMobPointsRequiredForLevel:(int)level {
    if (level == 0) return 0;
    
    float a = 5.0;
    float e = 1.14;
    float m = 1.0;
    float b = -4.0;
    
    //int points = (int)floor(pow(e,level)) + (int)(m * level) + b;
    int points = (int)floor(a*pow(e,(float)level) + (m * (float)level * (float)level) + b);
    
    return points;
}

// SubMob points and level calculations
+(int)calculateSubMobLevelForPoints:(int)points {
    int level = 0;
    
    while  (level < 10000000) {
        if ([CareMobHelper calculateSubMobPointsRequiredForLevel:level] > points) return level - 1;
        level++;
    }
    
    return -1;
}

+(int)calculateSubMobPointsRequiredForLevel:(int)level {
    if (level == 0) return 0;
    
    float a = 5.0;
    float e = 1.14;
    float m = 1.0;
    float b = -4.0;
    
    //int points = (int)floor(pow(e,level)) + (int)(m * level) + b;
    int points = (int)floor(a*pow(e,(float)level) + (m * (float)level * (float)level) + b);
    
    return points;
}

// feed source string formatters
+(NSString*)feedSourceValueToPrintableString:(NSString*)feed {
    if ([feed isEqualToString:@"cnn"])
        return @"CNN";
    else if ([feed isEqualToString:@"theguardian"])
        return @"The Guardian";
    else if ([feed isEqualToString:@"aljazeera"])
        return @"Al Jazeera";
    else if ([feed isEqualToString:@"foxnews"])
        return @"Fox News";
    else if ([feed isEqualToString:@"huffingtonpost"])
        return @"Huffington Post";
    else if ([feed isEqualToString:@"humanrightswatch"])
        return @"Human Rights Watch";
    else if ([feed isEqualToString:@"abcnews"])
        return @"ABC News";
    else if ([feed isEqualToString:@"positivenews"])
        return @"Positive News";
    else if ([feed isEqualToString:@"dailynebraskan"])
        return @"The Daily Nebraskan";
    else if ([feed isEqualToString:@"unl"])
        return @"University of Nebraska";
    else if ([feed isEqualToString:@"sunnyskyz"])
        return @"Sunny Skyz";
    else
        return @"other";
    
}

+(NSString*)feedSourceValueToIconName:(NSString*)feed {
    if ([feed isEqualToString:@"cnn"])
        return @"cnnLogo";
    else if ([feed isEqualToString:@"theguardian"])
        return @"theguardianLogo";
    else if ([feed isEqualToString:@"aljazeera"])
        return @"aljazeeraLogo";
    else if ([feed isEqualToString:@"foxnews"])
        return @"foxnewsLogo";
    else if ([feed isEqualToString:@"huffingtonpost"])
        return @"huffingtonpostLogo";
    else if ([feed isEqualToString:@"humanrightswatch"])
        return @"humanrightswatchLogo";
    else if ([feed isEqualToString:@"abcnews"])
        return @"abcnewsLogo";
    else if ([feed isEqualToString:@"positivenews"])
        return @"positivenewsLogo";
    else if ([feed isEqualToString:@"dailynebraskan"])
        return @"dailynebraskanLogo";
    else if ([feed isEqualToString:@"unl"])
        return @"unlLogo";
    else if ([feed isEqualToString:@"sunnyskyz"])
        return @"sunnyskyzLogo";
    else
        return @"otherLogo";
    
}

+(NSString*)feedSourceDescriptionString:(NSString*)feed {
    if ([feed isEqualToString:@"cnn"])
        return @"is among the world's leaders in online news and information delivery.";
    else if ([feed isEqualToString:@"theguardian"])
        return @"is among the world's leaders in online news and information delivery.";
    else if ([feed isEqualToString:@"aljazeera"])
        return @"Al Jazeera America is an American basic cable and satellite news television channel.";
    else if ([feed isEqualToString:@"foxnews"])
        return @"is among the world's leaders in online news and information delivery.";
    else if ([feed isEqualToString:@"huffingtonpost"])
        return @"is among the world's leaders in online news and information delivery.";
    else if ([feed isEqualToString:@"humanrightswatch"])
        return @"HRW is an international non-governmental organization that conducts research and advocacy on human rights.";
    else if ([feed isEqualToString:@"abcnews"])
        return @"ABC provides breaking news, broadcast video coverage, and exclusive interviews.";
    else if ([feed isEqualToString:@"positivenews"])
        return @"Positive News is the world’s first publication dedicated to reporting positive developments﻿.";
    else if ([feed isEqualToString:@"dailynebraskan"])
        return @"The Daily Nebraskan is the independent student news source of the University of Nebraska–Lincoln.";
    else if ([feed isEqualToString:@"unl"])
        return @"UNL Today is the official news source of the University of Nebraska–Lincoln.";
    else if ([feed isEqualToString:@"sunnyskyz"])
        return @"is among the world's leaders in online news and information delivery.";
    else
        return @"is among the world's leaders in online news and information delivery.";
}

// Helper methods
+(NSString*)timeToString:(double)time {
    
    NSString *timeString;
    
    int days = 0;
    int hours = 0;
    int minutes = 0;
    int seconds = 0;
    
    days = (int)time / 84600;
    time -= 84600 * days;
    
    hours = (int)time / 3600;
    time -= 3600 * hours;
    
    minutes = (int)time / 60;
    time -= 60 * minutes;
    
    seconds = (int)time;
    
    if (days > 0) timeString = [NSString stringWithFormat:@"%dd %dh", days, hours];
    else if (hours > 0) timeString = [NSString stringWithFormat:@"%dh %dm", hours, minutes];
    else if (minutes > 0) timeString = [NSString stringWithFormat:@"%dm %ds", minutes, seconds];
    else timeString = [NSString stringWithFormat:@"%ds", seconds];
    
    return timeString;
}

+(NSString*)getTopCategoryForCareMob:(PFObject*)careMob {
    NSString *categoryContext = nil;
    
    int points = 0;
    PFObject *topSubMob = nil;
    NSArray *subMobs = (NSArray*)[careMob objectForKey:kCareMobSubMobsKey];
    
    if (subMobs != nil) {
        for (int i = 0; i < subMobs.count; i++) {
            PFObject *s = (PFObject*)subMobs[i];
            if (s != nil) {
                // TODO: actually look for the relevant points type here (trending, today, all time)
                NSNumber *sPts = (NSNumber*)[s objectForKey:kSubMobEffectivePointsKey];
                NSString *sCat = (NSString*)[s objectForKey:kSubMobCategoryKey];
                
                if ([sPts intValue] > points || topSubMob == nil) {
                    topSubMob = s;
                    points = [sPts intValue];
                    categoryContext = sCat;
                }
            }
        }
    }
    
    return categoryContext;
}

+(NSArray*)aggregateActivityArray:(NSArray*)activityArray {
    if (activityArray == nil) return [[NSArray alloc] init];
    
    NSMutableArray *newActivityArray = [[NSMutableArray alloc] init];
    
    // NOTES:
    // We will run through the activity array and process all activity with type kActivityTypeUserEnteredSubMob
    // If the numberValue is null, then we run through the remaining items looking for similar activity and when we find one, we:
    // a. increment the numberValue for the item and
    // b. set the future items' numberValue to -1 (meaning, skip them when rebuilding the array)
    for (int i = 0; i < activityArray.count; i++) {
        PFObject *activity = (PFObject*)activityArray[i];
        NSString *type = (NSString*)[activity objectForKey:kActivityFieldTypeKey];
        if (type == nil) continue;
        
        if ([type isEqualToString:kActivityTypeUserEnteredSubMob]) {
            NSNumber *numberValue = (NSNumber*)[activity objectForKey:kActivityFieldNumberValueKey];
            PFObject *subMob = (PFObject*)[activity objectForKey:kActivityFieldTargetSubMobKey];
            
            if (numberValue == nil) {
                // Run through the rest of the array and count those matching type and submob
                int count = 0;
                
                for (int j = i; j < activityArray.count; j++) {
                    if (j == i) continue;
                    
                    PFObject *nextActivity = (PFObject*)activityArray[j];
                    NSString *nextType = (NSString*)[nextActivity objectForKey:kActivityFieldTypeKey];
                    if ([nextType isEqualToString:kActivityTypeUserEnteredSubMob]) {
                        PFObject *nextSubMob = (PFObject*)[nextActivity objectForKey:kActivityFieldTargetSubMobKey];
                        
                        if (subMob != nil && nextSubMob != nil && [subMob.objectId isEqualToString:nextSubMob.objectId]) {
                            count++;
                            [nextActivity setObject:[NSNumber numberWithInt:-1] forKey:kActivityFieldNumberValueKey];
                        }
                    }
                }
                
                [activity setObject:[NSNumber numberWithInt:count] forKey:kActivityFieldNumberValueKey];
                [newActivityArray addObject:activity];
            } else {
                // Skip it
            }
        } else {
            // We are not concernerd with this type of activity, so just add it to the array
            [newActivityArray addObject:activity];
        }
    }

    return [NSArray arrayWithArray:newActivityArray];
}
@end
