//
//  CaremobDisplayViewController.m
//  Caremob
//
//  Created by Rick Strom on 6/2/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import "CaremobDisplayViewController.h"

@interface CaremobDisplayViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *caremobImageView;
@property (weak, nonatomic) IBOutlet UILabel *caremobTitleLabel;
@property (weak, nonatomic) IBOutlet UITextView *caremobBodyTextView;
@property (weak, nonatomic) IBOutlet UILabel *caremobSourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *caremobDateLabel;

// Choose SubMob view
@property (weak, nonatomic) IBOutlet UIButton *subMobJoinButton;
@property (weak, nonatomic) IBOutlet UIButton *subMobSwitchButton;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *subMobButtons;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *subMobButtonsTotalMobActionsLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *subMobButtonsTotalMobActionValueLabels;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *subMobButtonsTotalMobActionValueIconImageViews;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *subMobButtonsTotalMobActionsIconImageViews;




@property (weak, nonatomic) IBOutlet UIView *subMobSelectorView;
@property (weak, nonatomic) IBOutlet UIView *subMobStatsView;
@property (weak, nonatomic) IBOutlet PFImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIImageView *userBackgroundImageView;

@property (weak, nonatomic) IBOutlet UIImageView *totalMobActionsIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *totalMobActionsLabel;

@property (weak, nonatomic) IBOutlet UIImageView *totalMobActionValueIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *totalMobActionValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *pointsToNextLevelLabel;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIImageView *pointsToNextLevelProgressBGImageView;
@property (weak, nonatomic) IBOutlet UIImageView *pointsToNextLevelProgressFillImageView;
@property (weak, nonatomic) IBOutlet UIImageView *timeToNextPointProgressBGImageView;
@property (weak, nonatomic) IBOutlet UIImageView *timeToNextPointProgressFillImageView;
@property (weak, nonatomic) IBOutlet UIImageView *timeToNextPointProgressIndicator;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeToNextPointProgressIndicatorHorizontalSpacingConstraint;

@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIImageView *shareButtonAnimatedImageView;
@property (weak, nonatomic) IBOutlet UIButton *userListTopMobbersButton;
@property (weak, nonatomic) IBOutlet UIButton *userListFirstMobbersButton;
@property (weak, nonatomic) IBOutlet UIButton *userListNearbyMobbersButton;

@property (weak, nonatomic) IBOutlet UIView *afterActionView;



- (IBAction)subMobButtonHit:(id)sender;
- (IBAction)shareButtonHit:(id)sender;
- (IBAction)userListTopMobbersButtonHit:(id)sender;
- (IBAction)userListFirstMobbersButtonHit:(id)sender;
- (IBAction)userListNearbyMobbersButtonHit:(id)sender;


// Join SubMob view
@property (weak, nonatomic) IBOutlet UIImageView *categoryMobActionStatusBGImageView;
@property (weak, nonatomic) IBOutlet UIButton *mobActionButton;

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *mobActionActivitySpinnerImageViews;

@property (weak, nonatomic) IBOutlet UIView *doActionView;
@property (weak, nonatomic) IBOutlet MCPercentageDoughnutView *mobActionProgressCircleView;
@property (weak, nonatomic) IBOutlet UIImageView *leveledUpOverlay;

@property (weak, nonatomic) IBOutlet UIImageView *mobActionPointsIcon;
@property (weak, nonatomic) IBOutlet UILabel *mobActionPointsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mobActionTotalTimeIcon;
@property (weak, nonatomic) IBOutlet UILabel *mobActionTotalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobActionRankLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobActionTimeToNextPointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *selectedSubMobCategoryLabel;

@property (weak, nonatomic) IBOutlet UILabel *userGainedPointStencil;
@property (weak, nonatomic) IBOutlet UILabel *mobGainedLevelStencil;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userGainedPointStencilSpacingConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mobGainedLevelStencilSpacingConstraint;

- (IBAction)mobActionButtonTouchDown:(id)sender;
- (IBAction)mobActionButtonTouchUpInside:(id)sender;
- (IBAction)mobActionButtonTouchUpOutside:(id)sender;

// Heatmap container view
@property (weak, nonatomic) IBOutlet UIView *heatmapContainerView;
@property (weak, nonatomic) HeatmapViewController *heatmapViewController;

// Tutorial
@property (weak, nonatomic) IBOutlet UIImageView *tutorial0ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tutorial1ImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tutorial2ImageView;


@end

@implementation CaremobDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Initialize the category list
    //self.categoryList = @[@"support",@"protest",@"awareness",@"peace",@"love",@"mourning"];
    
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

    // Set up locaton manager and request location when in use
    self.locationManager = [[CLLocationManager alloc] init];
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])
        [self.locationManager requestWhenInUseAuthorization];
    
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];

    if ([PFUser currentUser]) {
        PFObject *currentUser = (PFObject*)[PFUser currentUser];
        self.userImageView.file = (PFFile*)[currentUser objectForKey:kUserFieldProfileImageKey];
        [self.userImageView loadInBackground];
    }
    
    // Initialize the share button animated image view
    NSMutableArray *shareButtonFramesArray = [[NSMutableArray alloc] init];
    
    // Add the final frame first
    //[shareButtonFramesArray addObject:[UIImage imageNamed:@"share_animation_12"]];
    self.shareButtonAnimatedImageView.image = [UIImage imageNamed:@"share_animation_3"];
    
    for (int i = 0; i < 13; i++) {
        [shareButtonFramesArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"share_animation_%d", i]]];
    }
    
    self.shareButtonAnimatedImageView.animationImages = shareButtonFramesArray;
    self.shareButtonAnimatedImageView.animationDuration = 2.0;
    self.shareButtonAnimatedImageView.animationRepeatCount = 2;
    //[self.shareButtonAnimatedImageView startAnimating];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.didPreInitialize) return;
    
    if (self.careMob != nil) {
        PFFile *imageFile = [self.careMob objectForKey:kCareMobImageKey];
        self.caremobImageView.file = imageFile;
        [self.caremobImageView loadInBackground];
        
        self.caremobTitleLabel.text = [self.careMob objectForKey:kCareMobTitleKey];
        self.caremobBodyTextView.text = [self.careMob objectForKey:kCareMobLongTextKey];
        [self.caremobBodyTextView scrollRangeToVisible:NSMakeRange(0, 0)];
        
        
        // Deal with the category context
        NSLog(@"Category context: %@", self.categoryContext);
        
        // Set the source and date label
        NSString *source = (NSString*)[self.careMob objectForKey:kCareMobSourceKey];
        PFObject *sourceUser = (PFObject*)[self.careMob objectForKey:kCareMobSourceUserKey];
        
        if (source != nil) {
            NSString *sourceString = @"Other";
            
            sourceString = [CareMobHelper feedSourceValueToPrintableString:source];
                        
            self.caremobSourceLabel.text = [NSString stringWithFormat:@"Source: %@", sourceString];
        } else if (sourceUser != nil) {
            NSString *sourceUserUsername = (NSString*)[sourceUser objectForKey:kUserFieldNameKey];
            
            self.caremobSourceLabel.text = [NSString stringWithFormat:@"Source: %@", sourceUserUsername];
        } else self.caremobSourceLabel.text = @"";
        
        NSDateFormatter *nowDateFormatter = [[NSDateFormatter alloc] init];
        [nowDateFormatter setDateFormat:@"MMMM d, yyyy"];
        NSString *dateString = [nowDateFormatter stringFromDate:self.careMob.createdAt];
        self.caremobDateLabel.text = dateString;
    }
    
    self.didPreInitialize = YES;
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.didPostInitialize) return;
    
    [self initialize];
    [self fetchMobActions];
    
    self.didPostInitialize = YES;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"heatmapChildViewSegue"]) {
        self.heatmapViewController = (HeatmapViewController*)segue.destinationViewController;
        
    } else if ([segue.identifier isEqualToString:@"showSocialShareViewController"]) {
        SocialShareViewController *destination = (SocialShareViewController*)segue.destinationViewController;
        
        UIImage *heatmapImage = [self.heatmapViewController getFlattenedImage];
        
        destination.heatmapImage = heatmapImage;
        
        destination.careMob = self.careMob;
        destination.subMob = self.selectedSubMob;
        destination.mobAction = self.activeMobAction;
    } else if ([segue.identifier isEqualToString:@"showCaremobUserListViewController"]) {
        CaremobUserListViewController *destination = (CaremobUserListViewController*)segue.destinationViewController;
        
        destination.careMob = self.careMob;
        destination.subMob = self.selectedSubMob;
        destination.selectedMode = self.selectedCaremobUserListMode;
        
        if (self.selectedCaremobUserListMode == kCaremobUserListTableModeNearbyMobbers) {
            CLLocation *location = self.locationManager.location;
            if (location == nil) {
                NSLog(@"location is nil");
            } else {
                CLLocationCoordinate2D coordinate = [location coordinate];
                NSLog(@"location is %f %f",coordinate.latitude, coordinate.longitude);
                PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
                destination.location = geoPoint;
            }
        }
    }
}

