//
//  FeedStoryTableViewCell.h
//  Caremob
//
//  Created by Rick Strom on 6/20/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

#import "CareMobConstants.h"

@interface FeedStoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PFImageView *storyImageView;
@property (weak, nonatomic) IBOutlet UILabel *storyTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *storyBodyLabel;

-(void)initializeWithFeedStory:(PFObject*)feedStory;
@end
