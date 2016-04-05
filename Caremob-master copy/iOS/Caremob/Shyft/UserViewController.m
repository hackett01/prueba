//
//  ViewController.m
//  Shyft
//
//  Created by Rick Strom on 11/13/14.
//  Copyright (c) 2014 Rick Strom. All rights reserved.
//

#import "UserViewController.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
//#import <FacebookSDK/FacebookSDK.h>

@interface UserViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *joinDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobActionsCreatedLabel;
@property (weak, nonatomic) IBOutlet UILabel *submobsStartedLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersLabel;

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *submobPointTotalLabels;


@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

- (IBAction)logoutButtonHit:(id)sender;
- (IBAction)followButtonHit:(id)sender;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // Set up the category list (used to iterate through the submobPointTotalLabels and pull data from our cloud function
    self.categoryList = @[@"support",@"protest",@"celebration",@"peace",@"mourning",@"empathy"];
    
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
    
    // Initialize all submob point totals to 0
    for (int i = 0; i < self.submobPointTotalLabels.count; i++) {
        UILabel *l = (UILabel*)self.submobPointTotalLabels[i];
        l.text = @"";
    }

}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)back {
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];  
    
    if (self.user == nil) self.user = (PFObject*)[PFUser currentUser];
    
    if ([self.user.objectId isEqualToString:[PFUser currentUser].objectId]) {
        // We are showing our own profile
        self.logoutButton.hidden = NO;
        self.logoutButton.enabled = YES;
    } else {
        self.logoutButton.hidden = YES;
        self.logoutButton.enabled = NO;
        
        
        // Determine if we're following this user or not, and then show the button
        PFQuery *followQuery = [PFQuery queryWithClassName:kFollowClassKey];
        [followQuery setCachePolicy:kPFCachePolicyNetworkOnly];
        [followQuery whereKey:kFollowFieldFollowedKey equalTo:self.user];
        [followQuery whereKey:kFollowFieldFollowingKey equalTo:[PFUser currentUser]];
        [followQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
            if (error) {
                // Do nothing
            } else {
                if (number > 0) {
                    [self.followButton setBackgroundImage:[UIImage imageNamed:@"caremob_follow_button_unfollow"] forState:UIControlStateNormal];
                    self.followButton.hidden = NO;
                    self.followButton.enabled = YES;
                    self.isFollowing = YES;
                } else {
                    [self.followButton setBackgroundImage:[UIImage imageNamed:@"caremob_follow_button_follow"] forState:UIControlStateNormal];
                    self.followButton.hidden = NO;
                    self.followButton.enabled = YES;
                    self.isFollowing = YES;
                }
            }
        }];
    }
    
    PFFile *profileImage = (PFFile*)[self.user objectForKey:kUserFieldProfileImageKey];
    if (profileImage != nil) {
        if ([profileImage isDataAvailable]) {
            self.profileImageView.image = [UIImage imageWithData:[profileImage getData]];
        } else {
            // Fetch the image
            [profileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    self.profileImageView.image = [UIImage imageWithData:data];
                }
            }];
        }
    }

    // Fetch point totals
    NSLog(@"%@", self.user);
    NSNumber *userPoints = (NSNumber*)[self.user objectForKey:kUserFieldPointsKey];
    if (userPoints == nil) userPoints = [NSNumber numberWithInt:0];
    NSDictionary *params = @{@"userId":self.user.objectId, @"userPoints":userPoints};
    [PFCloud callFunctionInBackground:kCloudFunctionGetUserSubmobPointTotalsKey withParameters:params block:^(id object, NSError *error) {
        if (error) {
            NSLog(@"Error %@", error.localizedDescription);
        } else {
            NSDictionary *result = (NSDictionary*)object;
            NSLog(@"%@", result);
            // Iterate through result and set any matching labels to point totals
            for (id key in result) {
                NSString *category = (NSString*)key;
                NSNumber *points = (NSNumber*)result[key];
                int pointsInt = [points intValue];
                
                // Find the index
                int index = -1;
                for (int i = 0; i < self.categoryList.count; i++) {
                    if ([self.categoryList[i] isEqualToString:category]) index = i;
                }
                
                if (index >= 0) {
                    UILabel *l = (UILabel*)self.submobPointTotalLabels[index];
                    l.text = [NSString stringWithFormat:@"%d", pointsInt];
                }
                
            }
            
            
        }
        
        // Now try to get the user's rank (using the same params dict)
        [PFCloud callFunctionInBackground:kCloudFunctionGetUserRankKey withParameters:params block:^(id object, NSError *error) {
            if (error) {
                NSLog(@"Error %@", error.localizedDescription);
            } else {
                NSDictionary *result = (NSDictionary*)object;
                NSNumber *rank = result[@"rank"];
                //NSNumber *caremobsCreated = result[@"caremobsCreated"];
                NSNumber *subMobsStarted = result[@"subMobsStarted"];
                NSNumber *mobActionsCreated = result[@"mobActionsCreated"];
                
                self.rankLabel.text = [NSString stringWithFormat:@"%d", [rank intValue]];
                self.submobsStartedLabel.text = [NSString stringWithFormat:@"%d", [subMobsStarted intValue]];
                self.mobActionsCreatedLabel.text = [NSString stringWithFormat:@"%d", [mobActionsCreated intValue]];
            }
        }];
    }];
    
    NSString *name = [self.user objectForKey:kUserFieldNameKey];
    if (name == nil) name = @"Unknown";
    self.nameLabel.text = name;

    NSDate *joinDate = self.user.createdAt;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM d, YYYY"];
    NSString *joinDateString = [dateFormat stringFromDate:joinDate];
    self.joinDateLabel.text = joinDateString;

    NSString *location = [self.user objectForKey:kUserFieldLocationKey];
    if (location == nil) location = @"Unknown";
    self.locationLabel.text = location;
    
    /*
    NSNumber *subMobsStarted = [self.user objectForKey:kUserFieldSubMobsStartedKey];
    if (subMobsStarted == nil) subMobsStarted = [NSNumber numberWithInt:0];
    self.submobsStartedLabel.text = [NSString stringWithFormat:@"%d", [subMobsStarted intValue]];

    NSNumber *mobActionsCreated = [self.user objectForKey:kUserFieldMobActionsCreatedKey];
    if (mobActionsCreated == nil) mobActionsCreated = [NSNumber numberWithInt:0];
    self.mobActionsCreatedLabel.text = [NSString stringWithFormat:@"%d", [mobActionsCreated intValue]];
     */
    
    NSNumber *followers = [self.user objectForKey:kUserFieldFollowerCountKey];
    if (followers == nil) followers = [NSNumber numberWithInt:0];
    self.followersLabel.text = [NSString stringWithFormat:@"%d", [followers intValue]];
    
    

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
}