-(void)back {
    
}

-(void)initialize {
    //self.selectedCategoryIndex = -1;
    self.selectedSubMob = nil;
    
    self.subMobs = (NSArray*)[self.careMob objectForKey:kCareMobSubMobsKey];
    if (self.subMobs == nil) self.subMobs = @[];
    NSLog(@"SubMobs array has %lu elemetns", (unsigned long)self.subMobs.count);
    
    self.displayMode = kCaremobDisplayModeReadyToJoin;
    
    // Set up the progress circle
    self.mobActionProgressCircleView.linePercentage = 0.22;
    self.mobActionProgressCircleView.percentage = 0.5;
    self.mobActionProgressCircleView.animatesBegining = NO;
    self.mobActionProgressCircleView.animationEnabled = YES;
    self.mobActionProgressCircleView.borderColorForFilledArc = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    self.mobActionProgressCircleView.borderColorForUnfilledArc = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
    self.mobActionProgressCircleView.unfillColor = [UIColor colorWithRed:9.0/255.0 green:64.0/255.0 blue:89.0/255.0 alpha:1.0];
    self.mobActionProgressCircleView.fillColor = [UIColor colorWithRed:65.0/255.0 green:209.0/255.0 blue:240.0/255.0 alpha:1.0];
    self.mobActionProgressCircleView.showTextLabel = NO;


    
    // Store the initial frames of all the buttons
    self.categoryButtonInitialFrames = [[NSMutableDictionary alloc] init];

    self.categoryButtonInitialFrames[@"all"] = [NSValue valueWithCGRect:CGRectMake(self.subMobSwitchButton.frame.origin.x, self.subMobSwitchButton.frame.origin.y, self.subMobSwitchButton.frame.size.width, self.subMobSwitchButton.frame.size.height)];
    self.categoryButtonInitialFrames[@"join"] = [NSValue valueWithCGRect:CGRectMake(self.subMobJoinButton.frame.origin.x, self.subMobJoinButton.frame.origin.y, self.subMobJoinButton.frame.size.width, self.subMobJoinButton.frame.size.height)];
    
    for (int i = 0; i < self.subMobButtons.count; i++) {
        self.categoryButtonInitialFrames[[NSString stringWithFormat:@"%d",i]] = [NSValue valueWithCGRect:CGRectMake(((UIButton*)self.subMobButtons[i]).frame.origin.x, ((UIButton*)self.subMobButtons[i]).frame.origin.y, ((UIButton*)self.subMobButtons[i]).frame.size.width, ((UIButton*)self.subMobButtons[i]).frame.size.height)];
    }

    // Store the initial centers of all the buttons
    self.categoryButtonInitialCenters = [[NSMutableDictionary alloc] init];

    self.categoryButtonInitialCenters[@"all"] = [NSValue valueWithCGPoint:CGPointMake(self.subMobSwitchButton.center.x, self.subMobSwitchButton.center.y)];
    self.categoryButtonInitialCenters[@"join"] = [NSValue valueWithCGPoint:CGPointMake(self.subMobJoinButton.center.x, self.subMobJoinButton.center.y)];

    
    for (int i = 0; i < self.subMobButtons.count; i++) {
        UIButton *b = (UIButton*)self.subMobButtons[i];
        
        self.categoryButtonInitialCenters[[NSString stringWithFormat:@"%d",i]] = [NSValue valueWithCGPoint:CGPointMake(b.center.x, b.center.y)];
    }
    
    CGPoint joinButtonCenter = [self.categoryButtonInitialCenters[@"join"] CGPointValue];
    
    // Set the SubMob button images and hide them
    for (int i = 0; i < self.subMobButtons.count; i++) {
        UIButton *b = (UIButton*)self.subMobButtons[i];
        b.enabled = NO;
        
        UILabel *totalMobActionsLabel = (UILabel*)self.subMobButtonsTotalMobActionsLabels[i];
        UILabel *totalMobActionValueLabel = (UILabel*)self.subMobButtonsTotalMobActionValueLabels[i];
        
        UIImageView *totalMobActionsIcon = (UIImageView*)self.subMobButtonsTotalMobActionsIconImageViews[i];
        UIImageView *totalMobActionValueIcon = (UIImageView*)self.subMobButtonsTotalMobActionValueIconImageViews[i];
        
        if (i < self.subMobs.count) {
            PFObject *subMob = self.subMobs[i];
            NSString *subMobCategory = [subMob objectForKey:kSubMobCategoryKey];
            NSNumber *subMobTotalMobActions = [subMob objectForKey:kSubMobTotalMobActionsKey];
            NSNumber *subMobTotalMobActionValue = [subMob objectForKey:kSubMobTotalMobActionValueKey];
            
            //[b setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"caremob_category_icon_big_%@", subMobCategory]] forState:UIControlStateNormal];
            [b setTitle:subMobCategory forState:UIControlStateNormal];
            
            if ([subMobTotalMobActions intValue] == 0 && [subMobTotalMobActionValue doubleValue] == 0.0) {
                totalMobActionsLabel.text = @"";
                totalMobActionValueLabel.text = @"";

                totalMobActionsIcon.hidden = YES;
                totalMobActionValueIcon.hidden = YES;
                
                [b setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"mob_selector_%@", subMobCategory]] forState:UIControlStateNormal];
            } else {
                
            
                totalMobActionsLabel.text = [NSString stringWithFormat:@"%d", [subMobTotalMobActions intValue]];
                totalMobActionValueLabel.text = [CareMobHelper timeToString:[subMobTotalMobActionValue doubleValue]];
                
                totalMobActionsIcon.hidden = NO;
                totalMobActionValueIcon.hidden = NO;
                
                [b setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"mob_selector_%@_active", subMobCategory]] forState:UIControlStateNormal];

                /*
                NSString *totalTimeString;
                int totalTime = [subMobTotalMobActionValue intValue];
                int totalTimeMinutes = (int)totalTime / 60;
                int totalTimeSeconds = (int)totalTime - 60 * totalTimeMinutes;
            
                if (totalTimeMinutes > 0) totalTimeString = [NSString stringWithFormat:@"%dm %ds", totalTimeMinutes, totalTimeSeconds];
                else totalTimeString = [NSString stringWithFormat:@"%ds", totalTimeSeconds];
            
                totalMobActionValueLabel.text = [NSString stringWithFormat:@"%@", totalTimeString];
                 */
            }
            
            [UIView animateWithDuration:0.2 delay:0.05 * (float)i options:UIViewAnimationOptionCurveLinear animations:^{
                b.alpha = 0;
                b.center = joinButtonCenter;
                b.transform = CGAffineTransformMakeScale(1, 1);
            } completion:^(BOOL finished) {
                // Do nothing
            }];
        } else {
            // Disable the button
        }
    }
    
    [self animateSpinners];
    
    if (self.categoryContext != nil && ![self.categoryContext isEqualToString:@""]) {
        [self showTutorial:0];
        [self showTutorial:1];
    }
    
    [self showTutorial:2];

}

