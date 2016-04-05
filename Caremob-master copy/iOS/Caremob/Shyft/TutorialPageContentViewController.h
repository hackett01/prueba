//
//  TutorialPageContentViewController.h
//  Caremob
//
//  Created by Rick Strom on 1/21/16.
//  Copyright © 2016 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TutorialPageContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property NSUInteger pageIndex;
@property NSString *imageFile;
@end
