//
//  RecordedMomentCollectionViewCell.m
//  Shyft
//
//  Created by Rick Strom on 12/7/14.
//  Copyright (c) 2014 Rick Strom. All rights reserved.
//

#import "RecordedMomentCollectionViewCell.h"

@implementation RecordedMomentCollectionViewCell

/*
-(void)setRecordedMoment:(PFObject*)moment {
    if (moment == nil) return;
    
    PFFile *imageFile = (PFFile*)[moment objectForKey:kMomentOfSilenceFieldImageKey];
    if ([imageFile isDataAvailable]) {
        self.momentImageView.image = [UIImage imageWithData:[imageFile getData]];
    } else {
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (error) {
                
            } else {
                self.momentImageView.image = [UIImage imageWithData:data];
            }
        }];
    }
}
*/
@end