-(void)fetchMobActions {
    if (self.careMob != nil) {
        PFQuery *mobActionsQuery = [PFQuery queryWithClassName:kMobActionClassKey];
        [mobActionsQuery whereKey:kMobActionUserKey equalTo:[PFUser currentUser]];
        [mobActionsQuery whereKey:kMobActionCareMobKey equalTo:self.careMob];
        [mobActionsQuery orderByDescending:kMobActionUpdatedAtKey];
        [mobActionsQuery setCachePolicy:kPFCachePolicyNetworkElseCache];
        [mobActionsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                
            } else {
                if (objects != nil) {
                    self.mobActions = [NSMutableArray arrayWithArray:objects];
                    NSLog(@"mobActions is: %@", self.mobActions);
                } else {
                    self.mobActions = [[NSMutableArray alloc] init];
                }
                
                [self showCategorySelectView:YES];
                [self showDoActionView:NO];
                
                // If the context is nil, try to set the selected submob to the most recent submob
                // Otherwise show the button matching the context
                if (self.categoryContext != nil) {
                    // Did we receive a context? If so, show it
                    int index = 0;
                    for (int i = 0; i < self.subMobs.count; i++) {
                        PFObject *subMob = (PFObject*)self.subMobs[i];
                        NSString *subMobCategory = [subMob objectForKey:kSubMobCategoryKey];
                        
                        if ([subMobCategory isEqualToString:self.categoryContext]) index = i;
                    }
                    
                    [self updateSelectedSubMob:index];
                } else if (self.mobActions.count > 0) {
                    // Have we posted a mob action for this submob? If so, show the most recent category
                    PFObject *mostRecentMobAction = (PFObject*)self.mobActions[0];
                    PFObject *mostRecentSubMob = [mostRecentMobAction objectForKey:kMobActionSubMobKey];
                    
                    int index = 0;
                    for (int i = 0; i < self.subMobs.count; i++) {
                        PFObject *subMob = (PFObject*)self.subMobs[i];
                        
                        if ([subMob.objectId isEqualToString:mostRecentSubMob.objectId]) index = i;
                    }
                    
                    [self updateSelectedSubMob:index];
                } else {
                    // We have no context whatsoever.
                    [self updateSelectedSubMob:-1];
                }
            }
        }];
    }
}

-(void)updateSelectedSubMob:(int)categoryIndex {
    //self.selectedCategoryIndex = categoryIndex;
    
    //[UIView animateWithDuration:0.2 animations:^{
        self.mobActionRankLabel.alpha = 0;
    //} completion:^(BOOL finished) {
        // Do nothing
    //}];
    
    
    if (categoryIndex < 0) {
        // We don't have a selectedSubMob, so we hide the join button and show the selector

        // Hide the stats bar
        self.subMobStatsView.alpha = 0;
        
        // Hide the join button and move the all button to the center
        self.subMobJoinButton.enabled = NO;
        self.subMobJoinButton.alpha = 0;
    
        CGPoint newAllCenter = [self.categoryButtonInitialCenters[@"join"] CGPointValue];
        
        CGRect joinInitial = [(NSValue*)self.categoryButtonInitialFrames[@"join"] CGRectValue];
        CGRect allInitial = [(NSValue*)self.categoryButtonInitialFrames[@"all"] CGRectValue];

        float xScale = joinInitial.size.width / allInitial.size.width;
        float yScale = joinInitial.size.height / allInitial.size.height;

        self.subMobSwitchButton.center = newAllCenter;
        self.subMobSwitchButton.transform = CGAffineTransformMakeScale(xScale, yScale);
        
    } else {
        self.selectedSubMob = self.subMobs[categoryIndex];
        NSString *selectedSubMobCategory = [self.selectedSubMob objectForKey:kSubMobCategoryKey];
    
        self.selectedSubMobCategoryLabel.text = [selectedSubMobCategory uppercaseString];
        
        self.userBackgroundImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"caremob_display_userimage_background_%@", selectedSubMobCategory]];
        
        [self.subMobJoinButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"caremob_category_icon_%@", selectedSubMobCategory]] forState:UIControlStateNormal];
    
        if (self.mobActions == nil) self.mobActions = [[NSMutableArray alloc] init];
    
        self.activeMobAction = nil;
    
        for (int i = 0; i < self.mobActions.count; i++) {
            PFObject *mobAction = (PFObject*)self.mobActions[i];
            PFObject *mobActionSubMob = [mobAction objectForKey:kMobActionSubMobKey];
        
            if ([mobActionSubMob.objectId isEqualToString:self.selectedSubMob.objectId]) self.activeMobAction = mobAction;
        }
    
        // If we didn't find a mob action matching this category, we create one and add it to the mob actions array
        if (self.activeMobAction == nil) {
            self.activeMobAction = [PFObject objectWithClassName:kMobActionClassKey];
            [self.activeMobAction setObject:self.selectedSubMob forKey:kMobActionSubMobKey];
            [self.activeMobAction setObject:self.careMob forKey:kMobActionCareMobKey];
            [self.activeMobAction setObject:[PFUser currentUser] forKey:kMobActionUserKey];
            [self.activeMobAction setObject:[NSNumber numberWithDouble:0.0] forKey:kMobActionValueKey];
        
            [self.mobActions addObject:self.activeMobAction];
        }
        
        // Now, if the mobaction has time in it, we can turn on the share button
        NSNumber *mobActionValue = (NSNumber*)[self.activeMobAction objectForKey:kMobActionValueKey];
        if ([mobActionValue floatValue] > 0.0) {
            self.shareButton.hidden = NO;
            self.shareButtonAnimatedImageView.hidden = NO;
            self.shareButton.enabled = YES;
            
            [self.shareButtonAnimatedImageView startAnimating];
            
            // And show the afterActionView
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.afterActionView.alpha = 1;
            } completion:^(BOOL finished) {
                // Do nothing
            }];

            [self updateMobActionRank];
        } else {
            self.shareButton.hidden = YES;
            self.shareButtonAnimatedImageView.hidden = YES;
            self.shareButton.enabled = NO;
            
            // And hide the afterActionView
            [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.afterActionView.alpha = 0;
            } completion:^(BOOL finished) {
                // Do nothing
            }];


        }
        
        
        // Show the stats bar
        [self updateSelectedSubMobStats];
        self.subMobStatsView.alpha = 1;
        
        // Prerender heatmap
        PFQuery *recentMobActionsQuery = [PFQuery queryWithClassName:kMobActionClassKey];
        [recentMobActionsQuery whereKey:kMobActionSubMobKey equalTo:self.selectedSubMob];
        [recentMobActionsQuery orderByDescending:kMobActionUpdatedAtKey];
        [recentMobActionsQuery whereKeyExists:kMobActionLocationKey];
        [recentMobActionsQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                [self.heatmapViewController showHeatForMobActions:objects withMobType:selectedSubMobCategory];
            }
        }];
        
        
    }
}

