//
//  ShyftConstants.m
//  Shyft
//
//  Created by Rick Strom on 11/14/14.
//  Copyright (c) 2014 Rick Strom. All rights reserved.
//

#import "CareMobConstants.h"

@implementation CareMobConstants

#pragma mark - Parse Cloud Functions

NSString *const kCloudFunctionGetUserPointsAndLevelKey                          =@"GetUserPointsAndLevel";

NSString *const kCloudFunctionGetUserPointsAndLevelResultPoints                 =@"points";
NSString *const kCloudFunctionGetUserPointsAndLevelResultLevel                  =@"level";
NSString *const kCloudFunctionGetUserPointsAndLevelResultPointsToCurrentLevel   =@"pointsToCurrentLevel";
NSString *const kCloudFunctionGetUserPointsAndLevelResultPointsToNextLevel      =@"pointsToNextLevel";

// Redeem points
NSString *const kCloudFunctionRedeemPointsKey                                   =@"RedeemPoints";

NSString *const kCloudFunctionRedeemPointsActivity                              =@"activity";

// Notify user's facebook friends that they joined
NSString *const kCloudFunctionNotifyUsersFacebookFriendsOfSignupKey             =@"NotifyUsersFacebookFriendsOfSignup";

// Create a caremob from a given feed story
NSString *const kCloudFunctionCreateCareMobFromFeedStoryKey                     =@"CreateCareMobFromFeedStory";

NSString *const kCloudFunctionCreateCareMobFromFeedStoryParamFeedStoryId        =@"feedStoryId";

// Get the submob point totals for a given user
NSString *const kCloudFunctionGetUserSubmobPointTotalsKey                       =@"GetUserSubmobPointTotals";

NSString *const kCloudFunctionGetUserSubmobPointTotalsParamUserObjectId         =@"userId";

// Get rank for a given user
NSString *const kCloudFunctionGetUserRankKey                                    =@"GetUserRank";

NSString *const kCloudFunctionGetUserRankParamUserObjectId                      =@"userId";
NSString *const kCloudFunctionGetUserRankParamUserPoints                        =@"userPoints";

#pragma mark - Parse Data Model

#pragma mark User
NSString *const kUserClassKey                                                   =@"_User";

NSString *const kUserFieldObjectIdKey                                           =@"objectId";
NSString *const kUserFieldCreatedAtKey                                          =@"createdAt";
NSString *const kUserFieldDidSetUsernameKey                                     =@"didSetUsername";
NSString *const kUserFieldProfileImageKey                                       =@"profileImage";
NSString *const kUserFieldNameKey                                               =@"name";
NSString *const kUserFieldUsernameKey                                           =@"username";
NSString *const kUserFieldPasswordKey                                           =@"password";
NSString *const kUserFieldEmailKey                                              =@"email";
NSString *const kUserFieldLocationKey                                           =@"location";
NSString *const kUserFieldFacebookUserIdKey                                     =@"fbUserId";
NSString *const kUserFieldFacebookFriendsKey                                    =@"fbFriendIds";
NSString *const kUserFieldFollowerCountKey                                      =@"followerCount";
NSString *const kUserFieldFollowingCountKey                                     =@"followingCount";
//NSString *const kUserFieldTotalCircleActions                                    =@"totalCircleActions";
//NSString *const kUserFieldTotalCirclesCreated                                   =@"totalCirclesCreated";
NSString *const kUserFieldPointsKey                                             =@"points";
NSString *const kUserFieldLevelKey                                              =@"level";
NSString *const kUserFieldEffectivePointsKey                                    =@"effectivePoints";
NSString *const kUserFieldTodayPointsKey                                        =@"todayPoints";
NSString *const kUserFieldInfluenceKey                                          =@"influence";
NSString *const kUserFieldEffectiveInfluenceKey                                 =@"effectiveInfluence";
NSString *const kUserFieldTodayInfluenceKey                                     =@"todayInfluence";
NSString *const kUserFieldRankKey                                               =@"rank";
NSString *const kUserFieldCaremobsCreatedKey                                    =@"caremobsCreated";
NSString *const kUserFieldSubMobsStartedKey                                     =@"subMobsStarted";
//NSString *const kUserFieldMobActionsCreatedKey                                  =@"mobActionsCreated";
NSString *const kUserFieldTotalMobActionsKey                                    =@"totalMobActions";
NSString *const kUserFieldTotalMobActionValueKey                                =@"totalMobActionValue";
NSString *const kUserFieldTotalMobActionValueTodayKey                           =@"totalMobActionValueToday";

