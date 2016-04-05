//
//  CaremobFeedViewController.m
//  Caremob
//
//  Created by Rick Strom on 6/1/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import "CaremobFeedViewController.h"

@interface CaremobFeedViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewHeightConstraint;

// Selector
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *selectorButtons;

- (IBAction)selectorButtonHit:(id)sender;
@end

@implementation CaremobFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Register the reuse identifiers for our custom section headers
    [self.tableView registerNib:[UINib nibWithNibName:@"CaremobFeedSectionHeaderViewController" bundle:nil] forHeaderFooterViewReuseIdentifier:@"CaremobFeedSectionHeaderViewController"];
    
    // Configure the navigation bar
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"caremob_navbar_logo"]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:12.0/255.0 green:105.0/255.0 blue:148.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UIBarButtonItem *MyBackButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    //[MyBackButton setImage:[UIImage imageNamed:@"caremob_navbar_back_button"]];
    //[MyBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"caremob_navbar_back_button"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    MyBackButton.title = @"";
    
    NSDictionary *myBackButtonTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                [UIFont fontWithName:@"NettoOT" size:16.0f], NSFontAttributeName,
                                                nil];
    [MyBackButton setTitleTextAttributes:myBackButtonTextAttributes forState:UIControlStateNormal];
    [MyBackButton setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.backBarButtonItem = MyBackButton;
    
    //mobbers_actionbar_icon_mobberssearch
    
    UIBarButtonItem *BarSearchButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"mobbers_actionbar_icon_mobberssearch"] style:UIBarButtonItemStylePlain target:self action:@selector(showSearchBar:)];
    self.navigationItem.rightBarButtonItem = BarSearchButton;
    
    // Add a refresh control to our table
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl setTintColor:[UIColor darkGrayColor]];
    [self.refreshControl addTarget:self action:@selector(refreshPulled:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.refreshControl];
    
    /*
    // Add the user level control to the nav bar
    self.userLevelViewController = [[UserLevelControlViewController alloc] initWithNibName:@"UserLevelControlViewController" bundle:nil];
    
    [self.navigationController.navigationBar addSubview:self.userLevelViewController.view];
    
    [self.userLevelViewController setFrameRelativeTo:self.navigationController.navigationBar];
    [self.userLevelViewController initialize];
    */
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidPerformMobAction:) name:kNSNotificationMobActionWasPerformed object:nil];
    
    // Set up an expanded sections array of BOOL to keep track of which sections are expanded
    self.expandedSections = [[NSMutableArray alloc] init];
    for (int i = 0; i < kCareMobFeedNumberOfSections; i++) {
        self.expandedSections[i] = [NSNumber numberWithBool:NO];
    }
    
}

-(void)showSearchBar:(id)sender {
    if (self.searchBarIsShown == NO) {
        [self.view layoutIfNeeded];
        self.searchViewHeightConstraint.constant = 44;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.searchBarIsShown = YES;
        }];
    } else {
        [self.searchTextField resignFirstResponder];
        
        [self.view layoutIfNeeded];
        self.searchViewHeightConstraint.constant = 0;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.searchBarIsShown = NO;
            self.searchTextField.text = @"";
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

    if ([PFUser currentUser] && self.trendingMobs == nil) {
        //[self refreshCareMobList:YES];
        [self selectorButtonHit:self.selectorButtons[0]];
    }
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //[[NSNotificationCenter defaultCenter] removeObserver:self name:kNSNotificationMobActionWasPerformed object:nil];
}