-(void)updateSelectedSubMobStats {
    if (self.selectedSubMob == nil) return;
    
    NSNumber *subMobPoints = (NSNumber*)[self.selectedSubMob objectForKey:kSubMobPointsKey];;
    
    
    NSNumber *subMobLevel;
    
    if (self.newPointsEarned <= 0)
        subMobLevel = (NSNumber*)[self.selectedSubMob objectForKey:kSubMobLevelKey];
    else {
        //NSNumber *oldSubMobPoints = [NSNumber numberWithInt:[subMobPoints intValue]];
        
        subMobPoints = [NSNumber numberWithInt:[subMobPoints intValue] + self.newPointsEarned];
        
        //NSNumber *oldSubMobLevel = [NSNumber numberWithInt:[CareMobHelper calculateCareMobLevelForPoints:[oldSubMobPoints intValue]]];
        subMobLevel = [NSNumber numberWithInt:[CareMobHelper calculateCareMobLevelForPoints:[subMobPoints intValue]]];
    
    }
                       
    NSNumber *subMobTotalMobActionValue = (NSNumber*)[self.selectedSubMob objectForKey:kSubMobTotalMobActionValueKey];
    
    if (self.newTimeEarned > 0.0) {
        subMobTotalMobActionValue = [NSNumber numberWithDouble:[subMobTotalMobActionValue doubleValue] + self.newTimeEarned];
    }
    
    NSNumber *subMobTotalMobActions = (NSNumber*)[self.selectedSubMob objectForKey:kSubMobTotalMobActionsKey];
    NSNumber *activeMobActionValue = (NSNumber*)[self.activeMobAction objectForKey:kMobActionValueKey];
    if (activeMobActionValue == nil || [activeMobActionValue doubleValue] == 0.0) {
        if (self.newTimeEarned > 0)
            subMobTotalMobActions = [NSNumber numberWithInt:1 + [subMobTotalMobActions intValue]];
    }
    
    int pointsForThisLevel = [CareMobHelper calculateSubMobPointsRequiredForLevel:[subMobLevel intValue]];
    int pointsForNextLevel = [CareMobHelper calculateSubMobPointsRequiredForLevel:[subMobLevel intValue] + 1];
    int pointsToNextLevel = pointsForNextLevel - [subMobPoints intValue];
    //NSString *category = (NSString*)[self.selectedSubMob objectForKey:kSubMobCategoryKey];
    
    float percentPointsToNextLevel = 1.0 - ((float)pointsToNextLevel / (float)(pointsForNextLevel - pointsForThisLevel));
    
    //NSLog(@"Should clip width of progress bar to %f", percentPointsToNextLevel);
    
    /* REMOVED. this meter is now permanently hidden
    CGRect contentFrame = CGRectMake(0, 0, percentPointsToNextLevel, 1);
    self.pointsToNextLevelProgressFillImageView.layer.contentsRect = contentFrame;
    self.pointsToNextLevelProgressFillImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"caremob_category_level_progress_fill_%@", category]];
    self.pointsToNextLevelProgressBGImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"caremob_category_level_progress_bg_%@", category]];
    */
    
    // TODO move the above to the circle progress meter
    // TODO rename the circle view to reflect its new purpose as the subMobProgressCircleView
    if (percentPointsToNextLevel == 0.0) {
        if (self.mobActionProgressCircleView.percentage > 0.0) {
            // Show leveled up overlay
            self.leveledUpOverlay.alpha = 1;
            [UIView animateWithDuration:1.0 animations:^{
                self.leveledUpOverlay.alpha = 0.0f;
            } completion:^(BOOL finished) {
                self.leveledUpOverlay.alpha = 0.0f;
            }];
            
            // Show the mob gained level stencil

            if (self.newPointsEarned > 0)
                [self showMobGainedLevelStencil:YES andUserGainedPoint:YES];
        }
        
        self.mobActionProgressCircleView.percentage = percentPointsToNextLevel;
    } else {
        self.mobActionProgressCircleView.percentage = percentPointsToNextLevel;
    }
    
    self.totalMobActionsLabel.text = [NSString stringWithFormat:@"%d", [subMobTotalMobActions intValue]];
    
    NSString *totalTimeString;
    int totalTime = [subMobTotalMobActionValue intValue];
    int totalTimeMinutes = (int)totalTime / 60;
    int totalTimeSeconds = (int)totalTime - 60 * totalTimeMinutes;
    
    if (totalTimeMinutes > 0) totalTimeString = [NSString stringWithFormat:@"%dm %ds", totalTimeMinutes, totalTimeSeconds];
    else totalTimeString = [NSString stringWithFormat:@"%ds", totalTimeSeconds];
    
    self.totalMobActionValueLabel.text = [NSString stringWithFormat:@"%@", totalTimeString];
    self.pointsToNextLevelLabel.text = [NSString stringWithFormat:@"%d", pointsToNextLevel];
    self.levelLabel.text = [NSString stringWithFormat:@"%d", [subMobLevel intValue]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

// One method handles all category button presses here, and reacts depending on the current mode
- (IBAction)subMobButtonHit:(id)sender {
    [self hideTutorial:0];
    [self hideTutorial:1];
    
    if (sender == self.subMobSwitchButton) {
        NSLog(@"All button hit");
        
        if (self.displayMode == kCaremobDisplayModeReadyToJoin || self.displayMode == kCaremobDisplayModeNoCategory) {
            // Show the category buttons
            for (int i = 0; i < self.subMobButtons.count; i++) {
                UIButton *b = (UIButton*)self.subMobButtons[i];
                UILabel *subMobTotalMobActionsLabel = (UILabel*)self.subMobButtonsTotalMobActionsLabels[i];
                UILabel *subMobTotalMobActionValueLabel = (UILabel*)self.subMobButtonsTotalMobActionValueLabels[i];
                UIImageView *subMobTotalMobActionsIcon = (UIImageView*)self.subMobButtonsTotalMobActionsIconImageViews[i];
                UIImageView *subMobTotalMobActionValueIcon = (UIImageView*)self.subMobButtonsTotalMobActionValueIconImageViews[i];
                
                CGPoint p = [self.categoryButtonInitialCenters[[NSString stringWithFormat:@"%d",i]] CGPointValue];
                b.enabled = YES;
                
                [UIView animateWithDuration:0.2 delay:0.05 * (float)i options:UIViewAnimationOptionCurveLinear animations:^{
                    subMobTotalMobActionsLabel.alpha = 1;
                    subMobTotalMobActionValueLabel.alpha = 1;
                    subMobTotalMobActionsIcon.alpha = 1;
                    subMobTotalMobActionValueIcon.alpha = 1;
                    
                    b.alpha = 1;
                    b.center = p;
                    b.transform = CGAffineTransformMakeScale(1, 1);
                } completion:^(BOOL finished) {
                    // Do nothing
                }];
            }
            
            // Hide the join button and the stats
            self.subMobJoinButton.enabled = NO;
            CGPoint newAllCenter = [self.categoryButtonInitialCenters[@"join"] CGPointValue];
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.subMobJoinButton.alpha = 0;
                self.subMobStatsView.alpha = 0;
                
                CGRect joinInitial = [(NSValue*)self.categoryButtonInitialFrames[@"join"] CGRectValue];
                CGRect allInitial = [(NSValue*)self.categoryButtonInitialFrames[@"all"] CGRectValue];
                
                float xScale = joinInitial.size.width / allInitial.size.width;
                float yScale = joinInitial.size.height / allInitial.size.height;
                
                self.subMobSwitchButton.center = newAllCenter;
                self.subMobSwitchButton.transform = CGAffineTransformMakeScale(xScale, yScale);
                
            } completion:^(BOOL finished) {
                // Do nothing
            }];
            
            self.displayMode = kCaremobDisplayModeWaitingForCategorySelect;
        } else {
            if (self.selectedSubMob != nil) {
                // Hide everything and reset
                // Hide the category buttons
                for (int i = 0; i < self.subMobButtons.count; i++) {
                    UIButton *b = (UIButton*)self.subMobButtons[i];
                    UILabel *subMobTotalMobActionsLabel = (UILabel*)self.subMobButtonsTotalMobActionsLabels[i];
                    UILabel *subMobTotalMobActionValueLabel = (UILabel*)self.subMobButtonsTotalMobActionValueLabels[i];
                    UIImageView *subMobTotalMobActionsIcon = (UIImageView*)self.subMobButtonsTotalMobActionsIconImageViews[i];
                    UIImageView *subMobTotalMobActionValueIcon = (UIImageView*)self.subMobButtonsTotalMobActionValueIconImageViews[i];
                    
                    CGPoint p = [self.categoryButtonInitialCenters[@"join"] CGPointValue];
                    b.enabled = YES;
                    
                    [UIView animateWithDuration:0.2 delay:0.05 * (float)i options:UIViewAnimationOptionCurveLinear animations:^{
                        subMobTotalMobActionsLabel.alpha = 0;
                        subMobTotalMobActionValueLabel.alpha = 0;
                        subMobTotalMobActionValueIcon.alpha = 0;
                        subMobTotalMobActionsIcon.alpha = 0;
                        
                        b.alpha = 0;
                        b.center = p;
                        b.transform = CGAffineTransformMakeScale(1, 1);
                    } completion:^(BOOL finished) {
                        // Do nothing

                    }];
                }
                
                // Show the join button and the stats (if we have a selected submob)
                self.subMobJoinButton.enabled = YES;
                CGPoint newAllCenter = [self.categoryButtonInitialCenters[@"all"] CGPointValue];

                [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                    self.subMobJoinButton.alpha = 1;
                    if (self.selectedSubMob != nil) self.subMobStatsView.alpha = 1;
                    else self.subMobStatsView.alpha = 0;
                    
                    self.subMobSwitchButton.center = newAllCenter;
                    self.subMobSwitchButton.transform = CGAffineTransformMakeScale(1, 1);
                    
                    
                } completion:^(BOOL finished) {
                    // Do nothing
                }];
                
                self.displayMode = kCaremobDisplayModeReadyToJoin;
            }
        }
    } else if (sender == self.subMobJoinButton) {
        NSLog(@"Join button hit");
        
        if (self.selectedSubMob != nil) {
            
            // Set the status image background
            NSString *selectedSubMobCategory = [self.selectedSubMob objectForKey:kSubMobCategoryKey];
            self.categoryMobActionStatusBGImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"caremob_category_icon_%@", selectedSubMobCategory]];
            
            // Set the spinner layers
            for (int i = 0; i < self.mobActionActivitySpinnerImageViews.count; i++) {
                UIImageView *img = (UIImageView*)self.mobActionActivitySpinnerImageViews[i];
                img.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_hold_%d", selectedSubMobCategory, i]];
            }
            
            // Update progress spinner colors
            float br = 0.0;
            float bg = 0.0;
            float bb = 0.0;
            float fr = 0.0;
            float fg = 0.0;
            float fb = 0.0;
            
            if ([selectedSubMobCategory isEqualToString:@"empathy"]) {
                br = 14.0       /255.0;
                bg = 78.0      /255.0;
                bb = 122.0       /255.0;
                fr = 53.0       /255.0;
                fg = 135.0      /255.0;
                fb = 192.0       /255.0;
            } else if ([selectedSubMobCategory isEqualToString:@"support"]) {                
                br = 55.0       /255.0;
                bg = 103.0      /255.0;
                bb = 2.0       /255.0;
                fr = 100.0       /255.0;
                fg = 187.0      /255.0;
                fb = 0.0       /255.0;
            }  else if ([selectedSubMobCategory isEqualToString:@"mourning"]) {
                br = 105.0       /255.0;
                bg = 2.0        /255.0;
                bb = 125.0      /255.0;
                fr = 189.0      /255.0;
                fg = 16.0       /255.0;
                fb = 224.0      /255.0;
            } else if ([selectedSubMobCategory isEqualToString:@"peace"]) {
                br = 16.0        /255.0;
                bg = 118.0      /255.0;
                bb = 95.0      /255.0;
                fr = 61.0       /255.0;
                fg = 200.0      /255.0;
                fb = 169.0      /255.0;
            } else if ([selectedSubMobCategory isEqualToString:@"celebration"]) {
                br = 145.0      /255.0;
                bg = 93.0      /255.0;
                bb = 5.0       /255.0;
                fr = 245.0      /255.0;
                fg = 166.0      /255.0;
                fb = 35.0       /255.0;
            } else if ([selectedSubMobCategory isEqualToString:@"protest"]) {
                br = 105.0      /255.0;
                bg = 1.0        /255.0;
                bb = 14.0       /255.0;
                fr = 208.0      /255.0;
                fg = 2.0        /255.0;
                fb = 27.0       /255.0;
            }

            self.mobActionProgressCircleView.unfillColor = [UIColor colorWithRed:br green:bg blue:bb alpha:1.0];
            self.mobActionProgressCircleView.fillColor = [UIColor colorWithRed:fr green:fg blue:fb alpha:1.0];
            self.mobActionProgressCircleView.percentage = self.mobActionProgressCircleView.percentage;
            
            // Hide the select view and show the doAction view
            [self showCategorySelectView:NO];
            [self showDoActionView:YES];
            
            // And show the user image
            [UIView animateWithDuration:1.0f animations:^{
                self.userImageView.alpha = 1;
                self.userBackgroundImageView.alpha = 1;
                
                // CHANGED: we only show this on thumb down now
                //self.mobActionTotalTimeIcon.alpha = 1;
                //self.mobActionTotalTimeLabel.alpha = 1;
                self.mobActionPointsIcon.alpha = 1;
                self.mobActionPointsLabel.alpha = 1;
                
                self.timeToNextPointProgressBGImageView.alpha = 1;
                self.timeToNextPointProgressFillImageView.alpha = 1;
                self.timeToNextPointProgressIndicator.alpha = 1;
            }];
        }
    } else {
        int index = -1;
        for (int i = 0; i < self.subMobButtons.count; i++) {
            if (sender == self.subMobButtons[i]) {
                index = i;
                break;
            }
        }
        
        if (index >= 0) {
        
            // Update the join button and set the selected index
            [self updateSelectedSubMob:index];
            
            //NSString *selectedSubMobCategory = [self.selectedSubMob objectForKey:kSubMobCategoryKey];
            //[self.subMobJoinButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"caremob_category_icon_%@", selectedSubMobCategory]] forState:UIControlStateNormal];
            
            // Show the join button and hide the category buttons
            for (int i = 0; i < self.subMobButtons.count; i++) {
                UIButton *b = (UIButton*)self.subMobButtons[i];
                UILabel *subMobTotalMobActionsLabel = (UILabel*)self.subMobButtonsTotalMobActionsLabels[i];
                UILabel *subMobTotalMobActionValueLabel = (UILabel*)self.subMobButtonsTotalMobActionValueLabels[i];
                UIImageView *subMobTotalMobActionsIcon = (UIImageView*)self.subMobButtonsTotalMobActionsIconImageViews[i];
                UIImageView *subMobTotalMobActionValueIcon = (UIImageView*)self.subMobButtonsTotalMobActionValueIconImageViews[i];
                
                CGPoint p = [self.categoryButtonInitialCenters[@"join"] CGPointValue];
                b.enabled = YES;
                
                [UIView animateWithDuration:0.2 delay:0.05 * (float)i options:UIViewAnimationOptionCurveLinear animations:^{
                    subMobTotalMobActionsLabel.alpha = 0;
                    subMobTotalMobActionValueLabel.alpha = 0;
                    subMobTotalMobActionsIcon.alpha = 0;
                    subMobTotalMobActionValueIcon.alpha = 0;
                    
                    b.alpha = 0;
                    b.center = p;
                    b.transform = CGAffineTransformMakeScale(1, 1);
                } completion:^(BOOL finished) {
                    // Do nothing
                    
                }];
            }
            
            
            
            
            // Show the join button and the stats (if we have a selected submob)
            self.subMobJoinButton.enabled = YES;
            CGPoint newAllCenter = [self.categoryButtonInitialCenters[@"all"] CGPointValue];
            
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.subMobJoinButton.alpha = 1;
                if (self.selectedSubMob != nil) self.subMobStatsView.alpha = 1;
                else self.subMobStatsView.alpha = 0;
                
                self.subMobSwitchButton.center = newAllCenter;
                self.subMobSwitchButton.transform = CGAffineTransformMakeScale(1, 1);
                
                
            } completion:^(BOOL finished) {
                // Do nothing
            }];
            
            self.displayMode = kCaremobDisplayModeReadyToJoin;

        }
    }
}

