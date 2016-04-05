//
//  FeedViewController.m
//  Shyft
//
//  Created by Rick Strom on 11/15/14.
//  Copyright (c) 2014 Rick Strom. All rights reserved.
//

#import "FeedViewController.h"

@interface FeedViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *circleCollectionView;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Configure the navigation bar
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"caremob_navbar_logo"]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:12.0/255.0 green:105.0/255.0 blue:148.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];
/*
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTintColor:[UIColor whiteColor]];
    [backButton setImage:[UIImage imageNamed:@"caremob_navbar_back_button"] forState:UIControlStateNormal];
    UIBarButtonItem *button = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    [button setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.backBarButtonItem = button;
  */
    
    //[[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"caremob_navbar_back_button"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    /*
    UIBarButtonItem *MyProfileButton = [[UIBarButtonItem alloc] initWithTitle:@"MY PROFILE" style:UIBarButtonItemStylePlain target:self action:@selector(showMyProfile)];
    NSDictionary *myProfileButtonTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                   [UIFont fontWithName:@"NettoOT" size:16.0f], NSFontAttributeName,
                                                   nil];
    [MyProfileButton setTitleTextAttributes:myProfileButtonTextAttributes forState:UIControlStateNormal];
    [MyProfileButton setTintColor:[UIColor whiteColor]];

    self.navigationItem.rightBarButtonItem = MyProfileButton;
     */
    
    UIBarButtonItem *MyBackButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    //UIBarButtonItem *MyBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navBarBackButton"] landscapeImagePhone:[UIImage imageNamed:@"navBarBackButton"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    MyBackButton.title = @"";
    
    NSDictionary *myBackButtonTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                   [UIFont fontWithName:@"NettoOT" size:16.0f], NSFontAttributeName,
                                                   nil];
    [MyBackButton setTitleTextAttributes:myBackButtonTextAttributes forState:UIControlStateNormal];
    [MyBackButton setTintColor:[UIColor whiteColor]];

    self.navigationItem.backBarButtonItem = MyBackButton;
    
    /*
    UIBarButtonItem *whyShyftButton = [[UIBarButtonItem alloc] initWithTitle:@"WHY SHYFT?" style:UIBarButtonItemStylePlain target:self action:@selector(showWhyShyft)];
    NSDictionary *whyShyftButtonTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                   [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                   [UIFont fontWithName:@"NettoOT" size:16.0f], NSFontAttributeName,
                                                   nil];
    [whyShyftButton setTitleTextAttributes:whyShyftButtonTextAttributes forState:UIControlStateNormal];
    [whyShyftButton setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.leftBarButtonItem = whyShyftButton;
     */
    
    // Add a refresh control to the collection view
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor grayColor];
    [self.refreshControl addTarget:self action:@selector(loadCirclesFromParse) forControlEvents:UIControlEventValueChanged];
    [self.circleCollectionView addSubview:self.refreshControl];
    self.circleCollectionView.alwaysBounceVertical = YES;
    
    [self loadCirclesFromParse];
    
    
   
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
    
    
    if ([segue.identifier isEqualToString:@"showCircleInfoViewController"]) {
        CircleInfoViewController *destination = (CircleInfoViewController*)[segue destinationViewController];
        destination.circle = self.circles[self.selectedIndexPath.item];
        
    }
}


-(void)loadCirclesFromParse {
    // NOTE: commented out as it uses old data model
    /*
    PFQuery *circlesQuery = [PFQuery queryWithClassName:kCircleClassKey];
    [circlesQuery orderByDescending:kCircleFieldCreatedAtKey];
    [circlesQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Error!" message:@"Error retrieving circles" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            
            if ([self.refreshControl isRefreshing]) [self.refreshControl endRefreshing];
        } else {
            self.circles = [NSArray arrayWithArray:objects];
            [self.circleCollectionView reloadData];
            
            if ([self.refreshControl isRefreshing]) [self.refreshControl endRefreshing];
        }
    }];
     */
}

/*
-(void)showMyProfile {
    [self performSegueWithIdentifier:@"showMyProfileViewController" sender:self];
}
*/

/*
-(void)showWhyShyft {
    [self performSegueWithIdentifier:@"showWhyShyftViewController" sender:self];
}
*/

-(void)back {
    
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (self.circles == nil) return 0;
    else return self.circles.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CircleSmallCollectionViewCell *cell;
    
    //if (indexPath.item % 3 == 0 && NO)
    //    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CircleLargeCollectionViewCell" forIndexPath:indexPath];
    //else if (indexPath.item % 2 == 0 && NO)
    //    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CircleMediumCollectionViewCell" forIndexPath:indexPath];
    //else
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CircleSmallCollectionViewCell" forIndexPath:indexPath];
    
    [cell setCircleObject:self.circles[indexPath.item]];
    
    return cell;
}

/*- (UICollectionReusableView *)collectionView:
 (UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
 {
 return [[UICollectionReusableView alloc] init];
 }*/

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Select Item
    //NSLog(@"Selected item %ld", indexPath.item);
    
    self.selectedIndexPath = [NSIndexPath indexPathForItem:indexPath.item inSection:indexPath.section];
    
    [self performSegueWithIdentifier:@"showCircleInfoViewController" sender:self];
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize retval;
    
    //if (indexPath.item % 3 == 0 && NO) {
    //    retval.height = 225;
    //    retval.width = 225;
    //} else if (indexPath.item % 2 == 0 && NO) {
    //    retval.height = 190;
    //    retval.width = 190;
    //} else {
        retval.height = 150;
        retval.width = 150;
    //}
    
    return retval;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

@end
