//
//  CaremobFeed_TutorialTriggerTableViewCell.h
//  Caremob
//
//  Created by Rick Strom on 1/21/16.
//  Copyright © 2016 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CaremobFeed_TutorialTriggerTableViewCellDelegate <NSObject>

@required
-(void)tutorialTriggerDoneButtonHit;
@end

@interface CaremobFeed_TutorialTriggerTableViewCell : UITableViewCell
@property (nonatomic, weak) id <CaremobFeed_TutorialTriggerTableViewCellDelegate> delegate;

- (IBAction)doneButtonHit:(id)sender;
@end
