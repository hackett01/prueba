//
//  FollowViewController.m
//  Shyft
//
//  Created by Rick Strom on 2/2/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import "FollowViewController.h"

@interface FollowViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

// Selector
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *selectorButtons;
//@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *selectorLabels;
//@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *selectorSelectedBarImageViews;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextView;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;


//- (IBAction)selectFollowingButtonHit:(id)sender;
//- (IBAction)selectFollowersButtonHit:(id)sender;

- (IBAction)selectorButtonHit:(id)sender;

@end

@implementation FollowViewController

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
    
    // Add a refresh control to our table
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl setTintColor:[UIColor darkGrayColor]];
    [self.refreshControl addTarget:self action:@selector(refreshPulled:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.refreshControl];

    //[self selectFollowingButtonHit:nil];
    
    [self selectorButtonHit:self.selectorButtons[0]];
}

-(void)viewWillAppear:(BOOL)animated {
    //[self refreshFeed:NO];
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
    if ([segue.identifier isEqualToString:@"showUserProfileViewController"]) {
        UserProfileViewController *destination = (UserProfileViewController*)segue.destinationViewController;
        
        destination.user = self.selectedUser;
    }
}


-(void)refreshPulled:(id)sender {
    if (self.isRefreshing) return;
    
    [self refreshFeed:NO];
}

