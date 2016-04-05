//
//  ShyftConstants.h
//  Shyft
//
//  Created by Rick Strom on 11/14/14.
//  Copyright (c) 2014 Rick Strom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CareMobConstants : NSObject

#pragma mark - Default SubMob Categories

#define kSubMobCategoryList @[@"peace",@"protest",@"mourning",@"empathy",@"celebration",@"support"]

#pragma mark - CareMob sort type

#define kCareMobSortTypeTop @"top"
#define kCareMobSortTypeTrending @"trending"
#define kCareMobSortTypeTopToday @"topToday"

#pragma mark - NSUserDefaults 

#define kNSUserDefaultsUserPoints                   @"userPoints"
#define kNSUserDefaultsUserLevel                    @"userLevel"
#define kNSUserDefaultsUserPointsToCurrentLevel     @"userPointsToCurrentLevel"
#define kNSUserDefaultsUserPointsToNextLevel        @"userPointsToNextLevel"
#define kNSUserDefaultsTutorialWasShown             @"tutorialWasShown"
#define kNSUserDefaultsUpfrontTutorialWasShown      @"upfrontTutorialWasShown"
#define kNSUserDefaultsCreateMobTutorialWasShown    @"createMobTutorialWasShown"
#define kNSUserDefaultsLastRetrievedActivity        @"lastRetrievedActivity"

#pragma mark - NSNotification

#define kNSNotificationMobActionWasPerformed        @"mobActionWasPerformed"
#define kNSNotificationNewActivityIsAvailable       @"newActivityIsAvailable"
#define kNSNotificationShouldShowActivityTab        @"shouldShowActivityTab"
#define kNSNotificationUserDidChange                @"userDidChange"

#pragma mark - Sounds

#define kSoundApplicationLaunch                     @"CM_application_launch.mp3"
#define kSoundHeatmapUserEnter                      @"CM_heatmap_user_enter.mp3"
#define kSoundHeatmapUserLeave                      @"CM_heatmap_user_leave.mp3"
#define kSoundNotificationAlert                     @"CM_notification_alert.mp3"
#define kSoundPointsCollected                       @"CM_points_collected.mp3"
#define kSoundThumbDown                             @"CM_thumb_down.mp3"
#define kSoundThumbUp                               @"CM_thumb_up.mp3"

#pragma mark - Caremob Display Constants

#define kCaremobDisplayModeNoCategory 0
#define kCaremobDisplayModeWaitingForCategorySelect 1
#define kCaremobDisplayModeReadyToJoin 2

#pragma mark - Caremob Leveling and Mob Action Points Constants

#define kMobActionPointsTimeIncrement 5.0

#pragma mark - Parse Cloud Functions

// Get user points and level
extern NSString *const kCloudFunctionGetUserPointsAndLevelKey;

extern NSString *const kCloudFunctionGetUserPointsAndLevelResultPoints;
extern NSString *const kCloudFunctionGetUserPointsAndLevelResultLevel;
extern NSString *const kCloudFunctionGetUserPointsAndLevelResultPointsToCurrentLevel;
extern NSString *const kCloudFunctionGetUserPointsAndLevelResultPointsToNextLevel;
extern NSString *const kCloudFunctionGetUserPointsAndLevelResultPoints;

// Redeem points
extern NSString *const kCloudFunctionRedeemPointsKey;

extern NSString *const kCloudFunctionRedeemPointsActivity;

// Notify user's facebook friends that they joined
extern NSString *const kCloudFunctionNotifyUsersFacebookFriendsOfSignupKey;

// Create a caremob from a given feed story
extern NSString *const kCloudFunctionCreateCareMobFromFeedStoryKey;

extern NSString *const kCloudFunctionCreateCareMobFromFeedStoryParamFeedStoryId;

// Get the submob point totals for a given user
extern NSString *const kCloudFunctionGetUserSubmobPointTotalsKey;

extern NSString *const kCloudFunctionGetUserSubmobPointTotalsParamUserObjectId;

// Get rank for a given user
extern NSString *const kCloudFunctionGetUserRankKey;

extern NSString *const kCloudFunctionGetUserRankParamUserObjectId;
extern NSString *const kCloudFunctionGetUserRankParamUserPoints;


#pragma mark - Parse Data Model

#pragma mark User
extern NSString *const kUserClassKey;