- (IBAction)shareButtonHit:(id)sender {
    if (self.activeMobAction != nil) [self performSegueWithIdentifier:@"showSocialShareViewController" sender:self];
}

- (IBAction)userListTopMobbersButtonHit:(id)sender {
    self.selectedCaremobUserListMode = kCaremobUserListTableModeTopMobbers;
    [self performSegueWithIdentifier:@"showCaremobUserListViewController" sender:self];
}

- (IBAction)userListFirstMobbersButtonHit:(id)sender {
    self.selectedCaremobUserListMode = kCaremobUserListTableModeFirstMobbers;
    [self performSegueWithIdentifier:@"showCaremobUserListViewController" sender:self];
}

- (IBAction)userListNearbyMobbersButtonHit:(id)sender {
    self.selectedCaremobUserListMode = kCaremobUserListTableModeNearbyMobbers;
    [self performSegueWithIdentifier:@"showCaremobUserListViewController" sender:self];

}


-(void)updateMobActionDisplay {
    // Get the curent points, and previous and next time goal posts
    if (self.activeMobAction) {
        NSNumber *timeNumber = (NSNumber*)[self.activeMobAction objectForKey:kMobActionValueKey];
        double time = [timeNumber doubleValue];
        
        if (self.pressStartTime != nil) {
            double timeSincePressed = [[NSDate date] timeIntervalSinceDate:self.pressStartTime];
            time += timeSincePressed;
            
        }
        
        /*
        int timeSeconds = (int)floor(time);
        
        self.mobActionTotalTimeLabel.text = [NSString stringWithFormat:@"%ds", timeSeconds];
        */
        
        self.mobActionTotalTimeLabel.text = [CareMobHelper timeToString:time];
        
        int points = [CareMobHelper calculateMobActionPointsForTime:time];
        
        self.mobActionPointsLabel.text = [NSString stringWithFormat:@"%dpts", points];
        
        double lastTimeGoal;
        double nextTimeGoal;
        
        if (points < 0) lastTimeGoal = 0.0;
        else lastTimeGoal = [CareMobHelper calculateMobActionTimeToPoints:points];
        
        nextTimeGoal = [CareMobHelper calculateMobActionTimeToPoints:points + 1];
        
        double timeToNextGoal = nextTimeGoal - time;
        int timeToNextGoalSeconds = (int)floor(timeToNextGoal);
        
        self.mobActionTimeToNextPointsLabel.text = [NSString stringWithFormat:@"-%ds", timeToNextGoalSeconds];
        
        float percent = (float)(time - lastTimeGoal) / (float)(nextTimeGoal - lastTimeGoal);
        
        // REMOVED now used for subMobProgress
        //self.mobActionProgressCircleView.percentage = percent;
        
        // TODO update time to next level with this percent
        NSString *category = (NSString*)[self.selectedSubMob objectForKey:kSubMobCategoryKey];
        
        self.timeToNextPointProgressFillImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"caremob_category_level_progress_fill_%@", category]];
        self.timeToNextPointProgressBGImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"caremob_category_level_progress_bg_%@", category]];
        
        
        CGRect frame = self.timeToNextPointProgressFillImageView.frame;
        /*
        frame = CGRectMake(frame.origin.x, frame.origin.y, percent * self.timeToNextPointProgressBarWidth, frame.size.height);
        [self.timeToNextPointProgressFillImageView setFrame:frame];
        
        NSLog(@"Percent: %f", percent);
        NSLog(@"frame: %f, %f, %f, %f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
        */
        
        double placement = percent * frame.size.width;
        
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        CGRect maskRect = CGRectMake(0, 0, placement, frame.size.height);
        
        // Create a path with the rectangle in it.
        CGPathRef path = CGPathCreateWithRect(maskRect, NULL);
        
        // Set the path to the mask layer.
        maskLayer.path = path;
        
        // Release the path since it's not covered by ARC.
        CGPathRelease(path);
        
        // Set the mask of the view.
        self.timeToNextPointProgressFillImageView.layer.mask = maskLayer;
        
        //self.timeToNextPointProgressIndicator.center = CGPointMake(self.timeToNextPointProgressFillImageView.frame.origin.x + placement, self.timeToNextPointProgressFillImageView.center.y);
        self.timeToNextPointProgressIndicatorHorizontalSpacingConstraint.constant = placement - 6;
        [self.timeToNextPointProgressIndicator needsUpdateConstraints];
        
        if (self.pressStartTime != nil) {
            // Update the submob stats since we have some new values
            self.newTimeEarned = [[NSDate date] timeIntervalSinceDate:self.pressStartTime];
            NSNumber *savedPoints = (NSNumber*)[self.activeMobAction objectForKey:kMobActionPointsKey];
            NSNumber *savedTime = (NSNumber*)[self.activeMobAction objectForKey:kMobActionValueKey];
            int currentPoints = [CareMobHelper calculateMobActionPointsForTime:[savedTime doubleValue] + self.newTimeEarned];
            self.newPointsEarned = currentPoints - [savedPoints intValue];
            [self updateSelectedSubMobStats];

            [self performSelector:@selector(updateMobActionDisplay) withObject:nil afterDelay:0.1];
                    //NSLog(@"Updating display");
            
            //if (self.newPointsEarned > 0 && timeToNextGoalSeconds == 0) [self showMobGainedLevelStencil:NO andUserGainedPoint:YES];
        }
        

    }
}

