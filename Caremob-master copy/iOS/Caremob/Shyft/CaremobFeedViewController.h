//
//  CaremobFeedViewController.h
//  Caremob
//
//  Created by Rick Strom on 6/1/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "CareMobConstants.h"
#import "UserLevelControlViewController.h"

// Table View Section Headers
#import "CaremobFeedSectionHeaderViewController.h"

// Table View Cells
#import "CaremobFeed_MobTableViewCell.h"
#import "CaremobFeed_FeaturedMobTableViewCell.h"
#import "CaremobFeed_NoMobsTableViewCell.h"
#import "CaremobFeed_TutorialTriggerTableViewCell.h"

// Destination controllers
#import "CaremobDisplayViewController.h"

// TableViewSections
#define kCareMobFeedNumberOfSections 8
#define kCareMobFeedSectionTutorialTrigger 0
#define kCareMobFeedSectionTopCareMobs 1
#define kCareMobFeedSectionTopPeaceSubMobs 2
#define kCareMobFeedSectionTopProtestSubMobs 3
#define kCareMobFeedSectionTopMourningSubMobs 4
#define kCareMobFeedSectionTopEmpathySubMobs 5
#define kCareMobFeedSectionTopCelebrationSubMobs 6
#define kCareMobFeedSectionTopSupportSubMobs 7

#define kCareMobFeedTableModeTrending 0
#define kCareMobFeedTableModeToday 1
#define kCareMobFeedTableModeAllTime 2
#define kCareMobFeedTableModeSearch 3

@interface CaremobFeedViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UITextFieldDelegate, CaremobFeedSectionHeaderViewControllerDelegate, CaremobFeed_TutorialTriggerTableViewCellDelegate>

@property (nonatomic, strong) UserLevelControlViewController *userLevelViewController;

@property (nonatomic, assign) BOOL searchBarIsShown;
@property (nonatomic, assign) int selectedSelectorIndex;

//@property (nonatomic, strong) NSArray *careMobs;
//@property (nonatomic, strong) NSDictionary *sortedCareMobs;

@property (nonatomic, strong) NSArray *trendingMobs;
@property (nonatomic, strong) NSDictionary *sortedTrendingMobs;
@property (nonatomic, strong) NSArray *topTodayMobs;
@property (nonatomic, strong) NSDictionary *sortedTopTodayMobs;
@property (nonatomic, strong) NSArray *topAllTimeMobs;
@property (nonatomic, strong) NSDictionary *sortedTopAllTimeMobs;
@property (nonatomic, strong) NSArray *searchMobs;
@property (nonatomic, strong) NSDictionary *sortedSearchMobs;


@property (nonatomic, strong) PFObject *selectedCareMob;
@property (nonatomic, strong) NSString *selectedCategoryContext;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, assign) BOOL isRefreshing;

@property (nonatomic, strong) NSMutableArray *expandedSections;

@end
