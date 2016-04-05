//
//  ActivityFeedViewController.m
//  Shyft
//
//  Created by Rick Strom on 11/19/14.
//  Copyright (c) 2014 Rick Strom. All rights reserved.
//

#import "ActivityFeedViewController.h"

@interface ActivityFeedViewController ()
@property (weak, nonatomic) IBOutlet UITableView *activitiesTableView;

@end

@implementation ActivityFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Configure the navigation bar
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"caremob_navbar_logo"]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:12.0/255.0 green:105.0/255.0 blue:148.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UIBarButtonItem *MyBackButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    MyBackButton.title = @"";
    
    NSDictionary *myBackButtonTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                [UIFont fontWithName:@"NettoOT" size:16.0f], NSFontAttributeName,
                                                nil];
    [MyBackButton setTitleTextAttributes:myBackButtonTextAttributes forState:UIControlStateNormal];
    [MyBackButton setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.backBarButtonItem = MyBackButton;
    
    // Add a refresh control to the collection view
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(refreshControlPulled) forControlEvents:UIControlEventValueChanged];
    [self.activitiesTableView addSubview:self.refreshControl];
    
    /*
    // Add the user level control to the nav bar
    self.userLevelViewController = [[UserLevelControlViewController alloc] initWithNibName:@"UserLevelControlViewController" bundle:nil];
    
    [self.navigationController.navigationBar addSubview:self.userLevelViewController.view];
    
    [self.userLevelViewController setFrameRelativeTo:self.navigationController.navigationBar];
    [self.userLevelViewController initialize];
    */
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidPerformMobAction:) name:kNSNotificationMobActionWasPerformed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newActivityIsAvailable:) name:kNSNotificationNewActivityIsAvailable object:nil];

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.activities == nil)
        [self loadActivity:YES];
    
    // Clear the badge for this tab
    [[self navigationController] tabBarItem].badgeValue = nil;
    
    if (self.activities != nil && self.activities.count > 0) {
        PFObject *lastActivity = (PFObject*)self.activities[0];
        NSString *lastActivityId = [NSString stringWithString:lastActivity.objectId];
        
        [[NSUserDefaults standardUserDefaults] setValue:lastActivityId forKey:kNSUserDefaultsLastRetrievedActivity];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

-(void)userDidPerformMobAction:(NSNotification*)notification {
    if (self.userLevelViewController != nil) [self.userLevelViewController userNeedsRefresh];
}

-(void)newActivityIsAvailable:(NSNotification*)notification {
    [self loadActivity:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        destination.followingUser = self.followingUser;
        
    } else if ([segue.identifier isEqualToString:@"showUserProfileViewController"]) {
        UserProfileViewController *destination = (UserProfileViewController*)segue.destinationViewController;
        
        destination.user = self.selectedUser;
    }
}

/*
-(void)showMyProfile {
    [self performSegueWithIdentifier:@"showMyProfileViewController" sender:self];
}
*/

-(void)back {
    
}


-(void)refreshControlPulled {
    if (self.isRefreshing) return;
    self.isRefreshing = YES;
    [self loadActivity:NO];
}

-(void)loadActivity:(BOOL)useCache {
    
    PFQuery *activityQuery = [PFQuery queryWithClassName:kActivityClassKey];
    [activityQuery whereKey:kActivityFieldUserKey equalTo:[PFUser currentUser]];
    [activityQuery includeKey:kActivityFieldTargetCareMobKey];
    [activityQuery includeKey:[NSString stringWithFormat:@"%@.%@", kActivityFieldTargetCareMobKey, kCareMobSubMobsKey]];
    [activityQuery includeKey:[NSString stringWithFormat:@"%@.%@", kActivityFieldTargetCareMobKey, kCareMobSourceUserKey]];
    [activityQuery includeKey:kActivityFieldTargetSubMobKey];
    [activityQuery includeKey:kActivityFieldTargetUserKey];
    [activityQuery includeKey:kActivityFieldTargetMobActionKey];
    [activityQuery includeKey:kActivityFieldTargetRedeemablePointsKey];
    [activityQuery orderByDescending:kActivityFieldCreatedAtKey];
    
    if (useCache)
        [activityQuery setCachePolicy:kPFCachePolicyCacheThenNetwork];
    else
        [activityQuery setCachePolicy:kPFCachePolicyNetworkOnly];
    
    [activityQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            if (self.isRefreshing) {
                [self.refreshControl endRefreshing];
                self.isRefreshing = NO;
            }
        } else {
            self.activities = [NSArray arrayWithArray:objects];
            
            if (self.isRefreshing) {
                [self.refreshControl endRefreshing];
                self.isRefreshing = NO;
            }
            
            // Aggregate the activity
            self.activities = [CareMobHelper aggregateActivityArray:self.activities];
            
            [self.activitiesTableView reloadData];

            // Figure out how many new activities we have
            int newActivityCount = 0;

            if (self.activities != nil && self.activities.count > 0) {
                //PFObject *lastActivity = (PFObject*)self.activities[0];
                //NSString *lastActivityId = [NSString stringWithString:lastActivity.objectId];
                
                NSString *lastRetrievedActivityId = [[NSUserDefaults standardUserDefaults] stringForKey:kNSUserDefaultsLastRetrievedActivity];
                if (lastRetrievedActivityId == nil) {
                    newActivityCount = (int)self.activities.count;
                } else {
                    // Iterate through values until we hit the last
                    for (int i = 0 ; i < self.activities.count; i++) {
                        PFObject *thisActivity = (PFObject*)self.activities[i];
                        if ([thisActivity.objectId isEqualToString:lastRetrievedActivityId]) {
                            break;
                        } else {
                            newActivityCount++;
                        }
                    }
                }
                
                
            }
            
            NSLog(@"new activity count is %d", newActivityCount);
            if (newActivityCount == 0)
                [[self navigationController] tabBarItem].badgeValue = nil;
            else
                [[self navigationController] tabBarItem].badgeValue = [NSString stringWithFormat:@"%d", newActivityCount];
            
            [self requestRemoteNotifications];
        }
    }];
}

