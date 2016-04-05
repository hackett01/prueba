//
//  RootViewController.m
//  Shyft
//
//  Created by Rick Strom on 11/15/14.
//  Copyright (c) 2014 Rick Strom. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /* OLD CODE from original Shyft design
    // Customize the tab bar
    float width = self.tabBar.frame.size.width;
    //float height = self.tabBar.frame.size.height;
    
    UITabBarItem *item0 = self.tabBar.items[0];
    UITabBarItem *item1 = self.tabBar.items[1];
    

    
    // Create the UIImages for the buttons and size them to half the width of the bar
    item0.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    [item0 setSelectedImage:[UIImage imageNamed:@"tabBarButtonCirclesOfSilence"]];
    [item0 setImage:[UIImage imageNamed:@"tabBarButtonCirclesOfSilence"]];
    [item0 setTitlePositionAdjustment:UIOffsetMake(-width / 4.0f + 60.0f, -5.0f)];
    [item0 setTitle:@""];

    item1.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    [item1 setSelectedImage:[UIImage imageNamed:@"tabBarButtonLatestNotifications"]];
    [item1 setImage:[UIImage imageNamed:@"tabBarButtonLatestNotifications"]];
    [item1 setTitlePositionAdjustment:UIOffsetMake(width / 4.0f - 60.0f, -5.0f)];
    [item1 setTitle:@""];
     */
    
    // Make sure tab bar buttons are rendering as-is (in original mode)
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        for (UITabBarItem *tbi in self.tabBar.items) {
            tbi.image = [tbi.image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            tbi.selectedImage = [tbi.selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
            NSDictionary *tabBarButtonTitleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                           [UIFont fontWithName:@"NettoOT-Bold" size:12.0f], NSFontAttributeName,
                                                           nil];
            [tbi setTitleTextAttributes:tabBarButtonTitleTextAttributes forState:UIControlStateNormal];
        }
    }
    
    [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"caremob_tab_bar_background"]];
    //[self.tabBar setBackgroundImage:[UIImage imageNamed:@"tabBarBG"]];
    
    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0]];
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:12.0/255.0 green:105.0/255.0 blue:148.0/255.0 alpha:1.0]];
    //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1.0]];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor] } forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:64.0/255.0 green:211.0/255.0 blue:242.0/255.0 alpha:1.0] } forState:UIControlStateSelected];
    
    int imageSize = 18; //REPLACE WITH YOUR IMAGE WIDTH
    UIImage *barBackBtnImg = [[UIImage imageNamed:@"caremob_navbar_back_button"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, imageSize, 0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:barBackBtnImg
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showActivityTab:) name:kNSNotificationShouldShowActivityTab object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidChange:) name:kNSNotificationUserDidChange object:nil];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        [self loadFacebookData];
        
        [[Sound soundNamed:kSoundApplicationLaunch] play];
        
    } else if ([PFUser currentUser] == nil) {
        [self doLogin];
    }

    //for (int i = 0; i < 50; i++) {
        //int points = [CareMobHelper calculateUserPointsRequiredForLevel:i];
        //NSLog(@"Level %d requires %d points", i, points);
    //}
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)showActivityTab:(NSNotification*)notification {
    [self setSelectedIndex:1];
}

-(void)userDidChange:(NSNotification*)notification {
    UINavigationController *navController = (UINavigationController*)self.viewControllers[4];
    [navController popToRootViewControllerAnimated:NO];
    
    UserProfileViewController *userProfile = (UserProfileViewController*)navController.viewControllers[0];
    userProfile.user = nil;
    
    [self setSelectedIndex:0];
    
}

-(void)switchToActivityTab {
    [self setSelectedIndex:1];
}

-(void)doLogin {
    [self performSegueWithIdentifier:@"showLoginViewController" sender:self];
}

-(void)doLogout {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        if (error) {
            
        } else {
            [self doLogin];
        }
    }];
}