-(void)userDidPerformMobAction:(NSNotification*)notification {
    if (self.userLevelViewController != nil) [self.userLevelViewController userNeedsRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [self.searchBar resignFirstResponder];
}

-(void)back {
    
}

-(void)refreshPulled:(id)sender {
    if (self.isRefreshing) return;
    
    [self refreshCareMobList:NO];
}

-(void)refreshCareMobList:(BOOL)shouldUseCache {
    if (self.isRefreshing) return;
    
    self.isRefreshing = YES;
    
    PFQuery *caremobQuery = [PFQuery queryWithClassName:kCareMobClassKey];
    [caremobQuery includeKey:kCareMobSubMobsKey];
    [caremobQuery includeKey:kCareMobSourceUserKey];
    [caremobQuery orderByDescending:kCareMobCreatedAtKey];
    
    //if (self.selectedSelectorIndex == kCareMobFeedTableModeSearch) {
    if (self.searchBarIsShown && self.searchTextField.text != nil) {
        if (self.searchTextField.text.length > 0) {
            [caremobQuery whereKey:kCareMobTitleKey matchesRegex:self.searchTextField.text modifiers:@"i"];
        }
    
        [caremobQuery orderByDescending:kCareMobCreatedAtKey];
    } else
//    if (self.selectedSelectorIndex == kCareMobFeedTableModeTrending) {
        [caremobQuery orderByDescending:[NSString stringWithFormat:@"%@,%@",kCareMobEffectivePointsKey, kCareMobCreatedAtKey]];
  //  } else if (self.selectedSelectorIndex == kCareMobFeedTableModeToday) {
  //      [caremobQuery orderByDescending:[NSString stringWithFormat:@"%@,%@",kCareMobTodayPointsKey,kCareMobCreatedAtKey]];
  //  } else if (self.selectedSelectorIndex == kCareMobFeedTableModeTrending) {
  //      [caremobQuery orderByDescending:[NSString stringWithFormat:@"%@,%@",kCareMobPointsKey,kCareMobCreatedAtKey]];
  //  }
    
    if (shouldUseCache)
        [caremobQuery setCachePolicy:kPFCachePolicyCacheElseNetwork];
    else
        [caremobQuery setCachePolicy:kPFCachePolicyNetworkElseCache];
    
    caremobQuery.maxCacheAge = 60*60;
    
    [caremobQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [self.refreshControl endRefreshing];
            self.isRefreshing = NO;
            
            [self.tableView reloadData];
        } else {
            [self.refreshControl endRefreshing];
            self.isRefreshing = NO;
            
            //self.careMobs = objects;
            //self.sortedCareMobs = [CareMobHelper sortCareMobArray:self.careMobs intoCategoriesSortedBy:kCareMobSortTypeTrending];
            
            if (self.selectedSelectorIndex == kCareMobFeedTableModeTrending) {
                self.trendingMobs = objects;
                self.sortedTrendingMobs = [CareMobHelper sortCareMobArray:self.trendingMobs intoCategoriesSortedBy:kCareMobSortTypeTrending];
            } else if (self.selectedSelectorIndex == kCareMobFeedTableModeToday) {
                self.topTodayMobs = objects;
                self.sortedTopTodayMobs = [CareMobHelper sortCareMobArray:self.topTodayMobs intoCategoriesSortedBy:kCareMobSortTypeTopToday];
            } else if (self.selectedSelectorIndex == kCareMobFeedTableModeAllTime) {
                self.topAllTimeMobs = objects;
                self.sortedTopAllTimeMobs = [CareMobHelper sortCareMobArray:self.topAllTimeMobs intoCategoriesSortedBy:kCareMobSortTypeTop];
            } else if (self.selectedSelectorIndex == kCareMobFeedTableModeSearch) {
                self.searchMobs = objects;
                self.sortedSearchMobs = [CareMobHelper sortCareMobArray:self.searchMobs intoCategoriesSortedBy:kCareMobSortTypeTrending];
            }
            
            [self.tableView reloadData];
            
            NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView scrollToRowAtIndexPath:topIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

        }
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showCaremobDisplayViewController"]) {
        CaremobDisplayViewController *destination = (CaremobDisplayViewController*)segue.destinationViewController;
        
        destination.careMob = self.selectedCareMob;
        destination.categoryContext = self.selectedCategoryContext;
        
        destination.hidesBottomBarWhenPushed = YES;
    }
}

