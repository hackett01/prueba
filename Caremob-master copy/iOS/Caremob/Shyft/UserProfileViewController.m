//
//  UserProfileViewController.m
//  Caremob
//
//  Created by Rick Strom on 10/15/15.
//  Copyright © 2015 Rick Strom. All rights reserved.
//

#import "UserProfileViewController.h"

@interface UserProfileViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *selectorButtons;


- (IBAction)selectorButtonHit:(id)sender;
@end

@implementation UserProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Register the reuse identifiers for our custom section headers
    [self.tableView registerNib:[UINib nibWithNibName:@"UserProfile_LatestMobsSectionHeaderViewController" bundle:nil] forHeaderFooterViewReuseIdentifier:@"UserProfile_LatestMobsSectionHeaderViewController"];

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
    
    // Start by showing all latest mobs
    self.selectedCategory = @"";
    
    self.selectedSelectorIndex = -1;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.user == nil && [PFUser currentUser] != nil) {
        self.user = [PFUser currentUser];

        [self.user fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            if (self.selectedSelectorIndex < 0)
                [self selectorButtonHit:self.selectorButtons[0]];
            
            [self.tableView reloadData];
        }];
        
        
    } else {
    
        if (self.selectedSelectorIndex < 0)
            [self selectorButtonHit:self.selectorButtons[0]];
    }
    
    //[self.user fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
     //   self.user = object;
        
        //[self.tableView reloadData];
    //}];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back {
    
}

-(void)refreshPulled:(id)sender {
    if (self.isRefreshing) return;
    
    [self refreshUser:NO];
}

-(void)refreshUser:(BOOL)shouldUseCache {
    if (self.user == nil) return;
    
    if (self.isRefreshing) return;
    
    self.isRefreshing = YES;
    
    [self.user fetchInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (error) {
            
        } else {
            self.user = object;
            [self.tableView reloadData];
        }
        
        self.isRefreshing = NO;
        [self.refreshControl endRefreshing];
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
        destination.followingUser = self.followingUser;
        
    } else if ([segue.identifier isEqualToString:@"showUserProfileViewController"]) {
        UserProfileViewController *destination = (UserProfileViewController*)segue.destinationViewController;
        
        destination.user = self.selectedUser;
    }
}

