//
//  FeedStoryViewController.h
//  Caremob
//
//  Created by Rick Strom on 6/20/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CareMobConstants.h"
#import "UserLevelControlViewController.h"

#import "FeedStoryTableViewCell.h"

#import "CaremobDisplayViewController.h"

@interface FeedStoryViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSString *source;
@property (nonatomic, strong) NSArray *feedStories;
@property (nonatomic, strong) PFObject *selectedCareMob;


@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, assign) BOOL isRefreshing;

@end
