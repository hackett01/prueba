//
//  TutorialPageViewController.h
//  Caremob
//
//  Created by Rick Strom on 1/21/16.
//  Copyright © 2016 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TutorialPageContentViewController.h"

@interface TutorialPageViewController : UIPageViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property (strong, nonatomic) NSArray *pageImages;
@property (nonatomic, strong) NSMutableArray *pages;
@end