-(void)refreshSelectedSubMob {
    // Don't run this if we have lifted our finger
    if (self.pressStartTime == nil) return;
    
    [self.selectedSubMob fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (error) {
            
        } else {
            self.selectedSubMob = (PFObject*)object;
        }
        
        [self performSelector:@selector(refreshSelectedSubMob) withObject:nil afterDelay:15.0];
    }];
}

-(void)updateMobActionFootprintPins {
    PFQuery *mobActionFootprintQuery = [PFQuery queryWithClassName:kMobActionFootprintClassKey];
    [mobActionFootprintQuery includeKey:kMobActionFootprintUserKey];
    [mobActionFootprintQuery whereKey:kMobActionFootprintSubMobKey equalTo:self.selectedSubMob];
    [mobActionFootprintQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
         
        } else {
            // Parse the array and add MobActionUsers that aren't the current user
            NSMutableArray *mobActionFootprints = [[NSMutableArray alloc] init];
            PFObject *currentUser = (PFObject*)[PFUser currentUser];
            
            for (int i = 0; i < objects.count; i++) {
                PFObject *thisMobActionFootprint = (PFObject*)objects[i];
                PFObject *thisMobActionFootprintUser = (PFObject*)[thisMobActionFootprint objectForKey:kMobActionFootprintUserKey];
                
                if (![thisMobActionFootprintUser.objectId isEqualToString:currentUser.objectId]) [mobActionFootprints addObject:thisMobActionFootprint];
            }
            
            [self.heatmapViewController showUserPinsForMobActionFootprints:mobActionFootprints];
        }
    }];
    
    if (self.pressStartTime != nil) {
        [self performSelector:@selector(updateMobActionFootprintPins) withObject:nil afterDelay:5.0];
    }
}

-(void)updateMobActionRank {
    if (self.activeMobAction == nil) return;
    
    PFQuery *mobActionRankCountQuery = [PFQuery queryWithClassName:kMobActionClassKey];
    [mobActionRankCountQuery whereKey:kMobActionCareMobKey equalTo:[self.activeMobAction objectForKey:kMobActionCareMobKey]];
    [mobActionRankCountQuery whereKey:kMobActionSubMobKey equalTo:[self.activeMobAction objectForKey:kMobActionSubMobKey]];
    [mobActionRankCountQuery whereKey:kMobActionValueKey greaterThan:[self.activeMobAction objectForKey:kMobActionValueKey]];
    [mobActionRankCountQuery countObjectsInBackgroundWithBlock:^(int number, NSError * _Nullable error) {
        if (error) {
            // Do nothing
        } else {
            // number is the number of mob actions with a higher rank.  So our rank is number + 1
            self.mobActionRankLabel.text = [NSString stringWithFormat:@"Rank %d", (number + 1)];
            
            // Only fade in this label if the user hasn't pressed their finger down again
            if (self.pressStartTime == nil) {
                [UIView animateWithDuration:0.5 animations:^{
                    self.mobActionRankLabel.alpha = 1;
                } completion:^(BOOL finished) {
                    // Do nothing
                }];
            }
        }
    }];
}

#pragma mark - Common UI Animations
-(void)showSpinner:(BOOL)show {
    if (show) {
        CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeAnim.fromValue = [NSNumber numberWithFloat:0.0];
        fadeAnim.toValue = [NSNumber numberWithFloat:1.0];
        fadeAnim.duration = 0.5;
    
        for (int i = 0; i < self.mobActionActivitySpinnerImageViews.count; i++) {
            UIImageView *img = (UIImageView*)self.mobActionActivitySpinnerImageViews[i];
        
            if (i == 0) img.layer.opacity = 1.0;
            else {
                [img.layer addAnimation:fadeAnim forKey:@"opacity"];
                img.layer.opacity = 1.0;
            }
        }
    } else {
        CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeAnim.fromValue = [NSNumber numberWithFloat:1.0];
        fadeAnim.toValue = [NSNumber numberWithFloat:0.0];
        fadeAnim.duration = 0.5;
        
        for (int i = 0; i < self.mobActionActivitySpinnerImageViews.count; i++) {
            UIImageView *img = (UIImageView*)self.mobActionActivitySpinnerImageViews[i];
            
            if (i == 0) img.layer.opacity = 0.5;
            else {
                [img.layer addAnimation:fadeAnim forKey:@"opacity"];
                img.layer.opacity = 0.0;
            }
        }
    }
}

-(void)showHeatmap:(BOOL)show {
    if (show) {
        CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeAnim.fromValue = [NSNumber numberWithFloat:0.0];
        fadeAnim.toValue = [NSNumber numberWithFloat:1.0];
        fadeAnim.duration = 0.5;
        
        [self.heatmapContainerView.layer addAnimation:fadeAnim forKey:@"opacity"];
        
        self.heatmapContainerView.layer.opacity = 1.0;
    } else {
        CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
        fadeAnim.fromValue = [NSNumber numberWithFloat:1.0];
        fadeAnim.toValue = [NSNumber numberWithFloat:0.0];
        fadeAnim.duration = 0.5;
        
        [self.heatmapContainerView.layer addAnimation:fadeAnim forKey:@"opacity"];
        
        self.heatmapContainerView.layer.opacity = 0.0;
    }
}


