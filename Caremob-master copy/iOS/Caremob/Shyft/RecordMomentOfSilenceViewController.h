//
//  RecordMomentOfSilenceViewController.h
//  Shyft
//
//  Created by Rick Strom on 11/18/14.
//  Copyright (c) 2014 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Parse/Parse.h>
#import "SCSiriWaveformView.h"
#import "CareMobConstants.h"
#import "ShareViewController.h"
#import "NSDate+DateTools.h"

#import "RecordedMomentPreviewCollectionViewCell.h"

@interface RecordMomentOfSilenceViewController : UIViewController <UIAlertViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    BOOL isRecording;
    double recordingTime;
}

@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSString *recordingPath;
@property (nonatomic, weak) PFObject *circle;
@property (nonatomic, strong) NSArray *recordedMoments;

-(void)loadRecordedMoments;
@end
