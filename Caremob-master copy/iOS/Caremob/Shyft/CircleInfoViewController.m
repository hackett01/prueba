//
//  CircleInfoViewController.m
//  Shyft
//
//  Created by Rick Strom on 11/18/14.
//  Copyright (c) 2014 Rick Strom. All rights reserved.
//

#import "CircleInfoViewController.h"

@interface CircleInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *circleTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *circleCategoryLabel;
@property (weak, nonatomic) IBOutlet UITextView *circleShortTextTextView;
@property (weak, nonatomic) IBOutlet UILabel *circleTotalMomentsOfSilenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *circleFriendsInCircleLabel;
@property (weak, nonatomic) IBOutlet UILabel *circleTotalTimeInMomentsOfSilenceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;
@property (weak, nonatomic) IBOutlet UIButton *uniteButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

@property (weak, nonatomic) IBOutlet UIView *descriptionView;
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UIView *interactionView;
@property (weak, nonatomic) IBOutlet UIView *shareView;

@property (weak, nonatomic) IBOutlet UICollectionView *circleActionsCollectionView;
@property (weak, nonatomic) IBOutlet UIImageView *uniteSpinner0ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *uniteSpinner1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *uniteSpinnerTopImageView;

@property (weak, nonatomic) IBOutlet UILabel *uniteInfo0Label;
@property (weak, nonatomic) IBOutlet UILabel *uniteInfo1Label;

@property (weak, nonatomic) IBOutlet UIImageView *progressTopFill;
@property (weak, nonatomic) IBOutlet UIImageView *progressBottomFill;
@property (weak, nonatomic) IBOutlet UIImageView *progressActive;
@property (weak, nonatomic) IBOutlet UILabel *progressTimeLabel;

- (IBAction)uniteButtonTouchDown:(id)sender;
- (IBAction)uniteButtonTouchUpInside:(id)sender;
- (IBAction)uniteButtonTouchUpOutside:(id)sender;
- (IBAction)shareButtonHit:(id)sender;
- (IBAction)moreButtonHit:(id)sender;

@end