#pragma mark CareMob
NSString *const kCareMobClassKey                                                =@"CareMob";

NSString *const kCareMobObjectIdKey                                             =@"objectId";
NSString *const kCareMobCreatedAtKey                                            =@"createdAt";

NSString *const kCareMobCreatedByKey                                            =@"createdBy";
NSString *const kCareMobHiddenKey                                               =@"hidden";
NSString *const kCareMobFeaturedKey                                             =@"featured";
NSString *const kCareMobImagesKey                                               =@"images";
NSString *const kCareMobImageKey                                                =@"image";
NSString *const kCareMobVideosKey                                               =@"videos";
NSString *const kCareMobTitleKey                                                =@"title";
NSString *const kCareMobCategoryKey                                             =@"category";
NSString *const kCareMobOriginalCategoryKey                                     =@"originalCategory";
NSString *const kCareMobLongTextKey                                             =@"long_text";
NSString *const kCareMobShortTextKey                                            =@"short_text";
NSString *const kCareMobUrlKey                                                  =@"url";
NSString *const kCareMobSourceKey                                               =@"source";
NSString *const kCareMobSourceUserKey                                           =@"sourceUser";
NSString *const kCareMobSubMobsKey                                              =@"subMobs";

NSString *const kCareMobTotalMobRankScoreKey                                    =@"totalMobRankScore";
NSString *const kCareMobPointsKey                                               =@"points";
NSString *const kCareMobLevelKey                                                =@"level";
NSString *const kCareMobEffectivePointsKey                                      =@"effectivePoints";
NSString *const kCareMobTodayPointsKey                                          =@"todayPoints";
NSString *const kCareMobHighMobRankScoreKey                                     =@"highMobRankScore";
NSString *const kCareMobHighMobRankKey                                          =@"highMobRank";

#pragma mark SubMob
NSString *const kSubMobClassKey                                                 =@"SubMob";

NSString *const kSubMobObjectIdKey                                              =@"objectId";
NSString *const kSubMobCreatedAtKey                                             =@"createdAt";

NSString *const kSubMobCategoryKey                                              =@"category";
NSString *const kSubMobTotalMobActionValueKey                                   =@"totalMobActionValue";
NSString *const kSubMobTotalMobActionsKey                                       =@"totalMobActions";
NSString *const kSubMobPointsKey                                                =@"points";
NSString *const kSubMobLevelKey                                                 =@"level";
NSString *const kSubMobEffectivePointsKey                                       =@"effectivePoints";
NSString *const kSubMobTodayPointsKey                                           =@"todayPoints";


#pragma mark MobAction
NSString *const kMobActionClassKey                                              =@"MobAction";

NSString *const kMobActionObjectIdKey                                           =@"objectId";
NSString *const kMobActionCreatedAtKey                                          =@"createdAt";
NSString *const kMobActionUpdatedAtKey                                          =@"updatedAt";

NSString *const kMobActionCareMobKey                                            =@"careMob";
NSString *const kMobActionSubMobKey                                             =@"subMob";
NSString *const kMobActionUserKey                                               =@"user";
NSString *const kMobActionValueKey                                              =@"value";
NSString *const kMobActionPointsKey                                             =@"points";
NSString *const kMobActionLocationKey                                           =@"location";

#pragma mark MobActionFootprint
NSString *const kMobActionFootprintClassKey                                     =@"MobActionFootprint";

