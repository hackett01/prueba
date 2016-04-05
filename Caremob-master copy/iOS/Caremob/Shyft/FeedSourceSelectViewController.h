//
//  FeedSourceSelectViewController.h
//  Caremob
//
//  Created by Rick Strom on 7/8/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserLevelControlViewController.h"

#import "FeedStoryViewController.h"

@interface FeedSourceSelectViewController : UIViewController
@property (nonatomic, strong) NSString *selectedSource;
@property (nonatomic, strong) UserLevelControlViewController *userLevelViewController;
@end
