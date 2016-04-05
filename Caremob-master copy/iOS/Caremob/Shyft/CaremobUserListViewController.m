//
//  CaremobUserListViewController.m
//  Caremob
//
//  Created by Rick Strom on 10/23/15.
//  Copyright © 2015 Rick Strom. All rights reserved.
//

#import "CaremobUserListViewController.h"

@interface CaremobUserListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;

@end

@implementation CaremobUserListViewController

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
    
    // Add a refresh control to our table
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl setTintColor:[UIColor darkGrayColor]];
    [self.refreshControl addTarget:self action:@selector(refreshPulled:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.refreshControl];
    
    if (self.selectedMode == kCaremobUserListTableModeTopMobbers) self.headerLabel.text = @"TOP MOBBERS";
    else if (self.selectedMode == kCaremobUserListTableModeFirstMobbers) self.headerLabel.text = @"FIRST MOBBERS";
    else if (self.selectedMode == kCaremobUserListTableModeNearbyMobbers) self.headerLabel.text = @"NEARBY MOBBERS";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back {
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self refreshFeed:NO];
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
    
    PFQuery *query = [PFQuery queryWithClassName:kMobActionClassKey];
    [query includeKey:kMobActionUserKey];
    [query whereKey:kMobActionCareMobKey equalTo:self.careMob];
    [query whereKey:kMobActionSubMobKey equalTo:self.subMob];
    
    if (self.selectedMode == kCaremobUserListTableModeFirstMobbers)
        [query orderByAscending:kMobActionCreatedAtKey];
    else if (self.selectedMode == kCaremobUserListTableModeTopMobbers)
        [query orderByDescending:kMobActionValueKey];
    else if (self.selectedMode == kCaremobUserListTableModeNearbyMobbers) {
        [query whereKey:kMobActionLocationKey nearGeoPoint:self.location];
        [query whereKey:kMobActionUserKey notEqualTo:[PFUser currentUser]];
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
            self.mobActions = objects;
            
            [self.refreshControl endRefreshing];
            self.isRefreshing = NO;
            
            [self.tableView reloadData];
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
    if (self.mobActions == nil || self.mobActions.count == 0) return 1;
    else return self.mobActions.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier;
    
    PFUser *cellUser = nil;
    PFObject *mobAction = nil;

    if (self.mobActions != nil && indexPath.row < self.mobActions.count) {
        mobAction = (PFObject*)self.mobActions[indexPath.row];
        
        cellUser = (PFUser*)[mobAction objectForKey:kMobActionUserKey];
    }
    
    if (cellUser == nil) {
        CellIdentifier = @"CaremobUserList_NoUsersTableViewCell";
        
        CaremobUserList_NoUsersTableViewCell *cell = (CaremobUserList_NoUsersTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = (CaremobUserList_NoUsersTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    } else {
        
        CellIdentifier = @"CaremobUserList_GenericUserTableViewCell";
        
        CaremobUserList_GenericUserTableViewCell *cell = (CaremobUserList_GenericUserTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = (CaremobUserList_GenericUserTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        [cell setUser:cellUser];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.rankLabel.text = [NSString stringWithFormat:@"%d.", (int)(indexPath.row + 1)];
        
        if (self.selectedMode == kCaremobUserListTableModeTopMobbers) {
            NSNumber *timeNumber = [mobAction objectForKey:kMobActionValueKey];
            double time = [timeNumber doubleValue];
            
            cell.valueIcon.image = [UIImage imageNamed:@"mobbers_icon_time"];
            cell.valueLabel.text = [NSString stringWithFormat:@"%@", [CareMobHelper timeToString:time]];
            cell.valueIcon.hidden = NO;
        } else if (self.selectedMode == kCaremobUserListTableModeFirstMobbers) {
            cell.valueLabel.text = [NSString stringWithFormat:@"%@ ago",[mobAction.createdAt shortTimeAgoSinceDate:[NSDate date]]];
            cell.valueIcon.hidden = YES;
        } else if (self.selectedMode == kCaremobUserListTableModeNearbyMobbers) {
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

    // select a user and load the user view
    if (self.mobActions != nil && indexPath.row < self.mobActions.count) {
        PFObject *mobAction = (PFObject*)self.mobActions[indexPath.row];
        self.selectedUser = [mobAction objectForKey:kMobActionUserKey];
        
        [self performSegueWithIdentifier:@"showUserProfileViewController" sender:self];
    }
}


@end