NSString *const kMobActionFootprintObjectIdKey                                  =@"objectId";
NSString *const kMobActionFootprintCreatedAtKey                                 =@"createdAt";
NSString *const kMobActionFootprintUpdatedAtKey                                 =@"updatedAt";

NSString *const kMobActionFootprintCareMobKey                                   =@"careMob";
NSString *const kMobActionFootprintSubMobKey                                    =@"subMob";
NSString *const kMobActionFootprintUserKey                                      =@"user";
NSString *const kMobActionFootprintLocationKey                                  =@"location";
NSString *const kMobActionFollowingUserKey                                      =@"followingUser";

#pragma mark MobCategory
NSString *const kMobCategoryClassKey                                            =@"MobCategory";

NSString *const kMobCategoryObjectIdKey                                         =@"objectId";
NSString *const kMobCategoryCreatedAtKey                                        =@"createdAt";

NSString *const kMobCategoryTypeKey                                             =@"type";
NSString *const kMobCategoryActionTypeKey                                       =@"actionType";
NSString *const kMobCategoryLevelKey                                            =@"level";
NSString *const kMobCategoryTotalActionValueKey                                 =@"totalActionValue";
NSString *const kMobCategoryTotalUsersKey                                       =@"totalUsers";
NSString *const kMobCategoryTotalUnityPointsKey                                 =@"totalUnityPoints";

#pragma mark Activity
NSString *const kActivityClassKey                                               =@"Activity";

NSString *const kActivityFieldCreatedAtKey                                      =@"createdAt";
NSString *const kActivityFieldTypeKey                                           =@"type";
NSString *const kActivityFieldUserKey                                           =@"user";
NSString *const kActivityFieldNumberValueKey                                    =@"numberValue";
NSString *const kActivityFieldStringValueKey                                    =@"stringValue";
NSString *const kActivityFieldTargetUserKey                                     =@"targetUser";
NSString *const kActivityFieldTargetCareMobKey                                  =@"targetCareMob";
NSString *const kActivityFieldTargetSubMobKey                                  =@"targetSubMob";
NSString *const kActivityFieldTargetMobActionKey                                =@"targetMobAction";
NSString *const kActivityFieldTargetMobCategoryKey                              =@"targetMobCategory";
NSString *const kActivityFieldTargetRedeemablePointsKey                         =@"targetRedeemablePoints";

NSString *const kActivityTypeFollow                                             =@"Follow";
NSString *const kActivityTypeCareMobLeveledUp                                   =@"CareMobLeveledUp";
NSString *const kActivityTypeSubMobLeveledUp                                    =@"SubMobLeveledUp";
NSString *const kActivityTypeUserLeveledUp                                      =@"UserLeveledUp";
NSString *const kActivityTypeUserJoined                                         =@"UserJoined";
NSString *const kActivityTypeUserFollowed                                       =@"UserFollowed";
NSString *const kActivityTypeUserFollowedIntoSubMob                             =@"UserFollowedIntoSubMob";
NSString *const kActivityTypeUserEnteredSubMob                                  =@"UserEnteredSubMob";
NSString *const kActivityTypeUserCreatedCareMob                                 =@"UserCreatedCareMob";

#pragma mark RedeemablePoints
NSString *const kRedeemablePointsClassKey                                       =@"RedeemablePoints";

NSString *const kRedeemablePointsFieldCreatedAtKey                              =@"createdAt";
NSString *const kRedeemablePointsFieldPointsKey                                 =@"points";
NSString *const kRedeemablePointsFieldWasRedeemedKey                            =@"wasRedeemed";

#pragma mark FeedStory
NSString *const kFeedStoryClassKey                                              =@"FeedStory";

NSString *const kFeedStoryFieldObjectIdKey                                      =@"objectId";
NSString *const kFeedStoryFieldCreatedAtKey                                     =@"createdAt";
NSString *const kFeedStoryFieldSourceKey                                        =@"source";
NSString *const kFeedStoryFieldTitleKey                                         =@"title";
NSString *const kFeedStoryFieldUrlKey                                           =@"url";
NSString *const kFeedStoryFieldImageKey                                         =@"image";
NSString *const kFeedStoryFieldDescriptionKey                                   =@"description";
NSString *const kFeedStoryFieldNeedsImageKey                                    =@"needsImage";