-(void)loadFacebookData {

    NSDictionary *params = @{@"fields": @"id, name, email, location"};
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:params];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
    //FBRequest *meRequest = [FBRequest requestForMe];
    //[meRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook data
            NSDictionary *userData = (NSDictionary *)result;
            NSLog(@"%@",userData);
            
            NSString *facebookID = userData[@"id"];
            NSString *name = userData[@"name"];
            NSString *location = userData[@"location"][@"name"];
            NSString *email = userData[@"email"];
            //NSString *gender = userData[@"gender"];
            //NSString *birthday = userData[@"birthday"];
            //NSString *relationship = userData[@"relationship_status"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            // Set profile photo
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
            
            // Run network request asynchronously
            [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                if (connectionError == nil && data != nil) {
                    
                    if ([[PFUser currentUser] objectForKey:kUserFieldProfileImageKey] == nil) {
                        // Save profile image as a file and attach it to the user
                        PFFile *profileImageFile = [PFFile fileWithName:@"fbProfileImage.jpg" data:data];
                        [profileImageFile saveInBackground];
                        [[PFUser currentUser] setObject:profileImageFile forKey:kUserFieldProfileImageKey];
                        [[PFUser currentUser] saveInBackground];
                    }
                    
                    // Tell the UserLevelControlViewController's to refresh themselves
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationMobActionWasPerformed object:nil];
                }
            }];
            
            NSLog(@"Location is %@", location);
            NSLog(@"Facebook ID is %@",facebookID);
            NSLog(@"Name is %@", name);
            NSLog(@"email is %@", email);
            
            // Save data to user object
            if (facebookID != nil)
                [[PFUser currentUser] setObject:facebookID forKey:kUserFieldFacebookUserIdKey];
            
            if (email != nil)
                [[PFUser currentUser] setObject:email forKey:kUserFieldEmailKey];
            
            if (name != nil)
                [[PFUser currentUser] setObject:name forKey:kUserFieldNameKey];
            
            if (location != nil)
                [[PFUser currentUser] setObject:location forKey:kUserFieldLocationKey];
            
            [[PFUser currentUser] saveEventually];
            
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"] isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
            [self doLogin];
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
    
    FBSDKGraphRequest *friendsRequest = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends" parameters:nil];
    [friendsRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
    //FBRequest *friendsRequest = [FBRequest requestForMyFriends];
    //[friendsRequest startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            // result is a dictionary with the user's Facebook friends
            NSDictionary *userData = (NSDictionary *)result;
            NSLog(@"%@",userData);
            
            if ([PFUser currentUser] != nil) {
                NSArray *friends = userData[@"data"];
                NSMutableArray *friendIds = [[NSMutableArray alloc] init];
                
                for (int i = 0; i < friends.count; i++) {
                    NSLog(@"%@", friends[i][@"id"]);
                    NSString *friendId = [NSString stringWithString:friends[i][@"id"]];
                    [friendIds addObject:friendId];
                }
                
                NSArray *existingFacebookFriendIds = (NSArray*)[[PFUser currentUser] objectForKey:kUserFieldFacebookFriendsKey];
                [[PFUser currentUser] setObject:friendIds forKey:kUserFieldFacebookFriendsKey];
                
                if ((friendIds != nil && friendIds.count > 0) && (existingFacebookFriendIds == nil || existingFacebookFriendIds.count == 0)) {
                    // Save ueer, then tell parse to notify other facebook friends that we are joining
                    [[PFUser currentUser] saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (error) {
                            // Ignore
                        } else {
                            NSDictionary *params = [[NSDictionary alloc] init];
                            [PFCloud callFunctionInBackground:kCloudFunctionNotifyUsersFacebookFriendsOfSignupKey withParameters:params block:^(id object, NSError *error) {
                                if (error) {
                                    NSLog(@"Error: %@", error);
                                } else {
                                    // We dont actually need this block
                                    NSLog(@"Notify block returned!");
                                }
                            }];
                        }
                    }];
                }
            }
        }
    }];
    
    NSLog(@"My facebook id is %@", [[PFUser currentUser] objectForKey:@"fbUserId"]);
    
    // Update the installation to make sure its associated with this user
    PFInstallation *installation = [PFInstallation currentInstallation];
    if (installation != nil) {
        [installation setObject:[PFUser currentUser] forKey:@"user"];
        [installation saveEventually];
    }

}

@end