#pragma mark - UITableViewDelegateMethods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.activities == nil) return 0;
    else return self.activities.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFObject *activity = self.activities[indexPath.row];
    NSString *type = (NSString*)[activity objectForKey:kActivityFieldTypeKey];
    
    static NSString *CellIdentifier;
    
    if ([type isEqualToString:kActivityTypeCareMobLeveledUp]) {
        CellIdentifier = @"ActivityFeed_CareMobLeveledUpTableViewCell";
        
        ActivityFeed_CareMobLeveledUpTableViewCell *cell = (ActivityFeed_CareMobLeveledUpTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = (ActivityFeed_CareMobLeveledUpTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell...
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        [cell setMyActivity:activity];
    
        return cell;
    } else if ([type isEqualToString:kActivityTypeSubMobLeveledUp]) {
        CellIdentifier = @"ActivityFeed_SubMobLeveledUpTableViewCell";
        
        ActivityFeed_SubMobLeveledUpTableViewCell *cell = (ActivityFeed_SubMobLeveledUpTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = (ActivityFeed_SubMobLeveledUpTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell...
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setMyActivity:activity];
        
        return cell;
    } else if ([type isEqualToString:kActivityTypeUserLeveledUp]) {
        CellIdentifier = @"ActivityFeed_UserLeveledUpTableViewCell";
        
        ActivityFeed_UserLeveledUpTableViewCell *cell = (ActivityFeed_UserLeveledUpTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = (ActivityFeed_UserLeveledUpTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell...
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setMyActivity:activity];
        
        return cell;
    } else if ([type isEqualToString:kActivityTypeUserJoined]) {
        CellIdentifier = @"ActivityFeed_UserJoinedTableViewCell";
        
        ActivityFeed_UserJoinedTableViewCell *cell = (ActivityFeed_UserJoinedTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = (ActivityFeed_UserJoinedTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell...
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setMyActivity:activity];
        
        return cell;
    } else if ([type isEqualToString:kActivityTypeUserFollowed]) {
        CellIdentifier = @"ActivityFeed_UserFollowedTableViewCell";
        
        ActivityFeed_UserFollowedTableViewCell *cell = (ActivityFeed_UserFollowedTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = (ActivityFeed_UserFollowedTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell...
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setMyActivity:activity];
        
        return cell;
    } else if ([type isEqualToString:kActivityTypeUserEnteredSubMob]) {
        CellIdentifier = @"ActivityFeed_UserEnteredSubMobTableViewCell";
        
        ActivityFeed_UserEnteredSubMobTableViewCell *cell = (ActivityFeed_UserEnteredSubMobTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = (ActivityFeed_UserEnteredSubMobTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell...
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setMyActivity:activity];
        
        return cell;
    } else if ([type isEqualToString:kActivityTypeUserFollowedIntoSubMob]) {
        CellIdentifier = @"ActivityFeed_UserFollowedIntoSubMobTableViewCell";
        
        ActivityFeed_UserFollowedIntoSubMobTableViewCell *cell = (ActivityFeed_UserFollowedIntoSubMobTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = (ActivityFeed_UserFollowedIntoSubMobTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell...
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setMyActivity:activity];
        
        return cell;
    } else if ([type isEqualToString:kActivityTypeUserCreatedCareMob]) {
        CellIdentifier = @"ActivityFeed_UserCreatedCareMobTableViewCell";
        
        ActivityFeed_UserCreatedCareMobTableViewCell *cell = (ActivityFeed_UserCreatedCareMobTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = (ActivityFeed_UserCreatedCareMobTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell...
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell setMyActivity:activity];
        
        return cell;
        

    } else {
        CellIdentifier = @"ActivityFeed_UnknownTableViewCell";
        
        ActivityFeed_UnknownTableViewCell *cell = (ActivityFeed_UnknownTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = (ActivityFeed_UnknownTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        // Configure the cell...
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    return nil;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//   [cell setBackgroundColor:[UIColor clearColor]];
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.activities != nil && self.activities.count > 0) {
        PFObject *activity = (PFObject*)self.activities[indexPath.row];
        NSString *activityType = (NSString*)[activity objectForKey:kActivityFieldTypeKey];
        if ([activityType isEqualToString:kActivityTypeUserEnteredSubMob]) return 315.0f;
        else return 64.0;
    } else return 64.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    PFObject *selectedActivity = self.activities[indexPath.row];
    NSString *type = [selectedActivity objectForKey:kActivityFieldTypeKey];
    PFObject *redeemablePoints = (PFObject*)[selectedActivity objectForKey:kActivityFieldTargetRedeemablePointsKey];
    
    if ([type isEqualToString:kActivityTypeCareMobLeveledUp]) {
        self.selectedCareMob = (PFObject*)[selectedActivity objectForKey:kActivityFieldTargetCareMobKey];
        self.selectedCategoryContext = nil;
        
        [self performSegueWithIdentifier:@"showCaremobDisplayViewController" sender:self];
        
    } else if ([type isEqualToString:kActivityTypeSubMobLeveledUp]) {
        if (redeemablePoints != nil) {
            
            NSNumber *wasRedeemed = (NSNumber*)[redeemablePoints objectForKey:kRedeemablePointsFieldWasRedeemedKey];
            if ([wasRedeemed boolValue] == YES) {
                // Load the mob
                self.selectedCareMob = (PFObject*)[selectedActivity objectForKey:kActivityFieldTargetCareMobKey];
                self.selectedSubMob = (PFObject*)[selectedActivity objectForKey:kActivityFieldTargetSubMobKey];
                self.selectedCategoryContext = (NSString*)[self.selectedSubMob objectForKey:kSubMobCategoryKey];
                
                [self performSegueWithIdentifier:@"showCaremobDisplayViewController" sender:self];
            } else {
                
                // Hide the overlay and redeem the points
                ActivityFeed_SubMobLeveledUpTableViewCell *cell = (ActivityFeed_SubMobLeveledUpTableViewCell*)[self.activitiesTableView cellForRowAtIndexPath:indexPath];
                
                if (!cell.isBusy) {
                    [cell showActivityIndicator];
                    
                    NSDictionary *params = @{@"activity":selectedActivity.objectId};
                    
                    [PFCloud callFunctionInBackground:kCloudFunctionRedeemPointsKey withParameters:params block:^(PFObject *result, NSError *error) {
                        
                        [cell hideActivityIndicator];
                        
                        if (error) {
                            [[[UIAlertView alloc] initWithTitle:@"Can't redeem points" message:@"Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                        } else {
                            [cell hideRedeemablePointsView];
                            
                            [redeemablePoints setValue:[NSNumber numberWithBool:YES] forKey:kRedeemablePointsFieldWasRedeemedKey];
                            
                            // Post a notification that an action was performed
                            // This notification should be received by the UserLevelControlView if one is active, causing it to refresh the uer and show the new user level and points
                            NSLog(@"Posting notification");
                            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationMobActionWasPerformed object:nil];
                            
                            [[Sound soundNamed:kSoundPointsCollected] play];
                        }
                    }];
                }
            }
        } else {
            // Load the mob
            self.selectedCareMob = (PFObject*)[selectedActivity objectForKey:kActivityFieldTargetCareMobKey];
            self.selectedSubMob = (PFObject*)[selectedActivity objectForKey:kActivityFieldTargetSubMobKey];
            self.selectedCategoryContext = (NSString*)[self.selectedSubMob objectForKey:kSubMobCategoryKey];
            
            [self performSegueWithIdentifier:@"showCaremobDisplayViewController" sender:self];
        }
        
        /*
        self.selectedCareMob = (PFObject*)[selectedActivity objectForKey:kActivityFieldTargetCareMobKey];
        self.selectedSubMob = (PFObject*)[selectedActivity objectForKey:kActivityFieldTargetSubMobKey];
        self.selectedCategoryContext = (NSString*)[self.selectedSubMob objectForKey:kSubMobCategoryKey];
        
        [self performSegueWithIdentifier:@"showCaremobDisplayViewController" sender:self];
        */
    } else if ([type isEqualToString:kActivityTypeUserLeveledUp]) {
        self.selectedUser = (PFUser*)[selectedActivity objectForKey:kActivityFieldTargetUserKey];
        
        [self performSegueWithIdentifier:@"showUserProfileViewController" sender:self];
    } else if ([type isEqualToString:kActivityTypeUserEnteredSubMob]) {
        self.selectedCareMob = (PFObject*)[selectedActivity objectForKey:kActivityFieldTargetCareMobKey];
        self.selectedSubMob = (PFObject*)[selectedActivity objectForKey:kActivityFieldTargetSubMobKey];
        self.selectedCategoryContext = (NSString*)[self.selectedSubMob objectForKey:kSubMobCategoryKey];
        self.followingUser = (PFUser*)[selectedActivity objectForKey:kActivityFieldTargetUserKey];
        
        [self performSegueWithIdentifier:@"showCaremobDisplayViewController" sender:self];
    } else if ([type isEqualToString:kActivityTypeUserCreatedCareMob]) {
            self.selectedCareMob = (PFObject*)[selectedActivity objectForKey:kActivityFieldTargetCareMobKey];
            self.selectedCategoryContext = (NSString*)[selectedActivity objectForKey:kActivityFieldStringValueKey];
            self.followingUser = (PFUser*)[selectedActivity objectForKey:kActivityFieldTargetUserKey];
            
            [self performSegueWithIdentifier:@"showCaremobDisplayViewController" sender:self];
    } else if ([type isEqualToString:kActivityTypeUserJoined]) {
        self.selectedUser = (PFUser*)[selectedActivity objectForKey:kActivityFieldTargetUserKey];
        
        [self performSegueWithIdentifier:@"showUserProfileViewController" sender:self];
    } else if ([type isEqualToString:kActivityTypeUserFollowed]) {
        self.selectedUser = (PFUser*)[selectedActivity objectForKey:kActivityFieldTargetUserKey];
        
        [self performSegueWithIdentifier:@"showUserProfileViewController" sender:self];
    } else if ([type isEqualToString:kActivityTypeUserFollowedIntoSubMob]) {
        if (redeemablePoints != nil) {
            
            NSNumber *wasRedeemed = (NSNumber*)[redeemablePoints objectForKey:kRedeemablePointsFieldWasRedeemedKey];
            if ([wasRedeemed boolValue] == YES) {
                // Load the mob
                self.selectedCareMob = (PFObject*)[selectedActivity objectForKey:kActivityFieldTargetCareMobKey];
                self.selectedSubMob = (PFObject*)[selectedActivity objectForKey:kActivityFieldTargetSubMobKey];
                self.selectedCategoryContext = (NSString*)[self.selectedSubMob objectForKey:kSubMobCategoryKey];
                
                [self performSegueWithIdentifier:@"showCaremobDisplayViewController" sender:self];
            } else {
            
                // Hide the overlay and redeem the points
                ActivityFeed_UserFollowedIntoSubMobTableViewCell *cell = (ActivityFeed_UserFollowedIntoSubMobTableViewCell*)[self.activitiesTableView cellForRowAtIndexPath:indexPath];
            
                if (!cell.isBusy) {
                    [cell showActivityIndicator];
            
                    NSDictionary *params = @{@"activity":selectedActivity.objectId};
            
                    [PFCloud callFunctionInBackground:kCloudFunctionRedeemPointsKey withParameters:params block:^(PFObject *result, NSError *error) {

                        [cell hideActivityIndicator];
                
                        if (error) {
                            [[[UIAlertView alloc] initWithTitle:@"Can't redeem points" message:@"Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                        } else {
                            [cell hideRedeemablePointsView];
                
                            [redeemablePoints setValue:[NSNumber numberWithBool:YES] forKey:kRedeemablePointsFieldWasRedeemedKey];
                        
                            // Post a notification that an action was performed
                            // This notification should be received by the UserLevelControlView if one is active, causing it to refresh the uer and show the new user level and points
                            NSLog(@"Posting notification");
                            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationMobActionWasPerformed object:nil];
                            
                            [[Sound soundNamed:kSoundPointsCollected] play];
                        }
                    }];
                }
            }
        } else {
            // Load the mob
            self.selectedCareMob = (PFObject*)[selectedActivity objectForKey:kActivityFieldTargetCareMobKey];
            self.selectedSubMob = (PFObject*)[selectedActivity objectForKey:kActivityFieldTargetSubMobKey];
            self.selectedCategoryContext = (NSString*)[self.selectedSubMob objectForKey:kSubMobCategoryKey];
            
            [self performSegueWithIdentifier:@"showCaremobDisplayViewController" sender:self];
        }
    }
}

#pragma mark - Delayed check for remote notifications
-(void)requestRemoteNotifications {
    if (self.activities == nil || self.activities.count == 0) return;
    
    UIApplication *application = [UIApplication sharedApplication];
    BOOL enabled;
    
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)]) {
        enabled = [application isRegisteredForRemoteNotifications];
    } else {
        UIRemoteNotificationType types = [application enabledRemoteNotificationTypes];
        enabled = types & UIRemoteNotificationTypeAlert;
    }
    
    if (enabled == YES) return;
    
    // Else request notifications now
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeNewsstandContentAvailability)];
    }
}

@end