/*
 -(void)showMyProfile {
 [self performSegueWithIdentifier:@"showMyProfileViewController" sender:self];
 }
 */

- (IBAction)logoutButtonHit:(id)sender {
    [PFUser logOut];
    
    self.logoutButton.hidden = YES;
    self.logoutButton.enabled = NO;
    
    RootViewController *rootView = (RootViewController*)[self tabBarController];
    [rootView doLogin];
}

- (IBAction)followButtonHit:(id)sender {
    self.followButton.enabled = NO;
    
    if (self.isFollowing) {
        // Delete the follow
        PFQuery *followQuery = [PFQuery queryWithClassName:kFollowClassKey];
        [followQuery setCachePolicy:kPFCachePolicyNetworkOnly];
        [followQuery whereKey:kFollowFieldFollowedKey equalTo:self.user];
        [followQuery whereKey:kFollowFieldFollowingKey equalTo:[PFUser currentUser]];
        [followQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                self.followButton.enabled = YES;
            } else {
                PFObject *follow = (PFObject*)objects[0];
                [follow deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (error) {
                        self.followButton.enabled = YES;
                    } else {
                        self.isFollowing = NO;
                        [self.followButton setBackgroundImage:[UIImage imageNamed:@"caremob_follow_button_follow"] forState:UIControlStateNormal];
                        self.followButton.enabled = YES;
                    }
                }];
            }
        }];
    } else {
        // Create a new follow
        PFObject *follow = [PFObject objectWithClassName:kFollowClassKey];
        [follow setObject:[PFUser currentUser] forKey:kFollowFieldFollowingKey];
        [follow setObject:self.user forKey:kFollowFieldFollowedKey];
        [follow saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                self.followButton.enabled = YES;
            } else {
                self.isFollowing = YES;
                [self.followButton setBackgroundImage:[UIImage imageNamed:@"caremob_follow_button_unfollow"] forState:UIControlStateNormal];
                self.followButton.enabled = YES;
            }
        }];
    }
}

@end