-(void)refreshFeed:(BOOL)shouldUseCache {
    if (self.isRefreshing) return;
    
    self.isRefreshing = YES;
    
    PFQuery *query = [PFQuery queryWithClassName:kUserClassKey];
    
    if (self.selectedSelectorIndex == kFollowTableModeTopMobbers)
        [query orderByDescending:kUserFieldTotalMobActionValueKey];
    else if (self.selectedSelectorIndex == kFollowTableModeTopInfluencers)
        [query orderByDescending:kUserFieldInfluenceKey];
    else if (self.selectedSelectorIndex == kFollowTableModeTopTodayMobbers)
        [query orderByDescending:kUserFieldTotalMobActionValueTodayKey];
    else if (self.selectedSelectorIndex == kFollowTableModeLatestMobbers)
        [query orderByDescending:kUserFieldCreatedAtKey];
    else if (self.selectedSelectorIndex == kFollowTableModeSearch) {
        if (self.searchTextView.text != nil && self.searchTextView.text.length > 0) [query whereKey:kUserFieldNameKey matchesRegex:self.searchTextView.text modifiers:@"i"];
        [query orderByDescending:kUserFieldCreatedAtKey];
    }
    
    if (shouldUseCache)
        [query setCachePolicy:kPFCachePolicyCacheElseNetwork];
    else
        [query setCachePolicy:kPFCachePolicyNetworkElseCache];
    
    query.maxCacheAge = 60*5;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            // Just reload the table with whatever we have
            [self.refreshControl endRefreshing];
            self.isRefreshing = NO;
            
            [self.tableView reloadData];
        } else {
            if (self.selectedSelectorIndex == kFollowTableModeTopMobbers) self.topMobbers = objects;
            else if (self.selectedSelectorIndex == kFollowTableModeTopInfluencers) self.topInfluencers = objects;
            else if (self.selectedSelectorIndex == kFollowTableModeTopTodayMobbers) self.topTodayMobbers = objects;
            else if (self.selectedSelectorIndex == kFollowTableModeLatestMobbers) self.latestMobbers = objects;
            else if (self.selectedSelectorIndex == kFollowTableModeSearch) self.searchedMobbers = objects;
            
            [self.refreshControl endRefreshing];
            self.isRefreshing = NO;
            
            [self.tableView reloadData];
        }
    }];
    
    // OLD: this is how to pull up follows, but we don't do this on this screen anymore.  Kept here for reference
    /*
     
    // We need to do three fetches -- one of the list of top users, one of the list of latest user and one of the follows
    // We can do the followers/following query at once and split it upon success
    // To see quicker, we can also draw the table after receiving the list of users, and update the cells when we retrieve the follows
    
    // First query the users (or fallback to cache)
    PFQuery *topUsersQuery = [PFQuery queryWithClassName:kUserClassKey];
//    [topUsersQuery whereKey:kUserFieldObjectIdKey notEqualTo:[PFUser currentUser].objectId];
    [topUsersQuery orderByDescending:kUserFieldEffectivePointsKey];
    
    if (shouldUseCache)
        [topUsersQuery setCachePolicy:kPFCachePolicyCacheElseNetwork];
    else
        [topUsersQuery setCachePolicy:kPFCachePolicyNetworkElseCache];
    topUsersQuery.maxCacheAge = 60*60;
    
    [topUsersQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            
            [self.refreshControl endRefreshing];
            self.isRefreshing = NO;
        } else {
            self.topUsers = [NSArray arrayWithArray:objects];
            [self.tableView reloadData];
        
            NSLog(@"Follow: retrieved %lu users", (unsigned long)self.topUsers.count);
        
            // Next query the latest mobbers
            PFQuery *latestUsersQuery = [PFQuery queryWithClassName:kUserClassKey];
//            [latestUsersQuery whereKey:kUserFieldObjectIdKey notEqualTo:[PFUser currentUser].objectId];
            [latestUsersQuery orderByDescending:kUserFieldCreatedAtKey];
            
            if (shouldUseCache)
                [latestUsersQuery setCachePolicy:kPFCachePolicyCacheElseNetwork];
            else
                [latestUsersQuery setCachePolicy:kPFCachePolicyNetworkElseCache];
            latestUsersQuery.maxCacheAge = 60*60;
            
            [latestUsersQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (error) {
                    NSLog(@"%@", error.localizedDescription);
                    
                    [self.refreshControl endRefreshing];
                    self.isRefreshing = NO;
                } else {
                    self.latestUsers = [NSArray arrayWithArray:objects];
                    [self.tableView reloadData];
                    
                    NSLog(@"Follow: retrieved %lu latest users", (unsigned long)self.latestUsers.count);

                    // Now query the follows
                    PFQuery *followedQuery = [PFQuery queryWithClassName:kFollowClassKey];
                    [followedQuery whereKey:kFollowFieldFollowedKey equalTo:[PFUser currentUser]];
        
                    PFQuery *followingQuery = [PFQuery queryWithClassName:kFollowClassKey];
                    [followingQuery whereKey:kFollowFieldFollowingKey equalTo:[PFUser currentUser]];

                    PFQuery *followQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:followedQuery, followingQuery, nil]];
                    [followQuery includeKey:kFollowFieldFollowedKey];
                    [followQuery includeKey:kFollowFieldFollowingKey];
            
                    if (shouldUseCache)
                        [followQuery setCachePolicy:kPFCachePolicyCacheElseNetwork];
                    else
                        [followQuery setCachePolicy:kPFCachePolicyNetworkElseCache];
                    followQuery.maxCacheAge = 60*60;
            
                    [followQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        if (error) {
                            NSLog(@"%@", error.localizedDescription);
                        } else {
                            // Loop through results and place them in the right array
                            self.followers = [[NSMutableArray alloc] init];
                            self.following = [[NSMutableArray alloc] init];
            
                            if (objects != nil) {
                                for (int i = 0; i < objects.count; i++) {
                                    PFObject *follow = (PFObject*)[objects objectAtIndex:i];
                                    PFUser *followed = (PFUser*)[follow objectForKey:kFollowFieldFollowedKey];
                                    PFUser *following = (PFUser*)[follow objectForKey:kFollowFieldFollowingKey];
                    
                                    if ([followed.objectId isEqualToString:[PFUser currentUser].objectId]) [self.followers addObject:following];
                                    else if ([following.objectId isEqualToString:[PFUser currentUser].objectId]) [self.following addObject:followed];
                                }
                        
                                NSLog(@"Follow: retrieved %lu followers and %lu following", (unsigned long)self.followers.count, (unsigned long)self.following.count);
                        
                                // Reload the table again
                                [self.tableView reloadData];
                            }
            
                            [self.refreshControl endRefreshing];
                            self.isRefreshing = NO;

                        }
                    }];
                }
            }];
        }
    }];
     
     */
}

