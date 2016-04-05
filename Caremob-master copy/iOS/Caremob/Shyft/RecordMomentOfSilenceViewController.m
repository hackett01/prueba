//
//  RecordMomentOfSilenceViewController.m
//  Shyft
//
//  Created by Rick Strom on 11/18/14.
//  Copyright (c) 2014 Rick Strom. All rights reserved.
//

#import "RecordMomentOfSilenceViewController.h"

@interface RecordMomentOfSilenceViewController ()
@property (weak, nonatomic) IBOutlet SCSiriWaveformView *waveformView;
@property (weak, nonatomic) IBOutlet UILabel *circleTitleLabel;
@property (weak, nonatomic) IBOutlet UIView *recordingStatusContainerView;
@property (weak, nonatomic) IBOutlet UILabel *recordingStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *circleImageView;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;
@property (weak, nonatomic) IBOutlet UILabel *recordTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel0;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel1;
@property (weak, nonatomic) IBOutlet UILabel *thankYouLabel0;
@property (weak, nonatomic) IBOutlet UILabel *thankYouLabel1;
@property (weak, nonatomic) IBOutlet UILabel *finalTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *finalTimeSublabel;
@property (weak, nonatomic) IBOutlet UILabel *finalTimeDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *instructionLabel0a;

@property (weak, nonatomic) IBOutlet UICollectionView *recordedMomentsCollectionView;
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

- (IBAction)recordButtonTouchDown:(id)sender;
- (IBAction)recordButtonTouchUpInside:(id)sender;
- (IBAction)recordButtonTouchUpOutside:(id)sender;

- (IBAction)closeButtonHit:(id)sender;

- (IBAction)bottomShareButtonHit:(id)sender;
- (IBAction)bottomCloseButtonHit:(id)sender;
- (IBAction)cameraButtonHit:(id)sender;

@end

