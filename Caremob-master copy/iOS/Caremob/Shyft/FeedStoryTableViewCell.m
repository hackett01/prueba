//
//  FeedStoryTableViewCell.m
//  Caremob
//
//  Created by Rick Strom on 6/20/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import "FeedStoryTableViewCell.h"

@implementation FeedStoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)initializeWithFeedStory:(PFObject*)feedStory {
    self.storyTitleLabel.text = [feedStory objectForKey:kFeedStoryFieldTitleKey];
    NSString *descriptionText = [NSString stringWithString:[feedStory objectForKey:kFeedStoryFieldDescriptionKey]];
    
    //descriptionText = [descriptionText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"h:mma MM/dd/yyyy"];
    [dateFormatter setAMSymbol:@"am"];
    [dateFormatter setPMSymbol:@"pm"];
    NSString *createdAtDateString = [dateFormatter stringFromDate:feedStory.createdAt];
    descriptionText = createdAtDateString;

    
    if (descriptionText.length > 150)
        descriptionText = [descriptionText substringWithRange:NSMakeRange(0, 150)];
    
    self.storyBodyLabel.text = descriptionText;
    
    self.storyImageView.file = (PFFile*)[feedStory objectForKey:kFeedStoryFieldImageKey];
    [self.storyImageView loadInBackground];
}
@end
