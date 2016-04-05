//
//  CaremobFeedSectionHeaderViewController.h
//  Caremob
//
//  Created by Rick Strom on 6/1/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CaremobFeedSectionHeaderViewControllerDelegate <NSObject>

@required
-(BOOL)expandButtonWasHitForSection:(int)section;
@end

@interface CaremobFeedSectionHeaderViewController : UITableViewHeaderFooterView
@property (nonatomic, weak) id <CaremobFeedSectionHeaderViewControllerDelegate> delegate;
@property (nonatomic, assign) int section;
@property (weak, nonatomic) IBOutlet UILabel *sectionTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sectionHeaderBackgroundImage;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;
@property (weak, nonatomic) IBOutlet UIButton *expandButton;

- (IBAction)expandButtonHit:(id)sender;
-(void)setExpandButtonState:(BOOL)isExpanded;
@end