/* BACKUP while I dick around
-(void)refreshFeed:(BOOL)shouldUseCache {
    // We need to do three fetches -- one of the list of top users, one of the list of and one of the follows
    // We can do the followers/following query at once and split it upon success
    // To see quicker, we can also draw the table after receiving the list of users, and update the cells when we retrieve the follows
    
    // First query the users (or fallback to cache)
    PFQuery *userQuery = [PFQuery queryWithClassName:kUserClassKey];
    [userQuery whereKey:kUserFieldObjectIdKey notEqualTo:[PFUser currentUser].objectId];
    [userQuery orderByAscending:kUserFieldNameKey];
    [userQuery setCachePolicy:kPFCachePolicyNetworkOnly];
    [userQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        } else {
            self.users = [NSArray arrayWithArray:objects];
            [self.followTableView reloadData];
            
            NSLog(@"Follow: retrieved %lu users", (unsigned long)self.users.count);
            
            // Now query the follows
            PFQuery *followedQuery = [PFQuery queryWithClassName:kFollowClassKey];
            [followedQuery whereKey:kFollowFieldFollowedKey equalTo:[PFUser currentUser]];
            
            PFQuery *followingQuery = [PFQuery queryWithClassName:kFollowClassKey];
            [followingQuery whereKey:kFollowFieldFollowingKey equalTo:[PFUser currentUser]];
            
            PFQuery *followQuery = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:followedQuery, followingQuery, nil]];
            [followQuery includeKey:kFollowFieldFollowedKey];
            [followQuery includeKey:kFollowFieldFollowingKey];
            [followQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (error) {
                    NSLog(@"%@", error.localizedDescription);
                } else {
                    // Loop through results and place them in the right array
                    self.followers = [[NSMutableArray alloc] init];
                    self.following = [[NSMutableArray alloc] init];
                    
                    if (objects != nil) {
                        for (int i = 0; i < objects.count; i++) {
                            PFObject *follow = (PFObject*)[objects objectAtIndex:i];
                            PFUser *followed = (PFUser*)[follow objectForKey:kFollowFieldFollowedKey];
                            PFUser *following = (PFUser*)[follow objectForKey:kFollowFieldFollowingKey];
                            
                            if ([followed.objectId isEqualToString:[PFUser currentUser].objectId]) [self.followers addObject:following];
                            else if ([following.objectId isEqualToString:[PFUser currentUser].objectId]) [self.following addObject:followed];
                        }
                        
                        NSLog(@"Follow: retrieved %lu followers and %lu following", (unsigned long)self.followers.count, (unsigned long)self.following.count);
                        
                        // Reload the table again
                        [self.followTableView reloadData];
                    }
                    
                    
                }
            }];
        }
    }];
}
*/

-(void)back {

}

