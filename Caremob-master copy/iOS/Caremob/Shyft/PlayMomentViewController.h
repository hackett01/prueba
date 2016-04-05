//
//  PlayMomentViewController.h
//  Shyft
//
//  Created by Rick Strom on 11/20/14.
//  Copyright (c) 2014 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CareMobConstants.h"
#import <AVFoundation/AVFoundation.h>

#import "CircleInfoViewController.h"

#import "RecordedMomentCollectionViewCell.h"

@interface PlayMomentViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    AVAudioPlayer *audioPlayer;
}

@property (nonatomic, weak) PFObject *moment;
@property (nonatomic, weak) NSString *titleText;
@property (nonatomic, weak) NSString *timeText;
@property (nonatomic, strong) NSArray *recordedMoments;

-(void)initializeWithTitle:(NSString*)title andTime:(NSString*)time andMoment:(PFObject*)moment;
-(void)loadRecordedMoments;
@end
