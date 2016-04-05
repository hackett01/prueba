//
//  PlayMomentViewController.m
//  Shyft
//
//  Created by Rick Strom on 11/20/14.
//  Copyright (c) 2014 Rick Strom. All rights reserved.
//

#import "PlayMomentViewController.h"

@interface PlayMomentViewController ()
@property (weak, nonatomic) IBOutlet UILabel *circleTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *momentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *momentNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UIButton *viewCircleButton;

@property (weak, nonatomic) IBOutlet UIImageView *momentImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *recordedMomentsCollectionView;
- (IBAction)playButtonHit:(id)sender;
- (IBAction)viewCircleButtonHit:(id)sender;

@end

@implementation PlayMomentViewController

/*
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Configure the navigation bar
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shyftLogoSmall"]];
    
    UIBarButtonItem *MyBackButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    //UIBarButtonItem *MyBackButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navBarBackButton"] landscapeImagePhone:[UIImage imageNamed:@"navBarBackButton"] style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    MyBackButton.title = @"BACK";
    
    NSDictionary *myBackButtonTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                [UIColor colorWithRed:146.0/255.0 green:146.0/255.0 blue:146.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                [UIFont fontWithName:@"NettoOT" size:16.0f], NSFontAttributeName,
                                                nil];
    [MyBackButton setTitleTextAttributes:myBackButtonTextAttributes forState:UIControlStateNormal];
    [MyBackButton setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.backBarButtonItem = MyBackButton;

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self presentMomentInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    if (audioPlayer != nil) {
        if (audioPlayer.isPlaying) [audioPlayer stop];
    }
}

-(void)back {
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showCircleInfoViewController"]) {
        CircleInfoViewController *destination = (CircleInfoViewController*)[segue destinationViewController];
        destination.circle = [self.moment objectForKey:kMomentOfSilenceFieldCircleKey];
    }
    
}


-(void)initializeWithTitle:(NSString*)title andTime:(NSString*)time andMoment:(PFObject*)moment {
    self.titleText = title;
    self.timeText = time;
    self.moment = moment;
}

-(void)presentMomentInfo {
    self.circleTitleLabel.text = self.titleText;
    self.momentTimeLabel.text = self.timeText;
    
    PFFile *momentImage = (PFFile*)[self.moment objectForKey:kMomentOfSilenceFieldImageKey];
    if ([momentImage isDataAvailable]) {
        self.momentImageView.image = [UIImage imageWithData:[momentImage getData]];
    } else {
        [momentImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (error) {
                
            } else {
                self.momentImageView.image = [UIImage imageWithData:data];
            }
        }];
    }
    
    PFObject *momentUser = [self.moment objectForKey:kMomentOfSilenceFieldUserKey];
    [momentUser fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (error) {

        } else {
            self.momentNameLabel.text = [NSString stringWithFormat:@"by %@",[momentUser objectForKey:kUserFieldNameKey]];
        }
    }];

    PFObject *momentCircle = [self.moment objectForKey:kMomentOfSilenceFieldCircleKey];
    [momentCircle fetchIfNeededInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (error) {
            
        } else {
            self.viewCircleButton.hidden = NO;
            self.viewCircleButton.enabled = YES;
        }
    }];
    
    [self loadRecordedMoments];
}

- (IBAction)playButtonHit:(id)sender {
    self.playButton.hidden = YES;
    self.playButton.enabled = NO;
    
    // Fetch the recording and play it
    PFFile *soundFile = (PFFile*)[self.moment objectForKey:kMomentOfSilenceFieldRecordingKey];
    if ([soundFile isDataAvailable]) {
        // Play data
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithData:[soundFile getData] error:&error];
        
        if (audioPlayer == nil)
            NSLog(@"%@",[error description]);
        else
            [audioPlayer play];
    } else [soundFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (error) {
            
        } else {
            // Play data
            NSError *error;
            audioPlayer = [[AVAudioPlayer alloc] initWithData:[soundFile getData] error:&error];
            
            if (audioPlayer == nil)
                NSLog(@"%@",[error description]);
            else
                [audioPlayer play];

        }
    }];
}

- (IBAction)viewCircleButtonHit:(id)sender {
    [self performSegueWithIdentifier:@"showCircleInfoViewController" sender:self];
}

-(void)loadRecordedMoments {
    if (self.moment == nil) return;
    
    NSLog(@"Grabbing recorded moments for %@", self.moment.objectId);
    
    PFQuery *query = [PFQuery queryWithClassName:kMomentOfSilenceClassKey];
    [query whereKey:kMomentOfSilenceFieldCircleKey equalTo:[self.moment objectForKey:kMomentOfSilenceFieldCircleKey]];
    [query orderByDescending:kMomentOfSilenceFieldCreatedAtKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error");
        } else {
            self.recordedMoments = [NSArray arrayWithArray:objects];
            //NSLog(@"Got %u moments", self.recordedMoments.count);
            [self.recordedMomentsCollectionView reloadData];
        }
    }];
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (self.recordedMoments == nil) return 0;
    else return self.recordedMoments.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecordedMomentCollectionViewCell *cell;
    
    //if (indexPath.item % 3 == 0 && NO)
    //    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CircleLargeCollectionViewCell" forIndexPath:indexPath];
    //else if (indexPath.item % 2 == 0 && NO)
    //    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CircleMediumCollectionViewCell" forIndexPath:indexPath];
    //else
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecordedMomentCollectionViewCell" forIndexPath:indexPath];
    
    [cell setRecordedMoment:self.recordedMoments[indexPath.item]];
    
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
    retval.height = 64;
    retval.width = 64;
    //}
    
    return retval;
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
*/
@end