#pragma mark - UITableViewDelegateMethods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (self.selectedSelectorIndex == kUserProfileTableModeProfile) return 2;
    else return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.selectedSelectorIndex < 0) return 0;
    else if (self.selectedSelectorIndex == kUserProfileTableModeProfile) {
        if (self.user != nil) {
            if (section == 0) return 1;
            else {
                NSArray *mobActions = nil;
                if ([self.selectedCategory isEqualToString:@""]) mobActions = self.userMobActions;
                else mobActions = self.prunedMobActions;
                
                if (mobActions == nil || mobActions.count == 0) return 1;
                else return mobActions.count;
            }
        } else
            return 0;
    } else if (self.selectedSelectorIndex == kUserProfileTableModeFollowers) {
        if (self.followers == nil)
            return 0;
        else
            return self.followers.count;
    } else if (self.selectedSelectorIndex == kUserProfileTableModeFollowing) {
        if (self.following == nil)
            return 0;
        else
            return self.following.count;
    } else return 0;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier;
    
    if (self.selectedSelectorIndex == kUserProfileTableModeProfile) {
        if (indexPath.section == 0) {
            CellIdentifier = @"UserProfile_UserInfoTableViewCell";
        
            UserProfile_UserInfoTableViewCell *cell = (UserProfile_UserInfoTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = (UserProfile_UserInfoTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:  CellIdentifier];
            }
        
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
            [cell setCellUser:self.user];
    
            cell.delegate = self;
            
            return cell;
        } else {
            NSArray *mobActions = nil;
            if ([self.selectedCategory isEqualToString:@""]) mobActions = self.userMobActions;
            else mobActions = self.prunedMobActions;

            if (mobActions == nil || mobActions.count == 0) {
                CellIdentifier = @"UserProfile_NoMobsTableViewCell";
            
                UserProfile_NoMobsTableViewCell *cell = (UserProfile_NoMobsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = (UserProfile_NoMobsTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:  CellIdentifier];
                }
            
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                return cell;
            } else {
                CellIdentifier = @"UserProfile_MobTableViewCell";
                
                UserProfile_MobTableViewCell *cell = (UserProfile_MobTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (cell == nil) {
                    cell = (UserProfile_MobTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:  CellIdentifier];
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                PFObject *mobAction = (PFObject*)mobActions[indexPath.row];
                PFObject *careMob = [mobAction objectForKey:kMobActionCareMobKey];
                PFObject *subMob = [mobAction objectForKey:kMobActionSubMobKey];
                NSString *categoryContext = [subMob objectForKey:kSubMobCategoryKey];
                
                NSNumber *mobActionValue = (NSNumber*)[mobAction objectForKey:kMobActionValueKey];
                
                [cell initializeWithCareMob:careMob andCategoryContext:categoryContext andMobActionValue:mobActionValue];
                
                return cell;
            }
        }
    } else if (self.selectedSelectorIndex == kUserProfileTableModeFollowers) {
        CellIdentifier = @"UserProfile_FollowUserTableViewCell";
        
        UserProfile_FollowUserTableViewCell *cell = (UserProfile_FollowUserTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = (UserProfile_FollowUserTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        PFObject *follow = self.followers[indexPath.row];
        PFObject *user = [follow objectForKey:kFollowFieldFollowingKey];
        
        [cell setCellUser:user];
        
        return cell;

    } else if (self.selectedSelectorIndex == kUserProfileTableModeFollowing) {
        CellIdentifier = @"UserProfile_FollowUserTableViewCell";
        
        UserProfile_FollowUserTableViewCell *cell = (UserProfile_FollowUserTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = (UserProfile_FollowUserTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        PFObject *follow = self.following[indexPath.row];
        PFObject *user = [follow objectForKey:kFollowFieldFollowedKey];
        
        [cell setCellUser:user];
        
        return cell;
    } else return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedSelectorIndex == kUserProfileTableModeProfile) {
        if (indexPath.section == 0)
            return 340.0f;
        else return 75.0f;
    } else {
        return 38.0f;
    }
}

// Header view
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.selectedSelectorIndex == kUserProfileTableModeProfile && section == 1) {
        UserProfile_LatestMobsSectionHeaderViewController *header = (UserProfile_LatestMobsSectionHeaderViewController*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UserProfile_LatestMobsSectionHeaderViewController"];
        
        NSString *subMobLabelText = [NSString stringWithFormat:@"%@ ", self.selectedCategory];
        
        if ([self.selectedCategory isEqualToString:@""]) {
            header.sectionTitleLabel.text = [NSString stringWithFormat:@"Latest %@Mobs", subMobLabelText];
            header.sectionHeaderBackgroundImage.image = [UIImage imageNamed:@"caremob_feed_section_header_bg_topmobs"];
            header.categoryImage.image = [UIImage imageNamed:@"caremob_feed_section_header_button_topmobs"];
        } else {
            header.sectionTitleLabel.text = [NSString stringWithFormat:@"Latest %@Mobs", subMobLabelText];
            header.sectionHeaderBackgroundImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"caremob_feed_section_header_bg_%@", self.selectedCategory]];
            header.categoryImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"caremob_feed_section_header_button_%@", self.selectedCategory]];
        }
        
        return header;
    } else return nil;
    
    
}