#pragma mark - UITableViewDelegateMethods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return kCareMobFeedNumberOfSections;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == kCareMobFeedSectionTutorialTrigger) {
        return 1;
    }
    
    NSDictionary *sortedCareMobs = nil;
    if (self.selectedSelectorIndex == kCareMobFeedTableModeTrending) sortedCareMobs = self.sortedTrendingMobs;
    else if (self.selectedSelectorIndex == kCareMobFeedTableModeToday) sortedCareMobs = self.sortedTopTodayMobs;
    else if (self.selectedSelectorIndex == kCareMobFeedTableModeAllTime) sortedCareMobs = self.sortedTopAllTimeMobs;
    else if (self.selectedSelectorIndex == kCareMobFeedTableModeSearch) sortedCareMobs = self.sortedSearchMobs;
    
    if (sortedCareMobs == nil) {
        /*
        NSArray *topMobs = sortedCareMobs[@"topMobs"];
        
        if (topMobs == nil || topMobs.count == 0) return 0;
        else {
            if ([(NSNumber*)self.expandedSections[section] boolValue]) return topMobs.count;
            else return MIN(3,topMobs.count);
        }
         */
        return 0;
    }
    
    if (section == kCareMobFeedSectionTopPeaceSubMobs) {
        NSArray *topPeaceMobs = sortedCareMobs[@"toppeaceMobs"];
        
        if (topPeaceMobs == nil || topPeaceMobs.count == 0) return 1;
        else {
            if ([(NSNumber*)self.expandedSections[section] boolValue]) return topPeaceMobs.count;
            else return MIN(4,topPeaceMobs.count);
        }
    } else if (section == kCareMobFeedSectionTopProtestSubMobs) {
        NSArray *topProtestMobs = sortedCareMobs[@"topprotestMobs"];
        
        if (topProtestMobs == nil || topProtestMobs.count == 0) return 1;
        else {
            if ([(NSNumber*)self.expandedSections[section] boolValue]) return topProtestMobs.count;
            else return MIN(4,topProtestMobs.count);
        }

    } else if (section == kCareMobFeedSectionTopMourningSubMobs) {
        NSArray *topMourningMobs = sortedCareMobs[@"topmourningMobs"];
        
        if (topMourningMobs == nil || topMourningMobs.count == 0) return 1;
        else {
            if ([(NSNumber*)self.expandedSections[section] boolValue]) return topMourningMobs.count;
            else return MIN(4,topMourningMobs.count);
        }

    } else if (section == kCareMobFeedSectionTopEmpathySubMobs) {
        NSArray *topEmpathyMobs = sortedCareMobs[@"topempathyMobs"];
        
        if (topEmpathyMobs == nil || topEmpathyMobs.count == 0) return 1;
        else {
            if ([(NSNumber*)self.expandedSections[section] boolValue]) return topEmpathyMobs.count;
            else return MIN(4,topEmpathyMobs.count);
        }

    } else if (section == kCareMobFeedSectionTopCelebrationSubMobs) {
        NSArray *topCelebrationMobs = sortedCareMobs[@"topcelebrationMobs"];
        
        if (topCelebrationMobs == nil || topCelebrationMobs.count == 0) return 1;
        else {
            if ([(NSNumber*)self.expandedSections[section] boolValue]) return topCelebrationMobs.count;
            else return MIN(4,topCelebrationMobs.count);
        }

    } else if (section == kCareMobFeedSectionTopSupportSubMobs) {
        NSArray *topSupportMobs = sortedCareMobs[@"topsupportMobs"];
        
        if (topSupportMobs == nil || topSupportMobs.count == 0) return 1;
        else {
            if ([(NSNumber*)self.expandedSections[section] boolValue]) return topSupportMobs.count;
            else return MIN(4,topSupportMobs.count);
        }

    } else {
        // TEMP: show no Caremobs
        //return 0;
        
        NSArray *topMobs = sortedCareMobs[@"topMobs"];

        if (topMobs == nil || topMobs.count == 0) return 1;
        else {
            if ([(NSNumber*)self.expandedSections[section] boolValue]) return topMobs.count;
            else return MIN(3,topMobs.count);
        }
    }
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier;
    
    if (indexPath.section == kCareMobFeedSectionTutorialTrigger) {
        CellIdentifier = @"CaremobFeed_TutorialTriggerTableViewCell";
        
        CaremobFeed_TutorialTriggerTableViewCell *cell = (CaremobFeed_TutorialTriggerTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = (CaremobFeed_TutorialTriggerTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell...
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        cell.delegate = self;
        
        return cell;

    }
    
    NSDictionary *sortedCareMobs = nil;
    if (self.selectedSelectorIndex == kCareMobFeedTableModeTrending) sortedCareMobs = self.sortedTrendingMobs;
    else if (self.selectedSelectorIndex == kCareMobFeedTableModeToday) sortedCareMobs = self.sortedTopTodayMobs;
    else if (self.selectedSelectorIndex == kCareMobFeedTableModeAllTime) sortedCareMobs = self.sortedTopAllTimeMobs;
    else if (self.selectedSelectorIndex == kCareMobFeedTableModeSearch) sortedCareMobs = self.sortedSearchMobs;

    // First get the list we are working with here
    NSArray *mobList = nil;
    NSString *categoryContext = nil;
    NSString *statsText = @"";
    
    if (indexPath.section == kCareMobFeedSectionTopPeaceSubMobs) {
        mobList = sortedCareMobs[@"toppeaceMobs"];
        categoryContext = @"peace";
    } else if (indexPath.section == kCareMobFeedSectionTopProtestSubMobs) {
        mobList = sortedCareMobs[@"topprotestMobs"];
        categoryContext = @"protest";
    } else if (indexPath.section == kCareMobFeedSectionTopMourningSubMobs) {
        mobList = sortedCareMobs[@"topmourningMobs"];
        categoryContext = @"mourning";
    } else if (indexPath.section == kCareMobFeedSectionTopEmpathySubMobs) {
        mobList = sortedCareMobs[@"topempathyMobs"];
        categoryContext = @"empathy";
    } else if (indexPath.section == kCareMobFeedSectionTopCelebrationSubMobs) {
        mobList = sortedCareMobs[@"topcelebrationMobs"];
        categoryContext = @"celebration";
    } else if (indexPath.section == kCareMobFeedSectionTopSupportSubMobs) {
        mobList = sortedCareMobs[@"topsupportMobs"];
        categoryContext = @"support";
    } else {
        mobList = sortedCareMobs[@"topMobs"];
        categoryContext = nil;
    }


    
    if (mobList == nil || mobList.count == 0) {
        CellIdentifier = @"CaremobFeed_NoMobsTableViewCell";
        
        CaremobFeed_NoMobsTableViewCell *cell = (CaremobFeed_NoMobsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = (CaremobFeed_NoMobsTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell...
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    } else {

        PFObject *careMob = (PFObject*)mobList[indexPath.row];
        int members = -1;
        int rank = -1;
        int level = -1;
        int totalValue = -1;
        float effectivePoints = -1.0f;
        
        // For top mobs, we show points and level
        // For SubMobs we show total MobActions and total MobAction value
        if (indexPath.section == kCareMobFeedSectionTopCareMobs && false) {
            NSNumber *points = [careMob objectForKey:kCareMobPointsKey];
            NSNumber *levelNum = [careMob objectForKey:kCareMobLevelKey];
            level = [levelNum intValue];
            rank = (int)indexPath.row + 1;
            
            //statsText = [NSString stringWithFormat:@"Rank %d | level %d | %dpts", ((int)indexPath.row + 1), [level intValue], [points intValue]];
        } else {
            // Get the array of submobs
            NSArray *subMobs = [careMob objectForKey:kCareMobSubMobsKey];
            
            // Show the display for a SubMob
            if (indexPath.section == kCareMobFeedSectionTopPeaceSubMobs)            categoryContext = @"peace";
            else if (indexPath.section == kCareMobFeedSectionTopProtestSubMobs)     categoryContext = @"protest";
            else if (indexPath.section == kCareMobFeedSectionTopMourningSubMobs)    categoryContext = @"mourning";
            else if (indexPath.section == kCareMobFeedSectionTopEmpathySubMobs)     categoryContext = @"empathy";
            else if (indexPath.section == kCareMobFeedSectionTopCelebrationSubMobs) categoryContext = @"celebration";
            else if (indexPath.section == kCareMobFeedSectionTopSupportSubMobs)     categoryContext = @"support";
            else {
                // Its a top mob, so we have to loop through to find the top submob
                categoryContext = [CareMobHelper getTopCategoryForCareMob:careMob];
            }
            
            // Find the SubMob in the list of submobs
            
            if (subMobs != nil) {
                PFObject *subMob = nil;
                
                for (int i = 0; i < subMobs.count; i++) {
                    PFObject *s = (PFObject*)subMobs[i];
                    if (s != nil) {
                        NSString *sCat = (NSString*)[s objectForKey:kSubMobCategoryKey];
                        
                        if ([sCat isEqualToString:categoryContext]) {
                            subMob = s;
                            break;
                        }
                    }
                }
                
                if (subMob != nil) {
                    NSNumber *totalMobActions = [subMob objectForKey:kSubMobTotalMobActionsKey];
                    NSNumber *totalMobActionValue = [subMob objectForKey:kSubMobTotalMobActionValueKey];
                    NSNumber *effectivePointsPointsValue = [subMob objectForKey:kSubMobEffectivePointsKey];
                    
                    totalValue = [totalMobActionValue doubleValue];
                    members = [totalMobActions intValue];
                    effectivePoints = [effectivePointsPointsValue floatValue];
                    
                    //statsText = [NSString stringWithFormat:@"Rank %d | %d | %ds", ((int)indexPath.row + 1), [totalMobActions intValue], [totalMobActionValue intValue]];
                }
            }
        }

        if (indexPath.row == 0 || indexPath.section == kCareMobFeedSectionTopCareMobs) {
            CellIdentifier = @"CaremobFeed_FeaturedMobTableViewCell";
            
            CaremobFeed_FeaturedMobTableViewCell *cell = (CaremobFeed_FeaturedMobTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = (CaremobFeed_FeaturedMobTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            // Initialize
            [cell initializeWithCareMob:careMob andCategoryContext:categoryContext andRank:(int)indexPath.row + 1 andLevel:level andMembers:members andTotalValue:totalValue andEffectivePoints:effectivePoints];
            
            // Configure the cell...
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;
        } else {
            CellIdentifier = @"CaremobFeed_MobTableViewCell";
            
            CaremobFeed_MobTableViewCell *cell = (CaremobFeed_MobTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = (CaremobFeed_MobTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            
            // Initialize
            [cell initializeWithCareMob:careMob andCategoryContext:categoryContext andRank:(int)indexPath.row + 1 andLevel:level andMembers:members andTotalValue:totalValue andEffectivePoints:effectivePoints];
            
            // Configure the cell...
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            return cell;

        }
    }
    
    // If we somehow got here.....
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kCareMobFeedSectionTutorialTrigger) {
        [self performSegueWithIdentifier:@"showTutorialViewController" sender:self];
        return;
    }
    
    NSDictionary *sortedCareMobs = nil;
    if (self.selectedSelectorIndex == kCareMobFeedTableModeTrending) sortedCareMobs = self.sortedTrendingMobs;
    else if (self.selectedSelectorIndex == kCareMobFeedTableModeToday) sortedCareMobs = self.sortedTopTodayMobs;
    else if (self.selectedSelectorIndex == kCareMobFeedTableModeAllTime) sortedCareMobs = self.sortedTopAllTimeMobs;
    else if (self.selectedSelectorIndex == kCareMobFeedTableModeSearch) sortedCareMobs = self.sortedSearchMobs;

    //self.selectedCareMob = self.careMobs[indexPath.row];

    NSArray *mobList = nil;
    
    if (indexPath.section == kCareMobFeedSectionTopPeaceSubMobs) {
        mobList = sortedCareMobs[@"toppeaceMobs"];
        if (mobList == nil || mobList.count == 0) return;
        
        self.selectedCareMob = mobList[indexPath.row];
        self.selectedCategoryContext = @"peace";
    } else if (indexPath.section == kCareMobFeedSectionTopProtestSubMobs) {
        mobList = sortedCareMobs[@"topprotestMobs"];
        if (mobList == nil || mobList.count == 0) return;
        
        self.selectedCareMob = mobList[indexPath.row];
        self.selectedCategoryContext = @"protest";
    } else if (indexPath.section == kCareMobFeedSectionTopMourningSubMobs) {
        mobList = sortedCareMobs[@"topmourningMobs"];
        if (mobList == nil || mobList.count == 0) return;
        
        self.selectedCareMob = mobList[indexPath.row];
        self.selectedCategoryContext = @"mourning";
    } else if (indexPath.section == kCareMobFeedSectionTopEmpathySubMobs) {
        mobList = sortedCareMobs[@"topempathyMobs"];
        if (mobList == nil || mobList.count == 0) return;
        
        self.selectedCareMob = mobList[indexPath.row];
        self.selectedCategoryContext = @"empathy";
    } else if (indexPath.section == kCareMobFeedSectionTopCelebrationSubMobs) {
        mobList = sortedCareMobs[@"topcelebrationMobs"];
        if (mobList == nil || mobList.count == 0) return;
        
        self.selectedCareMob = mobList[indexPath.row];
        self.selectedCategoryContext = @"celebration";
    } else if (indexPath.section == kCareMobFeedSectionTopSupportSubMobs) {
        mobList = sortedCareMobs[@"topsupportMobs"];
        if (mobList == nil || mobList.count == 0) return;
        
        self.selectedCareMob = mobList[indexPath.row];
        self.selectedCategoryContext = @"support";
    } else {
        mobList = sortedCareMobs[@"topMobs"];
        if (mobList == nil || mobList.count == 0) return;
        
        self.selectedCareMob = mobList[indexPath.row];
        self.selectedCategoryContext = [CareMobHelper getTopCategoryForCareMob:self.selectedCareMob];;
    }
    
    [self performSegueWithIdentifier:@"showCaremobDisplayViewController" sender:self];
}

// Header view
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == kCareMobFeedSectionTutorialTrigger) return nil;
    
    CaremobFeedSectionHeaderViewController *header = (CaremobFeedSectionHeaderViewController*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"CaremobFeedSectionHeaderViewController"];
    
    NSString *featuredMobsText = @"TOP TRENDING";
    NSString *topSubMobText = @"Trending";
    
    if (self.selectedSelectorIndex == kCareMobFeedTableModeTrending) {
        featuredMobsText = @"TRENDING NOW";
        topSubMobText = @"Trending ";
    } else if (self.selectedSelectorIndex == kCareMobFeedTableModeToday) {
        featuredMobsText = @"TODAY'S MOBS";
        topSubMobText = @"Today's ";
    } else if (self.selectedSelectorIndex == kCareMobFeedTableModeAllTime) {
        featuredMobsText = @"ALL TIME TOP MOBS";
        topSubMobText = @"All Time ";
    } else if (self.selectedSelectorIndex == kCareMobFeedTableModeSearch) {
        featuredMobsText = @"SEARCH MOBS";
        topSubMobText = @"";
    }

    if (section == kCareMobFeedSectionTopPeaceSubMobs) {
        header.sectionTitleLabel.text = [NSString stringWithFormat:@"%@Peace Mobs", topSubMobText];
        header.sectionHeaderBackgroundImage.image = [UIImage imageNamed:@"caremob_feed_section_header_bg_peace"];
        //[header.expandButton setImage:[UIImage imageNamed:@"caremob_feed_section_header_button_peace"] forState:UIControlStateNormal];
        header.categoryImage.image = [UIImage imageNamed:@"caremob_feed_section_header_button_peace"];
        
    } else if (section == kCareMobFeedSectionTopProtestSubMobs) {
        header.sectionTitleLabel.text = [NSString stringWithFormat:@"%@ Protest Mobs", topSubMobText];
        header.sectionHeaderBackgroundImage.image = [UIImage imageNamed:@"caremob_feed_section_header_bg_protest"];
        //[header.expandButton setImage:[UIImage imageNamed:@"caremob_feed_section_header_button_protest"] forState:UIControlStateNormal];
        header.categoryImage.image = [UIImage imageNamed:@"caremob_feed_section_header_button_protest"];
    } else if (section == kCareMobFeedSectionTopMourningSubMobs) {
        header.sectionTitleLabel.text = [NSString stringWithFormat:@"%@ Mourning Mobs", topSubMobText];
        header.sectionHeaderBackgroundImage.image = [UIImage imageNamed:@"caremob_feed_section_header_bg_mourning"];
        //[header.expandButton setImage:[UIImage imageNamed:@"caremob_feed_section_header_button_mourning"] forState:UIControlStateNormal];
        header.categoryImage.image = [UIImage imageNamed:@"caremob_feed_section_header_button_mourning"];
    } else if (section == kCareMobFeedSectionTopEmpathySubMobs) {
        header.sectionTitleLabel.text = [NSString stringWithFormat:@"%@ Empathy Mobs", topSubMobText];
        header.sectionHeaderBackgroundImage.image = [UIImage imageNamed:@"caremob_feed_section_header_bg_empathy"];
        //[header.expandButton setImage:[UIImage imageNamed:@"caremob_feed_section_header_button_empathy"] forState:UIControlStateNormal];
        header.categoryImage.image = [UIImage imageNamed:@"caremob_feed_section_header_button_empathy"];
    } else if (section == kCareMobFeedSectionTopCelebrationSubMobs) {
        header.sectionTitleLabel.text = [NSString stringWithFormat:@"%@ Celebration Mobs", topSubMobText];
        header.sectionHeaderBackgroundImage.image = [UIImage imageNamed:@"caremob_feed_section_header_bg_celebration"];
        //[header.expandButton setImage:[UIImage imageNamed:@"caremob_feed_section_header_button_celebration"] forState:UIControlStateNormal];
        header.categoryImage.image = [UIImage imageNamed:@"caremob_feed_section_header_button_celebration"];
    } else if (section == kCareMobFeedSectionTopSupportSubMobs) {
        header.sectionTitleLabel.text = [NSString stringWithFormat:@"%@ Support Mobs", topSubMobText];
        header.sectionHeaderBackgroundImage.image = [UIImage imageNamed:@"caremob_feed_section_header_bg_support"];
        //[header.expandButton setImage:[UIImage imageNamed:@"caremob_feed_section_header_button_support"] forState:UIControlStateNormal];
        header.categoryImage.image = [UIImage imageNamed:@"caremob_feed_section_header_button_support"];
    } else {
        header.sectionTitleLabel.text = featuredMobsText;
        header.sectionHeaderBackgroundImage.image = [UIImage imageNamed:@"caremob_feed_section_header_bg_topmobs"];
        //[header.expandButton setImage:[UIImage imageNamed:@"caremob_feed_section_header_button_topmobs"] forState:UIControlStateNormal];
        header.categoryImage.image = [UIImage imageNamed:@"caremob_feed_section_header_button_topmobs"];
        
        // TEMP: Caremobs are removed
        //return nil;
    }
    
    header.delegate = self;
    header.section = (int)section;
    
    [header setExpandButtonState:[(NSNumber*)self.expandedSections[section] boolValue]];
    
    return header;
}

// Header height
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    // TEMP: remove top Caremobs
    //if (section == kCareMobFeedSectionTopCareMobs) return 0.0f;

    if (section == kCareMobFeedSectionTutorialTrigger) return 0.0f;
    
    if (self.sortedTrendingMobs == nil && self.sortedSearchMobs == nil && self.sortedTopAllTimeMobs == nil && self.sortedTopTodayMobs == nil) return 0;
    
    return 26.0f;
}

// Row height
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == kCareMobFeedSectionTutorialTrigger) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if ([defaults boolForKey:kNSUserDefaultsUpfrontTutorialWasShown] == YES) return 0.0f;
        else return 95.0f;
    }
    
    if (indexPath.row == 0 || indexPath.section == kCareMobFeedSectionTopCareMobs) return 272.0f;
    else return 115.0f;
}