@implementation RecordMomentOfSilenceViewController
/*
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.recordingPath = [NSString pathWithComponents:[NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], @"tempRecording.aac", nil]];

    NSURL *url = [NSURL fileURLWithPath:self.recordingPath];
    
    NSDictionary *settings = @{AVSampleRateKey:          [NSNumber numberWithFloat: 44100.0],
                               AVFormatIDKey:            [NSNumber numberWithInt: kAudioFormatMPEG4AAC],
                               AVNumberOfChannelsKey:    [NSNumber numberWithInt: 2],
                               AVEncoderAudioQualityKey: [NSNumber numberWithInt: AVAudioQualityMin]};
    
    NSError *error;
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
    if(error) {
        NSLog(@"Oops, could not create recorder %@", error);
        return;
    }
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    if (error) {
        NSLog(@"Error setting category: %@", [error description]);
    }
    
    [self.recorder prepareToRecord];
    [self.recorder setMeteringEnabled:YES];
    //[self.recorder record];
    
    CADisplayLink *displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateMeters)];
    [displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    
    [self.waveformView setWaveColor:[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:242.0/255.0 alpha:1.0f]];
    [self.waveformView setPrimaryWaveLineWidth:3.0f];
    [self.waveformView setSecondaryWaveLineWidth:1.0];
    
    isRecording = NO;
    self.recordingStatusLabel.text = @"";
    recordingTime = 0.0f;

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self presentCircleInfo];
    
    [self loadRecordedMoments];
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
    if ([segue.identifier isEqualToString:@"showShareViewController"]) {
        ShareViewController *destination = (ShareViewController*)[segue destinationViewController];
        
        // Grab the duration before we stop recording
        int minutes = (int)recordingTime/ 60;
        int seconds = (int)(recordingTime - minutes * 60);

        destination.shareMessageText = [NSString stringWithFormat:@"I just spent %02d:%02d in a Circle of Unity for \"%@\" via http://www.shyftsocial.com", minutes, seconds, [self.circle objectForKey:kCircleFieldTitleKey]];
        
        // Grab a screenshot to use in sharing
        //UIImage *screenshot = [self captureView:self.view];
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        UIImage *screenshot = [self captureScreenInRect:CGRectMake(0.0, 0.0, screenRect.size.width, screenRect.size.height - 70.0)];
        destination.shareImage = screenshot;
    }
}


-(void)presentCircleInfo {
    if (self.circle != nil) {
        self.circleTitleLabel.text = [self.circle objectForKey:kCircleFieldTitleKey];
    }
    
}

- (void)updateMeters {
    if ([self.recorder isRecording]) {
        [self.recorder updateMeters];
        
        CGFloat normalizedValue;
        normalizedValue = pow (10, [self.recorder averagePowerForChannel:0] / 20);
    
        [self.waveformView updateWithLevel:normalizedValue];
    
        //NSLog(@"Normalized value: %f", normalizedValue);
        
        if (normalizedValue < 0.2f) {
            self.waveformView.waveColor = [UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:242.0/255.0 alpha:1.0f];
            self.recordingStatusContainerView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:191.0/255.0 blue:172.0/255.0 alpha:1.0f];
            self.recordingStatusLabel.text = @"RECORDING";
            self.recordingStatusLabel.textColor = [UIColor blackColor];
        } else {
            self.waveformView.waveColor = [UIColor redColor];
            self.recordingStatusContainerView.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0f];
            self.recordingStatusLabel.text = @"TOO LOUD!";
            self.recordingStatusLabel.textColor = [UIColor whiteColor];
        }
        
        int minutes = (int)self.recorder.currentTime / 60;
        int seconds = (int)(self.recorder.currentTime - minutes * 60);

        self.recordTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes,seconds];
    } else [self.waveformView updateWithLevel:0.0f];
}

- (IBAction)recordButtonTouchDown:(id)sender {
    if (isRecording) return;
    
    // start recording
    isRecording = YES;
    self.recordingStatusLabel.text = @"RECORDING";
    self.instructionLabel0.hidden = YES;
    self.instructionLabel0a.hidden = YES;
    self.instructionLabel1.hidden = NO;
    
    [self.recorder record];
}

- (IBAction)recordButtonTouchUpInside:(id)sender {
    if (!isRecording) return;
    
    isRecording = NO;
    self.recordingStatusLabel.text = @"";
    self.instructionLabel0.hidden = NO;
    self.instructionLabel0a.hidden = NO;
    self.instructionLabel1.hidden = YES;
    
    [self.recorder pause];
    
    [[[UIAlertView alloc] initWithTitle:@"Finished?" message:@"Do you want to save this recording?" delegate:self cancelButtonTitle:@"Save" otherButtonTitles:@"Not yet", nil] show];
}

- (IBAction)recordButtonTouchUpOutside:(id)sender {
    // Just hand off to touch up inside
    [self recordButtonTouchUpInside:sender];
}

- (IBAction)closeButtonHit:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)bottomShareButtonHit:(id)sender {
    [self performSegueWithIdentifier:@"showShareViewController" sender:self];
}

- (IBAction)bottomCloseButtonHit:(id)sender {
    [self closeButtonHit:nil];
}

- (IBAction)cameraButtonHit:(id)sender {
    // Show the camera
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.allowsEditing = YES;
    
    [self presentViewController:imagePicker animated:YES completion:NULL];
}

-(UIImage *)captureView:(UIView *)view {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    UIGraphicsBeginImageContext(screenRect.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(ctx, screenRect);
    
    [view.layer renderInContext:ctx];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)captureScreenInRect:(CGRect)captureFrame {
    CALayer *layer;
    layer = self.view.layer;
    //UIGraphicsBeginImageContext(self.view.bounds.size);
    UIGraphicsBeginImageContext(captureFrame.size);
    CGContextClipToRect (UIGraphicsGetCurrentContext(),captureFrame);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenImage;
}

-(void)loadRecordedMoments {
    
    PFQuery *query = [PFQuery queryWithClassName:kMomentOfSilenceClassKey];
    [query whereKey:kMomentOfSilenceFieldCircleKey equalTo:self.circle];
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

#pragma mark - UIAlertViewDelegate Methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // User has requested a save
        self.instructionLabel0.hidden = YES;
        self.instructionLabel0a.hidden = YES;
        self.instructionLabel1.hidden = YES;
        self.recordButton.hidden = YES;
        self.recordButton.enabled = NO;
        self.thankYouLabel0.hidden = NO;
        self.thankYouLabel1.hidden = NO;
        self.thankYouLabel1.text = [NSString stringWithFormat:@"for %@", [self.circle objectForKey:kCircleFieldTitleKey]];

        self.cameraButton.hidden = YES;
        self.cameraButton.enabled = NO;
        
        self.recordedMomentsCollectionView.hidden = NO;
        
        self.waveformView.hidden = YES;

        self.recordingStatusContainerView.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:191.0/255.0 blue:172.0/255.0 alpha:1.0f];
        
        int minutes = (int)self.recorder.currentTime / 60;
        int seconds = (int)(self.recorder.currentTime - minutes * 60);
        
        self.finalTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d", minutes,seconds];
        self.finalTimeDateLabel.text = [[NSDate date] formattedDateWithStyle:NSDateFormatterMediumStyle];
        
        // Grab the duration before we stop recording
        recordingTime = self.recorder.currentTime;
        //int minutes = (int)recordingTime/ 60;
        //int seconds = (int)(recordingTime - minutes * 60);
        
        [self.recorder stop];
        
        // Hide the record button
        self.recordButton.hidden = YES;
        self.recordButton.enabled = NO;

        // Get the data from the file as data
        NSData *fileData = [NSData dataWithContentsOfFile:self.recordingPath];
        
        // Create a PFFile with this data
        PFFile *pfRecordingFile = [PFFile fileWithName:@"recording.aac" data:fileData];
        [pfRecordingFile saveInBackground];
        
        // Create a PFFile with the user's image
        PFFile *pfImageFile = [PFFile fileWithName:@"image.jpg" data:UIImageJPEGRepresentation(self.circleImageView.image, 1.0)];

        [pfImageFile saveInBackground];
        
        // Create a momentOfSilence object out of this data
        PFObject *momentOfSilence = [PFObject objectWithClassName:kMomentOfSilenceClassKey];
        [momentOfSilence setObject:pfRecordingFile forKey:kMomentOfSilenceFieldRecordingKey];
        [momentOfSilence setObject:pfImageFile forKey:kMomentOfSilenceFieldImageKey];
        [momentOfSilence setObject:[PFUser currentUser] forKey:kMomentOfSilenceFieldUserKey];
        [momentOfSilence setObject:self.circle forKey:kMomentOfSilenceFieldCircleKey];
        [momentOfSilence setObject:[NSNumber numberWithDouble:recordingTime] forKey:kMomentOfSilenceFieldDurationKey];
        [momentOfSilence saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                [[[UIAlertView alloc] initWithTitle:@"Error saving recording" message:@"Please try again" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            } else {
              //  [self dismissViewControllerAnimated:YES completion:nil];
                self.thankYouLabel0.hidden = YES;
                self.thankYouLabel1.hidden = YES;

                self.finalTimeLabel.hidden = NO;
                self.finalTimeSublabel.hidden = NO;
                self.finalTimeDateLabel.hidden = NO;
                
                self.closeButton.hidden = NO;
                self.shareButton.hidden = NO;
                
            }
        }];
        
 
    } else {
        // do nothing
    }
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
    RecordedMomentPreviewCollectionViewCell *cell;
    
    //if (indexPath.item % 3 == 0 && NO)
    //    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CircleLargeCollectionViewCell" forIndexPath:indexPath];
    //else if (indexPath.item % 2 == 0 && NO)
    //    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CircleMediumCollectionViewCell" forIndexPath:indexPath];
    //else
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecordedMomentPreviewCollectionViewCell" forIndexPath:indexPath];
    
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

#pragma mark - Image Picker Delegate Methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    self.circleImageView.image = image;
}
*/

@end