#pragma mark - OLD

// OLD MODEL
/*
#pragma mark Circle
NSString *const kCircleClassKey                                                 =@"circle";

NSString *const kCircleFieldCreatedAtKey                                        =@"createdAt";
NSString *const kCircleFieldCreatedByKey                                        =@"createdBy";
NSString *const kCircleFieldImageKey                                            =@"image";
NSString *const kCircleFieldTitleKey                                            =@"title";
NSString *const kCircleFieldCategoryKey                                         =@"category";
NSString *const kCircleFieldTimeToJoinKey                                       =@"timeToJoin";
NSString *const kCircleFieldUrlKey                                              =@"url";
NSString *const kCircleFieldShortTextKey                                        =@"short_text";
NSString *const kCircleFieldTotalCircleActions                                  =@"totalCircleActions";
NSString *const kCircleFieldTotalCircleActionValue                              =@"totalCircleActionValue";
//NSString *const kCircleFieldTotalTimeInMomentsOfSilenceKey                      =@"totalTimeInMomentsOfSilence";

#pragma mark Circle Action
NSString *const kCircleActionClassKey                                           =@"circleAction";

NSString *const kCircleActionFieldCircleKey                                     =@"circleObjectId";
NSString *const kCircleActionFieldUserKey                                       =@"userObjectId";
NSString *const kCircleActionFieldTitleKey                                      =@"circleTitle";
NSString *const kCircleActionFieldCircleActionUnitsKey                          =@"circleActionUnits";
NSString *const kCircleActionFieldTypeKey                                       =@"type";

NSString *const kCircleActionTypeTap                                            =@"tap";
NSString *const kCircleActionTypeHold                                           =@"hold";
*/

#pragma mark Follow
NSString *const kFollowClassKey                                                 =@"Follow";

NSString *const kFollowFieldFollowedKey                                         =@"followedUserId";
NSString *const kFollowFieldFollowingKey                                        =@"followingUserId";

// OLD MODEL
/*
#pragma mark MomentsOfSilence
NSString *const kMomentOfSilenceClassKey                                        =@"momentsOfSilence";

NSString *const kMomentOfSilenceFieldCreatedAtKey                               =@"createdAt";
NSString *const kMomentOfSilenceFieldCircleKey                                  =@"circleObjectId";
NSString *const kMomentOfSilenceFieldUserKey                                    =@"userObjectId";
NSString *const kMomentOfSilenceFieldTypeKey                                    =@"type";
NSString *const kMomentOfSilenceFieldRecordingKey                               =@"recording";
NSString *const kMomentOfSilenceFieldImageKey                                   =@"image";
NSString *const kMomentOfSilenceFieldDurationKey                                =@"duration";

#pragma mark Activity
NSString *const kActivityClassKey                                               =@"activity";

NSString *const kActivityFieldCreatedAtKey                                      =@"createdAt";
NSString *const kActivityFieldTypeKey                                           =@"type";
NSString *const kActivityFieldDescriptionKey                                    =@"description";
NSString *const kActivityFieldUserKey                                           =@"user";
NSString *const kActivityFieldTargetCircleKey                                   =@"targetCircle";
NSString *const kActivityFieldTargetUserKey                                     =@"targetUser";
NSString *const kActivityFieldMomentKey                                         =@"momentOfSilence";

NSString *const kActivityTypeCircleAction                                       =@"circleAction";
NSString *const kActivityTypeRecorded                                           =@"recorded";
NSString *const kActivityTypeShared                                             =@"shared";
NSString *const kActivityTypeLiked                                              =@"liked";
NSString *const kActivityTypeFollowed                                           =@"follow";
NSString *const kActivityTypeCreated                                            =@"created";
*/

@end