-(void)animateSpinners {
    // Start the spinners animating (except for 0 which is solid circle)
    CABasicAnimation *halfTurn_1;
    halfTurn_1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    halfTurn_1.fromValue = [NSNumber numberWithFloat:0];
    halfTurn_1.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
    halfTurn_1.duration = 2.5;
    halfTurn_1.repeatCount = HUGE_VALF;
    
    UIImageView *spinner1 = (UIImageView*)self.mobActionActivitySpinnerImageViews[1];
    [[spinner1 layer] addAnimation:halfTurn_1 forKey:@"180_1"];
    
    CABasicAnimation *halfTurnReverse_2;
    halfTurnReverse_2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    halfTurnReverse_2.fromValue = [NSNumber numberWithFloat:0];
    halfTurnReverse_2.toValue = [NSNumber numberWithFloat:(-(360*M_PI)/180)];
    halfTurnReverse_2.duration = 2.5;
    halfTurnReverse_2.repeatCount = HUGE_VALF;
    
    UIImageView *spinner2 = (UIImageView*)self.mobActionActivitySpinnerImageViews[2];
    [[spinner2 layer] addAnimation:halfTurnReverse_2 forKey:@"180r_2"];
    
    CABasicAnimation *halfTurn_3;
    halfTurn_3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    halfTurn_3.fromValue = [NSNumber numberWithFloat:0];
    halfTurn_3.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
    halfTurn_3.duration = 2.0;
    halfTurn_3.repeatCount = HUGE_VALF;
    
    UIImageView *spinner3 = (UIImageView*)self.mobActionActivitySpinnerImageViews[3];
    [[spinner3 layer] addAnimation:halfTurn_3 forKey:@"180_3"];
    
    CABasicAnimation *halfTurnReverse_4;
    halfTurnReverse_4 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    halfTurnReverse_4.fromValue = [NSNumber numberWithFloat:0];
    halfTurnReverse_4.toValue = [NSNumber numberWithFloat:(-(360*M_PI)/180)];
    halfTurnReverse_4.duration = 2.0;
    halfTurnReverse_4.repeatCount = HUGE_VALF;
    
    UIImageView *spinner4 = (UIImageView*)self.mobActionActivitySpinnerImageViews[4];
    [[spinner4 layer] addAnimation:halfTurnReverse_4 forKey:@"180r_4"];
}

-(void)showCategorySelectView:(BOOL)show {
    if (show) {
        // Hide the category select view
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.subMobSelectorView.alpha = 1;
        } completion:^(BOOL finished) {
            // Do nothing
        }];
    } else {
        // Hide the category select view
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.subMobSelectorView.alpha = 0;
        } completion:^(BOOL finished) {
            // Do nothing
        }];
    }
}

-(void)showDoActionView:(BOOL)show {
    if (show) {
        [self updateMobActionDisplay];
        
        // Show the doAction view
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.doActionView.alpha = 1;
        } completion:^(BOOL finished) {
            // Do nothing
        }];
    } else {
        // Hide the doAction view
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.doActionView.alpha = 0;
        } completion:^(BOOL finished) {
            // Do nothing
        }];
    }
}

#pragma mark - Action Button
- (IBAction)mobActionButtonTouchDown:(id)sender {
    [self hideTutorial:2];
    [self markTutorialsRead];
    
    [[Sound soundNamed:kSoundThumbDown] play];
    
    [self showSpinner:YES];
    [self showHeatmap:YES];
    
    self.pressStartTime = [NSDate date];
    
    self.newTimeEarned = 0.0;
    self.newPointsEarned = 0.0;
    
    //[self.mobActionButton setBackgroundImage:[UIImage imageNamed:@"thumb_print_button_pressed"] forState:UIControlStateNormal];
    [self.mobActionButton setImage:[UIImage imageNamed:@"thumb_print_button_pressed"] forState:UIControlStateNormal];
    
    // Hide the afterActionView if it is showing
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.afterActionView.alpha = 0;
    } completion:^(BOOL finished) {
        // Do nothing
    }];
    
    // Start the loop updating the display
    [self updateMobActionDisplay];
    
    // Start the loop refreshing the submob stats
    [self performSelector:@selector(refreshSelectedSubMob) withObject:nil afterDelay:15.0];
    
    // Start the loop updating the user pins in the heatmap
    [self updateMobActionFootprintPins];
    
    //[self showWhatChangedNotification];
    
    // Since we don't update the MobAction until the finger is raised, we create a MobActionFootprint here to let Parse know we are in
    PFObject *mobActionFootprint = [PFObject objectWithClassName:kMobActionFootprintClassKey];
    
    // Before we save this MobActionFootprint, let's try to get the location of the user
    CLLocation *location = self.locationManager.location;
    if (location == nil) {
        NSLog(@"location is nil");
    } else {
        CLLocationCoordinate2D coordinate = [location coordinate];
        NSLog(@"location is %f %f",coordinate.latitude, coordinate.longitude);
        PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        [mobActionFootprint setObject:geoPoint forKey:kMobActionFootprintLocationKey];

        // Set the user on the heatmap
        [self.heatmapViewController addUserPin:(PFObject*)[PFUser currentUser] atLatitude:coordinate.latitude andLongitude:coordinate.longitude isCurrentUser:YES];
    }

    [mobActionFootprint setObject:self.careMob forKey:kMobActionFootprintCareMobKey];
    [mobActionFootprint setObject:self.selectedSubMob forKey:kMobActionFootprintSubMobKey];
    [mobActionFootprint setObject:[PFUser currentUser] forKey:kMobActionFootprintUserKey];
    [mobActionFootprint saveEventually];
    
    // Show the user stats and hide the global stats
    [UIView animateWithDuration:0.5 animations:^{
        self.totalMobActionsIconImageView.alpha = 0;
        self.totalMobActionsLabel.alpha = 0;

        self.mobActionRankLabel.alpha = 0;
        
        self.totalMobActionValueIconImageView.alpha = 1;
        self.totalMobActionValueLabel.alpha = 1;
        
        self.mobActionTotalTimeIcon.alpha = 1;
        self.mobActionTotalTimeLabel.alpha = 1;


    } completion:^(BOOL finished) {
        // Do nothing
    }];
}

- (IBAction)mobActionButtonTouchUpInside:(id)sender {
    [[Sound soundNamed:kSoundThumbUp] play];
    
    [self showSpinner:NO];
    [self showHeatmap:NO];
    
    [self.heatmapViewController removeCurrentUserPin];

    // Cancel the scheduled selector calls
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateMobActionDisplay) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshSelectedSubMob) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateMobActionFootprintPins) object:nil];
    
    //[self.mobActionButton setBackgroundImage:[UIImage imageNamed:@"thumb_print_button_unpressed"] forState:UIControlStateNormal];
    [self.mobActionButton setImage:[UIImage imageNamed:@"thumb_print_button_unpressed"] forState:UIControlStateNormal];
    
    //[self showCategorySelectView:YES];
    //[self showDoActionView:NO];

    NSTimeInterval timeHeld = [[NSDate date] timeIntervalSinceDate:self.pressStartTime];
    NSLog(@"Time held: %f", timeHeld);
    
    // Add time to the current active mob action
    NSNumber *currentTime = (NSNumber*)[self.activeMobAction objectForKey:kMobActionValueKey];
    double time = [currentTime doubleValue];
    time += timeHeld;
    
    // Do one last update of the stats before we save and refetch everything
    self.newTimeEarned = [[NSDate date] timeIntervalSinceDate:self.pressStartTime];
    NSNumber *points = (NSNumber*)[self.activeMobAction objectForKey:kMobActionPointsKey];
    NSNumber *savedTime = (NSNumber*)[self.activeMobAction objectForKey:kMobActionValueKey];
    int currentPoints = [CareMobHelper calculateMobActionPointsForTime:[savedTime doubleValue] + self.newTimeEarned];
    self.newPointsEarned = currentPoints - [points intValue];
    [self updateSelectedSubMobStats];

    self.newPointsEarned = 0;
    self.newTimeEarned = 0.0;
    
    // Before we save this mob action, let's try to get the location of the user
    CLLocation *location = self.locationManager.location;
    if (location == nil) {
        NSLog(@"location is nil");
    } else {
        CLLocationCoordinate2D coordinate = [location coordinate];
        NSLog(@"location is %f %f",coordinate.latitude, coordinate.longitude);
        PFGeoPoint *geoPoint = [PFGeoPoint geoPointWithLatitude:coordinate.latitude longitude:coordinate.longitude];
        [self.activeMobAction setObject:geoPoint forKey:kMobActionLocationKey];
    }
    
    // Set the following user if we have one and haven't already set it
    if (self.followingUser != nil && [self.activeMobAction objectForKey:kMobActionFollowingUserKey] == nil) [self.activeMobAction setObject:self.followingUser forKey:kMobActionFollowingUserKey];
    
    [self.activeMobAction setObject:[NSNumber numberWithDouble:time] forKey:kMobActionValueKey];
    [self.activeMobAction saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            
        } else {
            // Post a notification that an action was performed
            // This notification should be received by the UserLevelControlView if one is active, causing it to refresh the uer and show the new user level and points
            NSLog(@"Posting notification");
            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationMobActionWasPerformed object:nil];
            
            // Reload the selected submob
            [self.selectedSubMob fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (error) {
                    
                } else {
                    //self.selectedSubMob = (PFObject*)object;
                    [self updateSelectedSubMobStats];
                    [self updateMobActionRank];
                }
            }
             
             ];
        }
    }];
    
    self.pressStartTime = nil;
    
    // Now, if the mobaction has time in it, we can turn on the share button
    NSNumber *mobActionValue = (NSNumber*)[self.activeMobAction objectForKey:kMobActionValueKey];
    if ([mobActionValue floatValue] > 0.0) {
        self.shareButton.hidden = NO;
        self.shareButtonAnimatedImageView.hidden = NO;
        self.shareButton.enabled = YES;

        [self.shareButtonAnimatedImageView startAnimating];
        
        // And show the afterActionView
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.afterActionView.alpha = 1;
        } completion:^(BOOL finished) {
            // Do nothing

        }];

    } else {
        self.shareButton.hidden = YES;
        self.shareButtonAnimatedImageView.hidden = YES;
        self.shareButton.enabled = NO;
        
        // And hide the afterActionView
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
            self.afterActionView.alpha = 0;
        } completion:^(BOOL finished) {
            // Do nothing
        }];

    }
    
    [self updateMobActionDisplay];
 
    // Hide the user stats and show the global stats
    [UIView animateWithDuration:0.5 animations:^{
        self.totalMobActionsIconImageView.alpha = 1;
        self.totalMobActionsLabel.alpha = 1;
        
        // NOTE: mob action rank label is reshown after retrieval from Parse (in [self updateMobActionRank])
        // This happens after the mobAction is saved (see above, saveInBackgroundWithBlock call)
        
        self.totalMobActionValueIconImageView.alpha = 0;
        self.totalMobActionValueLabel.alpha = 0;

        self.mobActionTotalTimeIcon.alpha = 0;
        self.mobActionTotalTimeLabel.alpha = 0;

    } completion:^(BOOL finished) {
        // Do nothing
    }];

}

