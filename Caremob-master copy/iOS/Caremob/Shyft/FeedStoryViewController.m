//
//  FeedStoryViewController.m
//  Caremob
//
//  Created by Rick Strom on 6/20/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import "FeedStoryViewController.h"

@interface FeedStoryViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *sourceLogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *sourceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceDescriptionLabel;


@end

@implementation FeedStoryViewController

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
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([self.source isEqualToString:@"theguardian_world_protest"]) self.source = @"theguardian";
    
    self.sourceNameLabel.text = [CareMobHelper feedSourceValueToPrintableString:self.source];
    self.sourceDescriptionLabel.text = [CareMobHelper feedSourceDescriptionString:self.source];
    
    self.sourceLogoImageView.image = [UIImage imageNamed:[CareMobHelper feedSourceValueToIconName:self.source]];
                                      
    if ([PFUser currentUser] && self.feedStories == nil) {
        [self refreshFeedStories:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back {
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showCaremobDisplayViewController"]) {
        CaremobDisplayViewController *destination = (CaremobDisplayViewController*)segue.destinationViewController;
        destination.careMob = self.selectedCareMob;
    }
}


-(void)refreshPulled:(id)sender {
    if (self.isRefreshing) return;
    
    [self refreshFeedStories:NO];
}

-(void)refreshFeedStories:(BOOL)shouldUseCache {
    if (self.isRefreshing) return;
    
    self.isRefreshing = YES;
    
    PFQuery *feedStoriesQuery = [PFQuery queryWithClassName:kFeedStoryClassKey];
    [feedStoriesQuery whereKey:kFeedStoryFieldNeedsImageKey equalTo:[NSNumber numberWithBool:NO]];
    [feedStoriesQuery orderByDescending:kFeedStoryFieldCreatedAtKey];
    feedStoriesQuery.maxCacheAge = 60*5;

    if (self.source != nil) {
        NSLog(@"Using source: %@", self.source);
        [feedStoriesQuery whereKey:kFeedStoryFieldSourceKey equalTo:self.source];
        
    }
    
    if (shouldUseCache == YES)
        [feedStoriesQuery setCachePolicy:kPFCachePolicyCacheElseNetwork];
    else
        [feedStoriesQuery setCachePolicy:kPFCachePolicyNetworkElseCache];

    [feedStoriesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [self.refreshControl endRefreshing];
            self.isRefreshing = NO;
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            [self.refreshControl endRefreshing];
            self.isRefreshing = NO;
            
            self.feedStories = objects;
            
            NSLog(@"Got %d stories for source %@", (int)self.feedStories.count, self.source);
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
    if (self.feedStories == nil) return 0;
    else return self.feedStories.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier;
    
    CellIdentifier = @"FeedStoryTableViewCell";
    
    FeedStoryTableViewCell *cell = (FeedStoryTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = (FeedStoryTableViewCell*)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell initializeWithFeedStory:self.feedStories[indexPath.row]];
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
//   [cell setBackgroundColor:[UIColor clearColor]];
//}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 78.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Get a CareMob for this feed story
    PFObject *selectedFeedStory = (PFObject*)self.feedStories[indexPath.row];
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[kCloudFunctionCreateCareMobFromFeedStoryParamFeedStoryId] = selectedFeedStory.objectId;
    
    [PFCloud callFunctionInBackground:kCloudFunctionCreateCareMobFromFeedStoryKey withParameters:params block:^(id object, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            self.selectedCareMob = (PFObject*)object;
            
            // We got a mob, but we need to fetch it including its submobs
            PFQuery *completeMobQuery = [PFQuery queryWithClassName:kCareMobClassKey];
            [completeMobQuery includeKey:kCareMobSubMobsKey];
            [completeMobQuery whereKey:kCareMobObjectIdKey equalTo:self.selectedCareMob.objectId];
            [completeMobQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (error) {
                    
                } else {
                    if (objects != nil && objects.count > 0) {
                        self.selectedCareMob = (PFObject*)objects[0];
                        
                        [self performSegueWithIdentifier:@"showCaremobDisplayViewController" sender:self];
                    } else {
                        
                    }
                }
            }];


        }
    }];
}

@end