extern NSString *const kUserFieldObjectIdKey;
extern NSString *const kUserFieldCreatedAtKey;
extern NSString *const kUserFieldDidSetUsernameKey;
extern NSString *const kUserFieldProfileImageKey;
extern NSString *const kUserFieldNameKey;
extern NSString *const kUserFieldUsernameKey;
extern NSString *const kUserFieldPasswordKey;
extern NSString *const kUserFieldEmailKey;
extern NSString *const kUserFieldLocationKey;
extern NSString *const kUserFieldFacebookUserIdKey;
extern NSString *const kUserFieldFacebookFriendsKey;
extern NSString *const kUserFieldFollowerCountKey;
extern NSString *const kUserFieldFollowingCountKey;
//extern NSString *const kUserFieldTotalCircleActions;
//extern NSString *const kUserFieldTotalCirclesCreated;
extern NSString *const kUserFieldPointsKey;
extern NSString *const kUserFieldLevelKey;
extern NSString *const kUserFieldEffectivePointsKey;
extern NSString *const kUserFieldTodayPointsKey;
extern NSString *const kUserFieldInfluenceKey;
extern NSString *const kUserFieldEffectiveInfluenceKey;
extern NSString *const kUserFieldTodayInfluenceKey;
extern NSString *const kUserFieldRankKey;
extern NSString *const kUserFieldCaremobsCreatedKey;
extern NSString *const kUserFieldSubMobsStartedKey;
//extern NSString *const kUserFieldMobActionsCreatedKey;
extern NSString *const kUserFieldTotalMobActionsKey;
extern NSString *const kUserFieldTotalMobActionValueKey;
extern NSString *const kUserFieldTotalMobActionValueTodayKey;

#pragma mark CareMob
extern NSString *const kCareMobClassKey;

extern NSString *const kCareMobObjectIdKey;
extern NSString *const kCareMobCreatedAtKey;

extern NSString *const kCareMobCreatedByKey;
extern NSString *const kCareMobHiddenKey;
extern NSString *const kCareMobFeaturedKey;
extern NSString *const kCareMobImageKey;
extern NSString *const kCareMobImagesKey;
extern NSString *const kCareMobVideosKey;
extern NSString *const kCareMobTitleKey;
extern NSString *const kCareMobCategoryKey;
extern NSString *const kCareMobOriginalCategoryKey;
extern NSString *const kCareMobLongTextKey;
extern NSString *const kCareMobShortTextKey;
extern NSString *const kCareMobUrlKey;
extern NSString *const kCareMobSourceKey;
extern NSString *const kCareMobSourceUserKey;
extern NSString *const kCareMobSubMobsKey;

extern NSString *const kCareMobTotalMobRankScoreKey;
extern NSString *const kCareMobPointsKey;
extern NSString *const kCareMobLevelKey;
extern NSString *const kCareMobEffectivePointsKey;
extern NSString *const kCareMobTodayPointsKey;
extern NSString *const kCareMobHighMobRankScoreKey;
extern NSString *const kCareMobHighMobRankKey;

#pragma mark SubMob
extern NSString *const kSubMobClassKey;

extern NSString *const kSubMobObjectIdKey;
extern NSString *const kSubMobCreatedAtKey;

extern NSString *const kSubMobCategoryKey;
extern NSString *const kSubMobTotalMobActionValueKey;
extern NSString *const kSubMobTotalMobActionsKey;
extern NSString *const kSubMobPointsKey;
extern NSString *const kSubMobLevelKey;
extern NSString *const kSubMobEffectivePointsKey;
extern NSString *const kSubMobTodayPointsKey;


#pragma mark MobAction
extern NSString *const kMobActionClassKey;

extern NSString *const kMobActionObjectIdKey;
extern NSString *const kMobActionCreatedAtKey;
extern NSString *const kMobActionUpdatedAtKey;

extern NSString *const kMobActionCareMobKey;
extern NSString *const kMobActionSubMobKey;
extern NSString *const kMobActionUserKey;
extern NSString *const kMobActionValueKey;
extern NSString *const kMobActionPointsKey;
extern NSString *const kMobActionLocationKey;
extern NSString *const kMobActionFollowingUserKey;

#pragma mark MobActionFootprint
extern NSString *const kMobActionFootprintClassKey;

extern NSString *const kMobActionFootprintObjectIdKey;
extern NSString *const kMobActionFootprintCreatedAtKey;
extern NSString *const kMobActionFootprintUpdatedAtKey;

extern NSString *const kMobActionFootprintCareMobKey;
extern NSString *const kMobActionFootprintSubMobKey;
extern NSString *const kMobActionFootprintUserKey;
extern NSString *const kMobActionFootprintLocationKey;

#pragma mark MobCategory
extern NSString *const kMobCategoryClassKey;

extern NSString *const kMobCategoryObjectIdKey;
extern NSString *const kMobCategoryCreatedAtKey;

extern NSString *const kMobCategoryTypeKey;
extern NSString *const kMobCategoryActionTypeKey;
extern NSString *const kMobCategoryLevelKey;
extern NSString *const kMobCategoryTotalActionValueKey;
extern NSString *const kMobCategoryTotalUsersKey;
extern NSString *const kMobCategoryTotalUnityPointsKey;

#pragma mark Activity
extern NSString *const kActivityClassKey;

