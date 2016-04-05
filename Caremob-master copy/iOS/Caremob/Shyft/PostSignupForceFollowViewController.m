//
//  PostSignupForceFollowViewController.m
//  Caremob
//
//  Created by Rick Strom on 1/20/16.
//  Copyright © 2016 Rick Strom. All rights reserved.
//

#import "PostSignupForceFollowViewController.h"

@interface PostSignupForceFollowViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PostSignupForceFollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.usersToFollow = [[NSMutableArray alloc] init];
    
    // Configure the navigation bar
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"caremob_navbar_logo"]];
    
    NSDictionary *myNavBarDoneButtonTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                [UIFont fontWithName:@"NettoOT" size:16.0f], NSFontAttributeName,
                                                nil];
    
    
    UIBarButtonItem *navBarDoneButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonHit:)];
    [navBarDoneButton setTitleTextAttributes:myNavBarDoneButtonTextAttributes forState:UIControlStateNormal];
    [navBarDoneButton setTintColor:[UIColor whiteColor]];

    self.navigationItem.rightBarButtonItem = navBarDoneButton;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    self.navigationItem.hidesBackButton = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([PFUser currentUser] == nil) {
        // We should not be here!
        [self dismissViewControllerAnimated:YES completion:^{
            // Do nothing
        }];
    } else {
        [self loadInfluencers];
    }
}

-(void)loadInfluencers {
    PFQuery *influencersQuery = [PFQuery queryWithClassName:kUserClassKey];
    [influencersQuery orderByDescending:kUserFieldInfluenceKey];
    influencersQuery.limit = 100;
    [influencersQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (error) {
            // Just dismiss this view
            [self dismissViewControllerAnimated:YES completion:^{
                // Do nothing
            }];
        } else {
            self.influencers = objects;
            
            [self.tableView reloadData];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - UITableViewDelegateMethods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.influencers == nil) return 0;
    else return self.influencers.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier;
    
    CellIdentifier = @"PostSignupForceFollow_InfluencerTableViewCell";
        
    PostSignupForceFollow_InfluencerTableViewCell *cell = (PostSignupForceFollow_InfluencerTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (PostSignupForceFollow_InfluencerTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
        
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    PFObject *thisUser = (PFObject*)self.influencers[indexPath.row];
    [cell initializeWithUser:thisUser andRank:(int)(indexPath.row + 1) andIsFollowing:[self isUserFollowing:thisUser]];
    
    cell.delegate = self;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

-(void)doneButtonHit:(id)sender {
    if (self.usersToFollow == nil || self.usersToFollow.count == 0) return;
    
    // Request follows and then close
    NSLog(@"Done button hit");
    
    // Create an array of follow objets for all users in the list
    NSMutableArray *follows = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < self.usersToFollow.count; i++) {
        PFObject *user = (PFObject*)self.usersToFollow[i];
        
        PFObject *follow = [PFObject objectWithClassName:kFollowClassKey];
        [follow setObject:[PFUser currentUser] forKey:kFollowFieldFollowingKey];
        [follow setObject:user forKey:kFollowFieldFollowedKey];
        
        [follows addObject:follow];
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Following users";
    
    [PFObject saveAllInBackground:follows block:^(BOOL succeeded, NSError * _Nullable error) {
        // Regardless of the result, we simply close this view
        if (error) {
            [hud hide:YES];
            
            [self dismissViewControllerAnimated:YES completion:^{
                // Do nothing
            }];
        } else {
            // Quickly refresh the current user
            [[PFUser currentUser] fetchInBackground];
            
            [hud hide:YES];
            
            [self dismissViewControllerAnimated:YES completion:^{
                // Do nothing
            }];
        }
        
        
        
    }];
}

-(BOOL)isUserFollowing:(PFObject*)user {
    if (self.usersToFollow == nil) return NO;
    if (self.usersToFollow.count == 0) return NO;
    
    for (int i = 0; i < self.usersToFollow.count; i++) {
        PFObject *u = (PFObject*)self.usersToFollow[i];
        if ([u.objectId isEqualToString:user.objectId]) return YES;
    }
    
    return NO;
}

#pragma mark - PostSignupForceFollow_InfluencerTableViewCellDelegate methods
-(BOOL)follow:(PFObject*)user {
    BOOL isFollowing = [self isUserFollowing:user];
    if (isFollowing == YES) {
        // Remove user from list
        PFObject *objectToRemove = nil;
        for (int i = 0; i < self.usersToFollow.count; i++) {
            PFObject *u = (PFObject*)self.usersToFollow[i];
            if ([u.objectId isEqualToString:user.objectId]) {
                objectToRemove = u;
                break;
            }
        }
        
        if (objectToRemove != nil) {
            [self.usersToFollow removeObject:objectToRemove];

            NSLog(@"Removing user");
            
            if (self.usersToFollow.count == 0) {
                // Hide done button
                self.navigationItem.rightBarButtonItem.enabled = NO;
                self.navigationItem.rightBarButtonItem.title = @"";
                
                NSLog(@"Hiding done button");
            }
        }
        
    } else {
        [self.usersToFollow addObject:user];
        
        // Show done button
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItem.title = @"DONE";
        
        NSLog(@"Adding user");
        NSLog(@"Showing done button");
    }
    
    return !isFollowing;
}
@end
