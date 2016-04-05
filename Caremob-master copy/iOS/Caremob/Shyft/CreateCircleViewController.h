//
//  CreateCircleViewController.h
//  Shyft
//
//  Created by Rick Strom on 2/8/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CareMobConstants.h"
#import "CircleInfoViewController.h"
#import "CreateCircle_CategoryDrilldownViewController.h"

#define kMinimumCircleTime 0
#define kMaximumCircleTime 60

@interface CreateCircleViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, CreateCircle_CategoryDrilldownTableViewCellDelegate>
@property (weak, nonatomic) UITextField *activeTextField;
@property (weak, nonatomic) UITextView *activeTextView;
@property (nonatomic, assign) BOOL keyboardIsShown;
@property (nonatomic, strong) PFObject *circle;
@property (nonatomic, strong) NSString *circleCategory;
@property (nonatomic, assign) int circleTime;
@end
