//
//  ViewController.h
//  Shyft
//
//  Created by Rick Strom on 11/13/14.
//  Copyright (c) 2014 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CareMobConstants.h"
#import "NSDate+DateTools.h"

#import "RootViewController.h"
#import "CircleInfoViewController.h"

#import "UserActivityTableViewCell.h"

@interface UserViewController : UIViewController 
@property (nonatomic, weak) PFObject *user;
@property (nonatomic, assign) BOOL isFollowing;
@property (nonatomic, strong) NSArray *categoryList;
@end