#pragma mark - UITableViewDelegateMethods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.selectedSelectorIndex == kFollowTableModeTopMobbers) {
        if (self.topMobbers == nil || self.topMobbers.count == 0) return 1;
        else return self.topMobbers.count;
    } else if (self.selectedSelectorIndex == kFollowTableModeTopInfluencers) {
        if (self.topInfluencers == nil || self.topInfluencers.count == 0) return 1;
        else return self.topInfluencers.count;
    } else if (self.selectedSelectorIndex == kFollowTableModeTopTodayMobbers) {
        if (self.topTodayMobbers == nil || self.topTodayMobbers.count == 0) return 1;
        else return self.topTodayMobbers.count;
    } else if (self.selectedSelectorIndex == kFollowTableModeLatestMobbers) {
        if (self.latestMobbers == nil || self.latestMobbers.count == 0) return 1;
        else return self.latestMobbers.count;
    } else if (self.selectedSelectorIndex == kFollowTableModeSearch) {
        if (self.searchedMobbers == nil || self.searchedMobbers.count == 0) return 1;
        else return self.searchedMobbers.count;
    } else return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier;
    
    PFUser *cellUser;
    
    if (self.selectedSelectorIndex == kFollowTableModeTopMobbers) {
        if (self.topMobbers != nil && indexPath.row < self.topMobbers.count)
            cellUser = (PFUser*)self.topMobbers[indexPath.row];
    } else if (self.selectedSelectorIndex == kFollowTableModeTopInfluencers) {
        if (self.topInfluencers != nil && indexPath.row < self.topInfluencers.count)
            cellUser = (PFUser*)self.topInfluencers[indexPath.row];
    } else if (self.selectedSelectorIndex == kFollowTableModeTopTodayMobbers) {
        if (self.topTodayMobbers != nil && indexPath.row < self.topTodayMobbers.count)
            cellUser = (PFUser*)self.topTodayMobbers[indexPath.row];
    } else if (self.selectedSelectorIndex == kFollowTableModeLatestMobbers) {
        if (self.latestMobbers != nil && indexPath.row < self.latestMobbers.count)
            cellUser = (PFUser*)self.latestMobbers[indexPath.row];
    } else if (self.selectedSelectorIndex == kFollowTableModeSearch) {
        if (self.searchedMobbers != nil && indexPath.row < self.searchedMobbers.count)
            cellUser = (PFUser*)self.searchedMobbers[indexPath.row];
    }

    if (cellUser == nil) {
        CellIdentifier = @"Follow_NoUsersTableViewCell";
        
        Follow_NoUsersTableViewCell *cell = (Follow_NoUsersTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = (Follow_NoUsersTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else {
        
        CellIdentifier = @"Follow_GenericUserTableViewCell";
        
        Follow_GenericUserTableViewCell *cell = (Follow_GenericUserTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = (Follow_GenericUserTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        [cell setUser:cellUser];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.rankLabel.text = [NSString stringWithFormat:@"%d.", (int)(indexPath.row + 1)];
        
        if (self.selectedSelectorIndex == kFollowTableModeTopMobbers) {
            //REMOVED 10.27.2015 now showing total time
            /*
            cell.valueIcon.image = [UIImage imageNamed:@"mobbers_icon_level"];
            NSNumber *level = (NSNumber*)[cellUser objectForKey:kUserFieldLevelKey];
            cell.valueLabel.text = [NSString stringWithFormat:@"%d", [level intValue]];
            */
            
            cell.valueIcon.image = [UIImage imageNamed:@"mobbers_icon_time"];
            NSNumber *totalMobActionValue = (NSNumber*)[cellUser objectForKey:kUserFieldTotalMobActionValueKey];
            cell.valueLabel.text = [CareMobHelper timeToString:[totalMobActionValue doubleValue]];
            
            cell.valueIcon.hidden = NO;
        } else if (self.selectedSelectorIndex == kFollowTableModeTopInfluencers) {
            cell.valueIcon.image = [UIImage imageNamed:@"mobbers_icon_influence"];
            NSNumber *influence = (NSNumber*)[cellUser objectForKey:kUserFieldInfluenceKey];
            cell.valueLabel.text = [NSString stringWithFormat:@"%d", [influence intValue]];
            
            cell.valueIcon.hidden = NO;
        }  else if (self.selectedSelectorIndex == kFollowTableModeTopTodayMobbers) {
            cell.valueIcon.image = [UIImage imageNamed:@"mobbers_icon_time"];
            NSNumber *mobActionValueToday = (NSNumber*)[cellUser objectForKey:kUserFieldTotalMobActionValueTodayKey];
            cell.valueLabel.text = [NSString stringWithFormat:@"%@", [CareMobHelper timeToString:[mobActionValueToday doubleValue]]];
            
            cell.valueIcon.hidden = NO;
        }  else if (self.selectedSelectorIndex == kFollowTableModeLatestMobbers) {
            cell.valueLabel.text = @"";
            
            cell.valueIcon.hidden = YES;
        }  else if (self.selectedSelectorIndex == kFollowTableModeSearch) {
            //cell.valueIcon.image = [UIImage imageNamed:@"mobbers_icon_level"];
            //NSNumber *level = (NSNumber*)[cellUser objectForKey:kUserFieldLevelKey];
            //cell.valueLabel.text = [NSString stringWithFormat:@"%d", [level intValue]];
            
            //cell.valueIcon.hidden = NO;
            
            cell.valueLabel.text = @"";
            
            cell.valueIcon.hidden = YES;
        }
        
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 38.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *user = nil;
    
    if (self.selectedSelectorIndex == kFollowTableModeTopMobbers) {
        if (self.topMobbers != nil && indexPath.row < self.topMobbers.count) user = (PFObject*)self.topMobbers[indexPath.row];
    } else if (self.selectedSelectorIndex == kFollowTableModeTopInfluencers) {
        if (self.topInfluencers != nil && indexPath.row < self.topInfluencers.count) user = (PFObject*)self.topInfluencers[indexPath.row];
    } else if (self.selectedSelectorIndex == kFollowTableModeTopTodayMobbers) {
        if (self.topTodayMobbers != nil && indexPath.row < self.topTodayMobbers.count) user = (PFObject*)self.topTodayMobbers[indexPath.row];
    } else if (self.selectedSelectorIndex == kFollowTableModeLatestMobbers) {
        if (self.latestMobbers != nil && indexPath.row < self.latestMobbers.count) user = (PFObject*)self.latestMobbers[indexPath.row];
    } else if (self.selectedSelectorIndex == kFollowTableModeSearch) {
        if (self.searchedMobbers != nil && indexPath.row < self.searchedMobbers.count) user = (PFObject*)self.searchedMobbers[indexPath.row];
    }
    
    if (user != nil) {
        self.selectedUser = user;
    
        [self performSegueWithIdentifier:@"showUserProfileViewController" sender:self];
    }
}


/*
-(void)follow:(PFUser*)user {
    if (self.following == nil) return;
    

    BOOL isFollowing = NO;
    
//    if ([self.following containsObject:user])
    for (int i = 0; i < self.following.count; i++) {
        PFUser *u = (PFUser*)self.following[i];
        if ([u.objectId isEqualToString:user.objectId]) {
            user = u;
            isFollowing = YES;
        }
    }
    
    if (!isFollowing) {
        NSLog(@"Adding follow");
        
        // Create a new follow for this user, add it to the following array, and reload
        [self.following addObject:user];
        
        PFObject *newFollow = [PFObject objectWithClassName:kFollowClassKey];
        [newFollow setObject:[PFUser currentUser] forKey:kFollowFieldFollowingKey];
        [newFollow setObject:user forKey:kFollowFieldFollowedKey];
        [newFollow saveEventually];
        
        [self.tableView reloadData];
    } else {
        NSLog(@"Deleting follow");
        
        // Delete the follow from Parse, remove the user from the following array, and reload
        [self.following removeObject:user];
        [self.tableView reloadData];
        
        PFQuery *deleteQuery = [PFQuery queryWithClassName:kFollowClassKey];
        [deleteQuery whereKey:kFollowFieldFollowingKey equalTo:[PFUser currentUser]];
        [deleteQuery whereKey:kFollowFieldFollowedKey equalTo:user];
        [deleteQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            } else {
                if (objects.count > 0)
                    [objects[0] deleteEventually];
            }
        }];
    }
    
    NSLog(@"%d follows remaining", (int)self.following.count);
}
*/

/*
- (IBAction)selectFollowingButtonHit:(id)sender {
    if (self.tableMode == kFollowTableModeFollowing) return;
    
    self.tableMode = kFollowTableModeFollowing;


    //self.selectFollowingButtonBackgroundImageView.image = [UIImage imageNamed:@"caremob_follow_selected_bg"];
    //self.selectFollowersButtonBackgroundImageView.image = [UIImage imageNamed:@"caremob_follow_unselected_bg"];
    
    [self.tableView reloadData];
}

- (IBAction)selectFollowersButtonHit:(id)sender {
    if (self.tableMode == kFollowTableModeFollowers) return;
    
    self.tableMode = kFollowTableModeFollowers;
    
    //self.selectFollowingButtonBackgroundImageView.image = [UIImage imageNamed:@"caremob_follow_unselected_bg"];
    //self.selectFollowersButtonBackgroundImageView.image = [UIImage imageNamed:@"caremob_follow_selected_bg"];
    
    [self.tableView reloadData];

}
*/

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
    if (index == kFollowTableModeSearch) {
        [self.view layoutIfNeeded];
        self.searchViewHeightConstraint.constant = 44;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
    } else {
        [self.searchTextView resignFirstResponder];
        
        [self.view layoutIfNeeded];
        self.searchViewHeightConstraint.constant = 0;
        [UIView animateWithDuration:0.5 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    
    // Finally switch tabs, or load the data if necessary
    if (index == kFollowTableModeTopMobbers) {
        if (self.topMobbers != nil) [self.tableView reloadData];
        else [self refreshFeed:YES];
        
        self.headerLabel.text = @"ALL TIME TOP MOBBERS";
    } else if (index == kFollowTableModeTopInfluencers) {
        if (self.topInfluencers != nil) [self.tableView reloadData];
        else [self refreshFeed:YES];
        
        self.headerLabel.text = @"ALL TIME MOST INFLUENTIAL MOBBERS";
    } else if (index == kFollowTableModeTopTodayMobbers) {
        if (self.topTodayMobbers != nil) [self.tableView reloadData];
        else [self refreshFeed:YES];
        
        self.headerLabel.text = @"MOST TIME TODAY";
    } else if (index == kFollowTableModeLatestMobbers) {
        if (self.latestMobbers != nil) [self.tableView reloadData];
        else [self refreshFeed:YES];
        
        self.headerLabel.text = @"LATEST MOBBERS";
    } else if (index == kFollowTableModeSearch) {
        if (self.searchedMobbers != nil) [self.tableView reloadData];
        else [self refreshFeed:YES];
        
        self.headerLabel.text = @"SEARCH USERS";
    }
    

}

#pragma mark UITextField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    //if (self.searchTextField.text.length > 0)
    [self refreshFeed:NO];
    
    [textField resignFirstResponder];
    
    return YES;
}

@end