#pragma mark - UISearchBarDelegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    //[self refreshCareMobList:NO];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (self.searchBar.text.length > 0) [self refreshCareMobList:NO];
    
    [searchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark UITextField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    //if (self.searchTextField.text.length > 0)
    [self refreshCareMobList:NO];
    
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - CaremobFeedSectionHeaderViewControllerDelegate
-(BOOL)expandButtonWasHitForSection:(int)section {
    BOOL sectionIsExpanded = [(NSNumber*)self.expandedSections[section] boolValue];
    
    sectionIsExpanded = !sectionIsExpanded;
    
    self.expandedSections[section] = [NSNumber numberWithBool:sectionIsExpanded];
    
    [self.tableView reloadData];
    
    return sectionIsExpanded;
}

- (IBAction)selectorButtonHit:(id)sender {
    //NSArray *tabNames = @[@"latestmobbers",@"topmobbers",@"following",@"followers"];
    
    // First figure out which button was hit
    int index = -1;
    for (int i = 0; i < self.selectorButtons.count; i++) {
        if (sender == self.selectorButtons[i]) index = i;
    }
    
    NSLog(@"Tapped %d", index);
    if (index >= 0) self.selectedSelectorIndex = index;
    else return;    // Something weird happened!
    
    // Set the state of the buttons
    for (int i = 0; i < self.selectorButtons.count; i++) {
        UIButton *selectorButton = (UIButton*)self.selectorButtons[i];
        //UILabel *selectorLabel = (UILabel*)self.selectorLabels[i];
        //UIImageView *selectorSelectedBarImageView = (UIImageView*)self.selectorSelectedBarImageViews[i];
        
        if (self.selectedSelectorIndex == i) {
            //[selectorButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"caremob_follow_mode_select_button_%@_on", (NSString*)tabNames[i]]] forState:UIControlStateNormal];
            [selectorButton setBackgroundImage:[UIImage imageNamed:@"global_action_bar_bg_selected"] forState:UIControlStateNormal];
            //selectorSelectedBarImageView.hidden = NO;
            //selectorLabel.textColor = [UIColor blackColor];
        } else {
            //[selectorButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"caremob_follow_mode_select_button_%@_off",(NSString*)tabNames[i]]] forState:UIControlStateNormal];
            [selectorButton setBackgroundImage:[UIImage imageNamed:@"global_action_bar_bg"] forState:UIControlStateNormal];
            //selectorSelectedBarImageView.hidden = YES;
            //selectorLabel.textColor = [UIColor blackColor];
        }
    }
    
    // If selector 4 hit, show search bar
    if (index == kCareMobFeedTableModeSearch) {
        [self.view layoutIfNeeded];
        self.searchViewHeightConstraint.constant = 44;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
    } else {
        [self.searchTextField resignFirstResponder];
        
        [self.view layoutIfNeeded];
        self.searchViewHeightConstraint.constant = 0;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    
    // Finally switch tabs, or load the data if necessary
    if (index == kCareMobFeedTableModeTrending) {
        if (self.trendingMobs != nil) {
            [self.tableView reloadData];
            
            NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView scrollToRowAtIndexPath:topIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        }
        else [self refreshCareMobList:YES];
    } else if (index == kCareMobFeedTableModeToday) {
        if (self.topTodayMobs != nil) {
            [self.tableView reloadData];
            
            NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView scrollToRowAtIndexPath:topIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        } else [self refreshCareMobList:YES];
    } else if (index == kCareMobFeedTableModeAllTime) {
        if (self.topAllTimeMobs != nil) {
            [self.tableView reloadData];
            
            NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView scrollToRowAtIndexPath:topIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

        } else [self refreshCareMobList:YES];
    } else if (index == kCareMobFeedTableModeSearch) {
        if (self.searchMobs != nil) {
            [self.tableView reloadData];
            
            NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView scrollToRowAtIndexPath:topIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];

        } else [self refreshCareMobList:YES];
    }
    
    
}

#pragma mark - CaremobFeed_TutorialTriggerTableViewCellDelegate
-(void)tutorialTriggerDoneButtonHit {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:kNSUserDefaultsUpfrontTutorialWasShown];
    [defaults synchronize];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
}
@end
