//
//  FeedViewController.h
//  Shyft
//
//  Created by Rick Strom on 11/15/14.
//  Copyright (c) 2014 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CareMobConstants.h"

// Collection View Cells
#import "CircleSmallCollectionViewCell.h"

// Destination View Controllers
#import "CircleInfoViewController.h"

@interface FeedViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSArray *circles;
@property (nonatomic, strong) NSIndexPath* selectedIndexPath;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@end
