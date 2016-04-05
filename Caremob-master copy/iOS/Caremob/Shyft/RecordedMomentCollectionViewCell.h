//
//  RecordedMomentCollectionViewCell.h
//  Shyft
//
//  Created by Rick Strom on 12/7/14.
//  Copyright (c) 2014 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CareMobConstants.h"

@interface RecordedMomentCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *momentImageView;

-(void)setRecordedMoment:(PFObject*)moment;
@end