- (IBAction)mobActionButtonTouchUpOutside:(id)sender {
    // Redirect to touch up inside
    [self mobActionButtonTouchUpInside:sender];
}

-(void)showWhatChangedNotification {
    NSString *notificationText = @"Stuff changed";
    NSString *notificationCategoryContext = self.categoryContext;
    UIColor *notificationBGColor;
    UIImage *notificationImage;
    
    
    notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"caremob_category_small_%@", notificationCategoryContext]];
    
    if (notificationCategoryContext == nil) {
        notificationBGColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    } else if ([notificationCategoryContext isEqualToString:@"celebration"]) {
        notificationBGColor = [UIColor colorWithRed:168.0/255.0 green:112.0/255.0 blue:19.0/255.0 alpha:1.0];
    }  else if ([notificationCategoryContext isEqualToString:@"support"]) {
        notificationBGColor = [UIColor colorWithRed:54.0/255.0 green:102.0/255.0 blue:0.0/255.0 alpha:1.0];
    } else if ([notificationCategoryContext isEqualToString:@"mourning"]) {
        notificationBGColor = [UIColor colorWithRed:98.0/255.0 green:5.0/255.0 blue:117.0/255.0 alpha:1.0];
    } else if ([notificationCategoryContext isEqualToString:@"peace"]) {
        notificationBGColor = [UIColor colorWithRed:0.0/255.0 green:159.0/255.0 blue:123.0/255.0 alpha:1.0];
    } else if ([notificationCategoryContext isEqualToString:@"protest"]) {
        notificationBGColor = [UIColor colorWithRed:133.0/255.0 green:0.0/255.0 blue:16.0/255.0 alpha:1.0];
    } else if ([notificationCategoryContext isEqualToString:@"empathy"]) {
        notificationBGColor = [UIColor colorWithRed:26.0/255.0 green:102.0/255.0 blue:118.0/255.0 alpha:1.0];
    } else {
        notificationBGColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    }
    
    NSDictionary *options = @{
                              kCRToastTextKey : notificationText,
                              kCRToastTextAlignmentKey : @(NSTextAlignmentLeft),
                              kCRToastBackgroundColorKey : notificationBGColor,
                              kCRToastFontKey : [UIFont fontWithName:@"NettoOT" size:16.0],
                              kCRToastTextColorKey : [UIColor whiteColor],
                              kCRToastImageKey : notificationImage,
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
                              kCRToastTimeIntervalKey : @(5.0),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastNotificationTypeKey: @(CRToastTypeNavigationBar)
                              };
    
    [CRToastManager showNotificationWithOptions:options completionBlock:^{
        NSLog(@"Showed notification");
    }];

}

-(void)showTutorial:(int)tutorial {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:kNSUserDefaultsTutorialWasShown] == YES) {
        NSLog(@"Tutorial was already shown");
        return;
    }
    
    if (tutorial == 0) {
        self.tutorial0ImageView.hidden = NO;
    } else if (tutorial == 1) {
        self.tutorial1ImageView.hidden = NO;
    } else {
        self.tutorial2ImageView.hidden = NO;
    }
    
}

-(void)hideTutorial:(int)tutorial {
    if (tutorial == 0) {
        self.tutorial0ImageView.hidden = YES;
    } else if (tutorial == 1) {
        self.tutorial1ImageView.hidden = YES;
    } else {
        self.tutorial2ImageView.hidden = YES;
    }
}

-(void)markTutorialsRead {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:kNSUserDefaultsTutorialWasShown];
    [defaults synchronize];
}

#pragma mark - CLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    /*
     CLLocation* loc = [locations lastObject]; // locations is guaranteed to have at least one object
     float latitude = loc.coordinate.latitude;
     float longitude = loc.coordinate.longitude;
     NSLog(@"%.8f",latitude);
     NSLog(@"%.8f",longitude);
     */
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // The location "unknown" error simply means the manager is currently unable to get the location.
    // We can ignore this error for the scenario of getting a single location fix, because we already have a
    // timeout that will stop the location manager to save power.
    //if ([error code] != kCLErrorLocationUnknown) {
    NSLog(@"Error %@", [error localizedDescription]);
    //}
}

/*
-(void)showUserGainedPointStencil {
    
    self.userGainedPointStencil.alpha = 1;
    self.userGainedPointStencilSpacingConstraint.constant = 4;
    [self.view layoutIfNeeded];
    
    self.userGainedPointStencilSpacingConstraint.constant = 54;
    [UIView animateWithDuration:2.0 animations:^{
        [self.view layoutIfNeeded];
        self.userGainedPointStencil.alpha = 0;
    } completion:^(BOOL finished) {
        self.userGainedPointStencil.alpha = 0;
        self.userGainedPointStencilSpacingConstraint.constant = 4;
        [self.view layoutIfNeeded];
    }];
}
*/

-(void)showMobGainedLevelStencil:(BOOL)showMobGainedLevel andUserGainedPoint:(BOOL)showUserGainedPoint {

    if (showMobGainedLevel == YES) {
        self.mobGainedLevelStencil.alpha = 1;
        self.mobGainedLevelStencilSpacingConstraint.constant = 4;
    }
    
    if (showUserGainedPoint == YES) {
        self.userGainedPointStencil.alpha = 1;
        self.userGainedPointStencilSpacingConstraint.constant = 4;
    }
    
    [self.view layoutIfNeeded];
    
    if (showMobGainedLevel == YES) {
        self.mobGainedLevelStencilSpacingConstraint.constant = 54;
    }
    
    if (showUserGainedPoint == YES) {
        self.userGainedPointStencilSpacingConstraint.constant = 54;
    }
    
    [UIView animateWithDuration:2.0 animations:^{
        [self.view layoutIfNeeded];
        self.mobGainedLevelStencil.alpha = 0;
        self.userGainedPointStencil.alpha = 0;
    } completion:^(BOOL finished) {
        self.mobGainedLevelStencil.alpha = 0;
        self.mobGainedLevelStencilSpacingConstraint.constant = 4;
        self.userGainedPointStencilSpacingConstraint.constant = 4;
        [self.view layoutIfNeeded];
    }];

}
@end