extern NSString *const kActivityFieldCreatedAtKey;
extern NSString *const kActivityFieldTypeKey;
extern NSString *const kActivityFieldUserKey;
extern NSString *const kActivityFieldNumberValueKey;
extern NSString *const kActivityFieldStringValueKey;
extern NSString *const kActivityFieldTargetUserKey;
extern NSString *const kActivityFieldTargetCareMobKey;
extern NSString *const kActivityFieldTargetSubMobKey;
extern NSString *const kActivityFieldTargetMobActionKey;
extern NSString *const kActivityFieldTargetMobCategoryKey;
extern NSString *const kActivityFieldTargetRedeemablePointsKey;

extern NSString *const kActivityTypeFollow;
extern NSString *const kActivityTypeCareMobLeveledUp;
extern NSString *const kActivityTypeSubMobLeveledUp;
extern NSString *const kActivityTypeUserLeveledUp;
extern NSString *const kActivityTypeUserJoined;
extern NSString *const kActivityTypeUserFollowed;
extern NSString *const kActivityTypeUserFollowedIntoSubMob;
extern NSString *const kActivityTypeUserEnteredSubMob;
extern NSString *const kActivityTypeUserCreatedCareMob;

#pragma mark RedeemablePoints
extern NSString *const kRedeemablePointsClassKey;

extern NSString *const kRedeemablePointsFieldCreatedAtKey;
extern NSString *const kRedeemablePointsFieldPointsKey;
extern NSString *const kRedeemablePointsFieldWasRedeemedKey;

#pragma mark FeedStory
extern NSString *const kFeedStoryClassKey;

extern NSString *const kFeedStoryFieldObjectIdKey;
extern NSString *const kFeedStoryFieldCreatedAtKey;
extern NSString *const kFeedStoryFieldSourceKey;
extern NSString *const kFeedStoryFieldTitleKey;
extern NSString *const kFeedStoryFieldUrlKey;
extern NSString *const kFeedStoryFieldImageKey;
extern NSString *const kFeedStoryFieldDescriptionKey;
extern NSString *const kFeedStoryFieldNeedsImageKey;

#pragma mark - OLD
/*
#pragma mark Circle
extern NSString *const kCircleClassKey;

extern NSString *const kCircleFieldImageKey;
extern NSString *const kCircleFieldCreatedAtKey;
extern NSString *const kCircleFieldCreatedByKey;
extern NSString *const kCircleFieldTitleKey;
extern NSString *const kCircleFieldCategoryKey;
extern NSString *const kCircleFieldTimeToJoinKey;
extern NSString *const kCircleFieldUrlKey;
extern NSString *const kCircleFieldShortTextKey;
extern NSString *const kCircleFieldTotalCircleActions;
extern NSString *const kCircleFieldTotalCircleActionValue;
//extern NSString *const kCircleFieldTotalTimeInMomentsOfSilenceKey;

#pragma mark Circle Action
extern NSString *const kCircleActionClassKey;

extern NSString *const kCircleActionFieldCircleKey;
extern NSString *const kCircleActionFieldUserKey;
extern NSString *const kCircleActionFieldTitleKey;
extern NSString *const kCircleActionFieldCircleActionUnitsKey;
extern NSString *const kCircleActionFieldTypeKey;

extern NSString *const kCircleActionTypeTap;
extern NSString *const kCircleActionTypeHold;
*/

#pragma mark Follow
extern NSString *const kFollowClassKey;

extern NSString *const kFollowFieldFollowedKey;
extern NSString *const kFollowFieldFollowingKey;

/*
#pragma mark MomentsOfSilence
extern NSString *const kMomentOfSilenceClassKey;

extern NSString *const kMomentOfSilenceFieldCreatedAtKey;
extern NSString *const kMomentOfSilenceFieldCircleKey;
extern NSString *const kMomentOfSilenceFieldUserKey;
extern NSString *const kMomentOfSilenceFieldTypeKey;
extern NSString *const kMomentOfSilenceFieldRecordingKey;
extern NSString *const kMomentOfSilenceFieldImageKey;
extern NSString *const kMomentOfSilenceFieldDurationKey;

#pragma mark Activity
extern NSString *const kActivityClassKey;

extern NSString *const kActivityFieldCreatedAtKey;
extern NSString *const kActivityFieldTypeKey;
extern NSString *const kActivityFieldDescriptionKey;
extern NSString *const kActivityFieldUserKey;
extern NSString *const kActivityFieldTargetCircleKey;
extern NSString *const kActivityFieldTargetUserKey;
extern NSString *const kActivityFieldMomentKey;

extern NSString *const kActivityTypeCircleAction;
extern NSString *const kActivityTypeRecorded;
extern NSString *const kActivityTypeShared;
extern NSString *const kActivityTypeLiked;
extern NSString *const kActivityTypeFollowed;
extern NSString *const kActivityTypeCreated;
 */
@end