@implementation CircleInfoViewController
/*
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Configure the navigation bar
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"caremob_navbar_logo"]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:12.0/255.0 green:105.0/255.0 blue:148.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
 
    
    UIBarButtonItem *MyBackButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    //UIBarButtonItem *MyBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navBarBackButton"] landscapeImagePhone:[UIImage imageNamed:@"navBarBackButton"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    MyBackButton.title = @"";
    
    NSDictionary *myBackButtonTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                [UIColor colorWithRed:146.0/255.0 green:146.0/255.0 blue:146.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                [UIFont fontWithName:@"NettoOT" size:16.0f], NSFontAttributeName,
                                                nil];
    [MyBackButton setTitleTextAttributes:myBackButtonTextAttributes forState:UIControlStateNormal];
    [MyBackButton setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.backBarButtonItem = MyBackButton;
    
    self.totalTime = 10.0;
    self.uniteInfo1Label.text = [NSString stringWithFormat:@"%ds", (int)ceil(self.totalTime)];
    
    // Start spinning the spinners
 
    CABasicAnimation *halfTurn;
    halfTurn = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    halfTurn.fromValue = [NSNumber numberWithFloat:0];
    halfTurn.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
    halfTurn.duration = 2.5;
    halfTurn.repeatCount = HUGE_VALF;
    [[self.uniteSpinner0ImageView layer] addAnimation:halfTurn forKey:@"180"];
    
    CABasicAnimation *halfTurnReverse;
    halfTurnReverse = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    halfTurnReverse.fromValue = [NSNumber numberWithFloat:0];
    halfTurnReverse.toValue = [NSNumber numberWithFloat:(-(360*M_PI)/180)];
    halfTurnReverse.duration = 2.5;
    halfTurnReverse.repeatCount = HUGE_VALF;

    [[self.uniteSpinner1ImageView layer] addAnimation:halfTurnReverse forKey:@"180r"];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.progressFillBottomRect = CGRectMake(46.5, 103.0, self.progressBottomFill.bounds.size.width, self.progressBottomFill.bounds.size.height);
    self.progressFillTopRect = CGRectMake(46.5, 56.0, self.progressTopFill.bounds.size.width, self.progressTopFill.bounds.size.height);
    
    // Check to see if a circleAction exists for this user already.  If not, show the interaction view, else show shareview
    PFQuery *actionExistsQuery = [PFQuery queryWithClassName:kCircleActionClassKey];
    [actionExistsQuery setCachePolicy:kPFCachePolicyNetworkOnly];
    [actionExistsQuery whereKey:kCircleActionFieldCircleKey equalTo:self.circle];
    [actionExistsQuery whereKey:kCircleActionFieldUserKey equalTo:[PFUser currentUser]];
    [actionExistsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Error fetching Circle" message:@"Could not fetch info for this circle" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        } else {
            if (objects != nil && objects.count > 0) {
                [self showShareView];
                self.circleAction = (PFObject*)objects[0];
            }
            else [self showInteractionView];
            
            [self presentCircleInfo];
        }
    }];
    
    //[self showInteractionView];
}

-(void)viewDidAppear:(BOOL)animated {
   
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
    if ([segue.identifier isEqualToString:@"showSharableMediaObjectViewController"]) {
        SocialShareViewController *destination = (SocialShareViewController*)[segue destinationViewController];
        destination.circle = self.circle;
        destination.circleAction = self.circleAction;
        destination.totalFriendsInCircle = self.totalFriendsInCircle;
        
    }
}



-(void)back {
    
}

-(void)presentCircleInfo {
    
    if (self.circle != nil) {
        self.uniteButton.hidden = NO;
        self.uniteButton.enabled = YES;
        
        self.circleTitleLabel.text = [self.circle objectForKey:kCircleFieldTitleKey];
        self.circleCategoryLabel.text = [self.circle objectForKey:kCircleFieldCategoryKey];
        self.circleShortTextTextView.text = [self.circle objectForKey:kCircleFieldShortTextKey];
        
        // Set total moments of silence label
        long totalMomentsOfSilence = [[self.circle objectForKey:kCircleFieldTotalCircleActions] integerValue];
        self.circleTotalMomentsOfSilenceLabel.text = [NSString stringWithFormat:@"%ld", totalMomentsOfSilence];
        
        // Set total time in moments of silence
        float totalTimeInMomentsOfSilence = [[self.circle objectForKey:kCircleFieldTotalCircleActionValue] floatValue];
        int minutes = (int)totalTimeInMomentsOfSilence / 60;
        int seconds = (int)(totalTimeInMomentsOfSilence - 60 * minutes);
        self.circleTotalTimeInMomentsOfSilenceLabel.text = [NSString stringWithFormat:@"%02d:%02d",minutes, seconds];

        PFFile *imageFile = (PFFile*)[self.circle objectForKey:kCircleFieldImageKey];
        if ([imageFile isDataAvailable]) {
            self.circleImageView.image = [UIImage imageWithData:[imageFile getData]];
            self.circleImageView.hidden = NO;
        } else {
            [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (error) {
                    // TODO: Show default image
                } else {
                    self.circleImageView.image = [UIImage imageWithData:data];
                    self.circleImageView.hidden = NO;                    
                }
            }];
        }
        
    }
    
    
    self.totalTime = [[self.circle objectForKey:kCircleFieldTimeToJoinKey] integerValue];;
    self.uniteInfo1Label.text = [NSString stringWithFormat:@"%ds", (int)ceil(self.totalTime)];

    
    NSString *url = [self.circle objectForKey:kCircleFieldUrlKey];
    if (url == nil || url.length == 0) {
        self.moreButton.hidden = YES;
        self.moreButton.enabled = NO;
    }
    
    // Fetch the circle actions
    PFQuery *actionsQuery = [PFQuery queryWithClassName:kCircleActionClassKey];
    [actionsQuery whereKey:kCircleActionFieldCircleKey equalTo:self.circle];
    [actionsQuery includeKey:kCircleActionFieldUserKey];
    [actionsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {

        } else {
            self.circleActions = [NSArray arrayWithArray:objects];
            
            // Choose a centered flow layout if we have enough users
            if (objects.count >= 5) {
                KTCenterFlowLayout *layout = [KTCenterFlowLayout new];
                self.circleActionsCollectionView.collectionViewLayout = layout;
            }
            
            [self.circleActionsCollectionView reloadData];
            
            // Check how many friends in this circle
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.circle.objectId, @"circle", nil];
            [PFCloud callFunctionInBackground:@"totalFriendsInCircle" withParameters:params block:^(NSNumber *results, NSError *error) {
                if (error) {
                    //[[[UIAlertView alloc] initWithTitle:@"Error fetching totalFriendsInCircle" message:[NSString stringWithFormat:@"%@", error.localizedDescription] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                } else {
                    // this is where you handle the results and change the UI.
                    //[[[UIAlertView alloc] initWithTitle:@"Fetched totalFriendsInCircle" message:[NSString stringWithFormat:@"%@", results] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                    self.totalFriendsInCircle = (int)[results integerValue];
                    self.circleFriendsInCircleLabel.text = [NSString stringWithFormat:@"%d", self.totalFriendsInCircle];
                }
            }];

        }
        
    }];
    
   

    
}

-(void)showInteractionView {
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:self.interactionView.layer.opacity];
    fadeAnim.toValue = [NSNumber numberWithFloat:1.0];
    fadeAnim.duration = 0.5;
    [self.interactionView.layer addAnimation:fadeAnim forKey:@"opacity"];

    self.interactionView.layer.opacity = 1.0;
    
    self.uniteButton.hidden = NO;
    self.uniteButton.enabled = YES;

}

-(void)hideInteractionView {
    self.uniteButton.hidden = YES;
    self.uniteButton.enabled = NO;

    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:self.interactionView.layer.opacity];
    fadeAnim.toValue = [NSNumber numberWithFloat:0.0];
    fadeAnim.duration = 0.5;
    [self.interactionView.layer addAnimation:fadeAnim forKey:@"opacity"];
 
    self.interactionView.layer.opacity = 0.0;

    
}

-(void)showShareView {
    self.shareButton.hidden = NO;
    self.shareButton.enabled = YES;
    
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:0.0];
    fadeAnim.toValue = [NSNumber numberWithFloat:1.0];
    fadeAnim.duration = 0.5;
    [self.shareView.layer addAnimation:fadeAnim forKey:@"opacity"];
    
    self.shareView.layer.opacity = 1.0;

    
}

-(void)hideShareView {
    self.shareButton.hidden = YES;
    self.shareButton.enabled = NO;

    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:self.shareView.layer.opacity];
    fadeAnim.toValue = [NSNumber numberWithFloat:0.0];
    fadeAnim.duration = 0.5;
    [self.shareView.layer addAnimation:fadeAnim forKey:@"opacity"];
 
    self.shareView.layer.opacity = 0.0;

}


-(void) incrementCounter {
    if (!self.fingerIsDown) return;
   
    //NSDate *endTime = [NSDate date];
   
   // NSTimeInterval timeInterval = [endTime timeIntervalSinceDate:self.pressStartTime];

    //NSLog(@"Counting: %f", timeInterval);
    
    // Clip the images
    self.timeAccumulator += 0.05;
    NSLog(@"Time accumulator is now %f", self.timeAccumulator);
    float percentage = self.timeAccumulator / self.totalTime;
    
    int timeLeft = (int)ceil(self.totalTime - self.timeAccumulator);
    if (timeLeft < 0) timeLeft = 0;
    self.progressTimeLabel.text = [NSString stringWithFormat:@"%ds", timeLeft];
    
    if (percentage >= 1.0) {
        percentage = 1.0;
        self.progressActive.layer.opacity = 0.0;
    } else {
        self.progressActive.layer.opacity = 1.0;
    }
   
    
    // Fill bottom rect from 0 to 100%
    self.progressTopFill.frame = CGRectMake(self.progressFillTopRect.origin.x, self.progressFillTopRect.origin.y + 45.0 * (percentage), self.progressFillTopRect.size.width, 45.0 * (1.0 -percentage));
    self.progressBottomFill.frame = CGRectMake(self.progressFillBottomRect.origin.x, self.progressFillBottomRect.origin.y + 45.0 * (1.0 - percentage), self.progressFillBottomRect.size.width, 45.0 * (percentage));
    
    NSLog(@"New bottom frame: %f,%f,%f,%f", self.progressBottomFill.frame.origin.x, self.progressBottomFill.frame.origin.y + 45.0 * (percentage), self.progressBottomFill.frame.size.width, 45.0 * (percentage));
    [self performSelector:@selector(incrementCounter) withObject:nil afterDelay:0.05];
}

- (IBAction)uniteButtonTouchDown:(id)sender {
    self.fingerIsDown = YES;
    
    if (self.pressStartTime == nil) {
        
        [self hideDescriptionView];
        [self showProgressView];
    }
    
    [self hideInfoLabels];
    [self showSpinner];
    
    self.pressStartTime = [NSDate date];
    
    [self.uniteButton setBackgroundImage:[UIImage imageNamed:@"caremob_circle_unite_button_press"] forState:UIControlStateNormal];
    
    
    int timeLeft = (int)ceil(self.totalTime - self.timeAccumulator);
    if (timeLeft < 0) timeLeft = 0;
    self.progressTimeLabel.text = [NSString stringWithFormat:@"%ds", timeLeft];
    
    [self incrementCounter];
    
    // Tell all the user cells to show themselves
    for(CircleActionCollectionViewCell* cell in [self.circleActionsCollectionView visibleCells]){
        [cell show];
    }
}

- (IBAction)uniteButtonTouchUpInside:(id)sender {
    self.fingerIsDown = NO;
    
    NSDate *endTime = [NSDate date];
    
    NSTimeInterval timeInterval = [endTime timeIntervalSinceDate:self.pressStartTime];
    NSLog(@"Held for %f seconds", timeInterval);
    
   [self.uniteButton setBackgroundImage:[UIImage imageNamed:@"caremob_circle_unite_button_ready"] forState:UIControlStateNormal];
    
    //self.pressStartTime = nil;
    
    [self showInfoLabels];
    [self hideSpinner];

    
    // Tell all the user cells to hide themselves
    for(CircleActionCollectionViewCell* cell in [self.circleActionsCollectionView visibleCells]){
        
        [cell hide];
        
    }

    // Are we done? If so then transition to the next view
    if (self.timeAccumulator >= self.totalTime) {
        // Hide the interaction view
        [self hideInteractionView];
        
        // Create a new circle action
        PFObject *circleAction = [PFObject objectWithClassName:kCircleActionClassKey];
        [circleAction setObject:[PFUser currentUser] forKey:kCircleActionFieldUserKey];
        [circleAction setObject:self.circle forKey:kCircleActionFieldCircleKey];
        [circleAction setObject:[self.circle objectForKey:kCircleFieldTitleKey] forKey:kCircleActionFieldTitleKey];
        [circleAction setObject:[NSNumber numberWithFloat:self.timeAccumulator] forKey:kCircleActionFieldCircleActionUnitsKey];
        [circleAction setObject:kCircleActionTypeHold forKey:kCircleActionFieldTypeKey];
        [circleAction saveInBackground];
        
        self.circleAction = circleAction;
        
        // Update the local copy of the circle
        long totalCircleActions = [[self.circle objectForKey:kCircleFieldTotalCircleActions] longValue];
        double totalCircleActionValue = [[self.circle objectForKey:kCircleFieldTotalCircleActionValue] doubleValue];
        
        totalCircleActions += 1;
        totalCircleActionValue += (double)self.timeAccumulator;
        
        [self.circle setObject:[NSNumber numberWithLong:totalCircleActions] forKey:kCircleFieldTotalCircleActions];
        [self.circle setObject:[NSNumber numberWithDouble:totalCircleActionValue] forKey:kCircleFieldTotalCircleActionValue];
        
        // NO SAVE -- this is just local
        
        // Update the labels for the above values
        // Set total moments of silence label
        long totalMomentsOfSilence = [[self.circle objectForKey:kCircleFieldTotalCircleActions] integerValue];
        self.circleTotalMomentsOfSilenceLabel.text = [NSString stringWithFormat:@"%ld", totalMomentsOfSilence];
        
        // Set total time in moments of silence
        float totalTimeInMomentsOfSilence = [[self.circle objectForKey:kCircleFieldTotalCircleActionValue] floatValue];
        int minutes = (int)totalTimeInMomentsOfSilence / 60;
        int seconds = (int)(totalTimeInMomentsOfSilence - 60 * minutes);
        self.circleTotalTimeInMomentsOfSilenceLabel.text = [NSString stringWithFormat:@"%02d:%02d",minutes, seconds];
        
        // Push the share view controller
        [self performSegueWithIdentifier:@"showSharableMediaObjectViewController" sender:self];
    }

}

- (IBAction)uniteButtonTouchUpOutside:(id)sender {
    // Forward to touch up inside
    [self uniteButtonTouchUpInside:sender];
}

- (IBAction)shareButtonHit:(id)sender {
    [self performSegueWithIdentifier:@"showSharableMediaObjectViewController" sender:self];
}

- (IBAction)moreButtonHit:(id)sender {
    NSString *url = [self.circle objectForKey:kCircleFieldUrlKey];
    if (url == nil || url.length == 0) return;
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

-(void)hideSpinner {
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:1.0];
    fadeAnim.toValue = [NSNumber numberWithFloat:0.0];
    fadeAnim.duration = 0.5;
    [self.uniteSpinner0ImageView.layer addAnimation:fadeAnim forKey:@"opacity"];
    [self.uniteSpinner1ImageView.layer addAnimation:fadeAnim forKey:@"opacity"];
    [self.uniteSpinnerTopImageView.layer addAnimation:fadeAnim forKey:@"opacity"];
    
    self.uniteSpinner0ImageView.layer.opacity = 0.0;
    self.uniteSpinner1ImageView.layer.opacity = 0.0;
    self.uniteSpinnerTopImageView.layer.opacity = 0.0;
    
}

-(void)showSpinner {
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:0.0];
    fadeAnim.toValue = [NSNumber numberWithFloat:1.0];
    fadeAnim.duration = 0.5;
    [self.uniteSpinner0ImageView.layer addAnimation:fadeAnim forKey:@"opacity"];
    [self.uniteSpinner1ImageView.layer addAnimation:fadeAnim forKey:@"opacity"];
    [self.uniteSpinnerTopImageView.layer addAnimation:fadeAnim forKey:@"opacity"];
    
    self.uniteSpinner0ImageView.layer.opacity = 1.0;
    self.uniteSpinner1ImageView.layer.opacity = 1.0;
    self.uniteSpinnerTopImageView.layer.opacity = 1.0;
}

-(void)hideInfoLabels {
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:1.0];
    fadeAnim.toValue = [NSNumber numberWithFloat:0.0];
    fadeAnim.duration = 0.5;
    [self.uniteInfo0Label.layer addAnimation:fadeAnim forKey:@"opacity"];
    [self.uniteInfo1Label.layer addAnimation:fadeAnim forKey:@"opacity"];
    
    self.uniteInfo0Label.layer.opacity = 0.0;
    self.uniteInfo1Label.layer.opacity = 0.0;
    
}

-(void)showInfoLabels {
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:0.0];
    fadeAnim.toValue = [NSNumber numberWithFloat:1.0];
    fadeAnim.duration = 0.5;
    [self.uniteInfo0Label.layer addAnimation:fadeAnim forKey:@"opacity"];
    [self.uniteInfo1Label.layer addAnimation:fadeAnim forKey:@"opacity"];
    
    self.uniteInfo0Label.layer.opacity = 1.0;
    self.uniteInfo1Label.layer.opacity = 1.0;
}

-(void)hideDescriptionView {
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:1.0];
    fadeAnim.toValue = [NSNumber numberWithFloat:0.0];
    fadeAnim.duration = 0.5;
    [self.descriptionView.layer addAnimation:fadeAnim forKey:@"opacity"];
    
    self.descriptionView.layer.opacity = 0.0;
}

-(void)hideProgressView {
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:1.0];
    fadeAnim.toValue = [NSNumber numberWithFloat:0.0];
    fadeAnim.duration = 0.5;
    [self.progressView.layer addAnimation:fadeAnim forKey:@"opacity"];
    
    self.progressView.layer.opacity = 0.0;
}

-(void)showDescriptionView {
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:0.0];
    fadeAnim.toValue = [NSNumber numberWithFloat:1.0];
    fadeAnim.duration = 0.5;
    [self.descriptionView.layer addAnimation:fadeAnim forKey:@"opacity"];
    
    self.descriptionView.layer.opacity = 1.0;

}

-(void)showProgressView {
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:0.0];
    fadeAnim.toValue = [NSNumber numberWithFloat:1.0];
    fadeAnim.duration = 0.5;
    [self.progressView.layer addAnimation:fadeAnim forKey:@"opacity"];
    
    self.progressView.layer.opacity = 1.0;
    
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (self.circleActions == nil) return 0;
    else {
        if (self.circleActions.count + 1 < 50)
            return self.circleActions.count + 1;
        else return 50;
    }
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CircleActionCollectionViewCell *cell;
    
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CircleActionCollectionViewCell" forIndexPath:indexPath];
    
    float delay = (((float) rand() / RAND_MAX) * 0.95) + 0.05;
    float showTime = (((float) rand() / RAND_MAX) * 2.95) + 5.05;
    
    
    NSMutableArray *userArray = [[NSMutableArray alloc] init];
    if (indexPath.item == 0) {
        [userArray addObject:[PFUser currentUser]];
    } else {
        int i = indexPath.item - 1;
        while (i < self.circleActions.count) {
            PFObject *action = (PFObject*)self.circleActions[i];
            PFUser *user = (PFUser*)[action objectForKey:kCircleActionFieldUserKey];
        
            [userArray addObject:user];
            i += 50;
        }
    }
    //NSLog(@"Adding array with %d users", userArray.count);
    [cell initializeWithUsers:userArray andDelay:delay andShowTime:showTime];
    
    return cell;
}



#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Select Item
    //NSLog(@"Selected item %ld", indexPath.item);
    
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
    retval.height = 52;
    retval.width = 52;
    //}
    
    return retval;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
 */
@end