// Header height
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.selectedSelectorIndex == kUserProfileTableModeProfile && section == 1)
        return 26.0f;
    else
        return 0.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.selectedSelectorIndex == kUserProfileTableModeFollowing) {
        PFObject *follow = self.following[indexPath.row];
        PFObject *user = [follow objectForKey:kFollowFieldFollowedKey];
        
        self.selectedUser = user;
        
        UserProfileViewController *userProfileViewController = (UserProfileViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
        userProfileViewController.user = self.selectedUser;
        
        [self.navigationController pushViewController:userProfileViewController animated:YES];
        
    } else if (self.selectedSelectorIndex == kUserProfileTableModeFollowers) {
        PFObject *follow = self.followers[indexPath.row];
        PFObject *user = [follow objectForKey:kFollowFieldFollowingKey];
        
        self.selectedUser = user;
        
        UserProfileViewController *userProfileViewController = (UserProfileViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
        userProfileViewController.user = self.selectedUser;
        
        [self.navigationController pushViewController:userProfileViewController animated:YES];
    } else if (self.selectedSelectorIndex == kUserProfileTableModeProfile && indexPath.section == 1) {
        NSArray *mobActions = nil;
        if ([self.selectedCategory isEqualToString:@""]) mobActions = self.userMobActions;
        else mobActions = self.prunedMobActions;
        
        if (mobActions != nil && mobActions.count > 0) {
            PFObject *mobAction = (PFObject*)mobActions[indexPath.row];
            self.selectedCareMob = [mobAction objectForKey:kMobActionCareMobKey];
            self.selectedSubMob = [mobAction objectForKey:kMobActionSubMobKey];
            self.selectedCategoryContext = [self.selectedSubMob objectForKey:kSubMobCategoryKey];
            
            if (![self.user.objectId isEqualToString:[PFUser currentUser].objectId])
                self.followingUser = (PFUser*)self.user;
            
            [self performSegueWithIdentifier:@"showCaremobDisplayViewController" sender:self];
        }
    }
}
- (IBAction)selectorButtonHit:(id)sender {
    //NSArray *tabNames = @[@"latestmobbers",@"topmobbers",@"following",@"followers"];
    
    // First figure out which button was hit
    int index = -1;
    for (int i = 0; i < self.selectorButtons.count; i++) {
        if (sender == self.selectorButtons[i]) index = i;
    }
    
    NSLog(@"Tapped %d", index);
    if (index == self.selectedSelectorIndex) return;
    if (index >= 0) self.selectedSelectorIndex = index;
    else return;    // Something weird happened!
    
    // Set the state of the buttons
    for (int i = 0; i < self.selectorButtons.count; i++) {
        UIButton *selectorButton = (UIButton*)self.selectorButtons[i];
        
        if (self.selectedSelectorIndex == i) {
            [selectorButton setBackgroundImage:[UIImage imageNamed:@"global_action_bar_bg_selected"] forState:UIControlStateNormal];
        } else {
            [selectorButton setBackgroundImage:[UIImage imageNamed:@"global_action_bar_bg"] forState:UIControlStateNormal];
        }
    }
    
    if (self.selectedSelectorIndex == kUserProfileTableModeProfile) {
        // Load the user's latest mobs if we don't already have them
        if (self.userMobActions == nil && self.user != nil) {
            PFQuery *mobActionQuery = [PFQuery queryWithClassName:kMobActionClassKey];
            [mobActionQuery whereKey:kMobActionUserKey equalTo:self.user];
            [mobActionQuery orderByDescending:kMobActionUpdatedAtKey];
            [mobActionQuery includeKey:kMobActionCareMobKey];
            [mobActionQuery includeKey:kMobActionSubMobKey];
            [mobActionQuery includeKey:[NSString stringWithFormat:@"%@.%@", kMobActionCareMobKey, kCareMobSourceUserKey]];
            [mobActionQuery includeKey:[NSString stringWithFormat:@"%@.%@", kMobActionCareMobKey, kCareMobSubMobsKey]];
            [mobActionQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                if (error) {
                    
                } else {
                    self.userMobActions = objects;
                }
                
                [self.tableView reloadData];
            }];
        } else {
            [self.tableView reloadData];
        }
    } else if (self.selectedSelectorIndex == kUserProfileTableModeFollowers || self.selectedSelectorIndex == kUserProfileTableModeFollowing) {
        if (self.followers == nil || self.following == nil) {
            // Fetch the followers/following for the user
            PFQuery *followersQuery = [PFQuery queryWithClassName:kFollowClassKey];
            [followersQuery whereKey:kFollowFieldFollowedKey equalTo:self.user];

            PFQuery *followingQuery = [PFQuery queryWithClassName:kFollowClassKey];
            [followingQuery whereKey:kFollowFieldFollowingKey equalTo:self.user];

            PFQuery *orQuery = [PFQuery orQueryWithSubqueries:@[followersQuery, followingQuery]];
            [orQuery includeKey:kFollowFieldFollowedKey];
            [orQuery includeKey:kFollowFieldFollowingKey];

            [orQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                if (error) {
                    [[[UIAlertView alloc] initWithTitle:@"Failed to retrieve followers" message:@"Can't fetch followers for this user right now.  Please try again later." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
                } else {
                    // Iterate through the objects and separate them into followers and following
                    self.followers = [[NSMutableArray alloc] init];
                    self.following = [[NSMutableArray alloc] init];
                    
                    for (int i = 0; i < objects.count; i++) {
                        PFObject *follow = (PFObject*)[objects objectAtIndex:i];
                        
                        PFObject *followed = [follow objectForKey:kFollowFieldFollowedKey];
                        PFObject *following = [follow objectForKey:kFollowFieldFollowingKey];
                        
                        if ([followed.objectId isEqualToString:self.user.objectId]) [self.followers addObject:follow];
                        else if ([following.objectId isEqualToString:self.user.objectId]) [self.following addObject:follow];
                    }
                    
                    NSLog(@"Got %lu followers and %lu following", (unsigned long)self.followers.count, (unsigned long)self.following.count);
                    
                    [self.tableView reloadData];
                }
            }];
        } else {
            [self.tableView reloadData];
        }
    }
}

#pragma mark - UserProfile_UserInfoTableViewDelegate
-(void)categoryButtonWasHitWithCategory:(NSString*)category {
    NSLog(@"category %@ tapped", category);
    
    self.selectedCategory = category;
    
    if (self.userMobActions != nil) {
        self.prunedMobActions = [[NSMutableArray alloc] init];
    
        for (int i = 0; i < self.userMobActions.count; i++) {
            PFObject *mobAction = (PFObject*)self.userMobActions[i];
            PFObject *subMob = [mobAction objectForKey:kMobActionSubMobKey];
            NSString *subMobCategory = [subMob objectForKey:kSubMobCategoryKey];
            
            if ([category isEqualToString:subMobCategory]) [self.prunedMobActions addObject:mobAction];
        }
        
        [self.tableView reloadData];
    }
}

-(void)logoutButtonWasHit {
    // Show an action sheet
    RootViewController *rootView = (RootViewController*)self.navigationController.tabBarController;
    [rootView doLogout];
}

-(void)chooseProfileImageButtonWasHit {
    // Allow the user to select a new image
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Source?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Camera" otherButtonTitles:@"Library", nil];
    //[actionSheet showFromTabBar:self.tabBarController.tabBar];
    
    if (self.tabBarController != nil && self.tabBarController.tabBar != nil)
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    else
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];

}

#pragma mark - Action Sheet Delegate Methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        
        [self presentViewController:imagePicker animated:YES completion:NULL];
    } else if (buttonIndex == 1) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = YES;
        
        [self presentViewController:imagePicker animated:YES completion:NULL];
        
    }
}

#pragma mark - Image Picker Delegate Methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    // Size and save these files
    
    // Full size
    UIGraphicsBeginImageContext(CGSizeMake(600,600));
    [image drawInRect:CGRectMake(0,0,600,600)];
    UIImage *sizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(sizedImage, 0.05f);
    
    self.imageFile = [PFFile fileWithName:@"ProfileImage.jpg" data:imageData];
    
    // Save both files in background
    [self.imageFile saveInBackground];
    self.user = [PFUser currentUser];
    
    [[PFUser currentUser] setObject:self.imageFile forKey:kUserFieldProfileImageKey];
    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [self.tableView reloadData];        
    }];
    
    // Update the core table cell
    //[self.choosePhotoButton setBackgroundImage:image forState:UIControlStateNormal];
    //[self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];

}

@end
