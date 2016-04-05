//
//  CreateMobViewController.h
//  Caremob
//
//  Created by Rick Strom on 1/2/16.
//  Copyright © 2016 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CareMobConstants.h"
#import "MBProgressHUD.h"
#import "CaremobDisplayViewController.h"

@interface CreateMobViewController : UIViewController <UIPopoverPresentationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, assign) BOOL didChooseImage;
@property (nonatomic, assign) BOOL subMobButtonsShown;
@property (nonatomic, assign) BOOL didInitialize;
@property (nonatomic, strong) NSMutableDictionary *categoryButtonInitialFrames;
@property (nonatomic, strong) NSMutableDictionary *categoryButtonInitialCenters;

@property (nonatomic, strong) NSArray *categoryList;

@property (nonatomic, strong) PFFile *imageFile;
@property (nonatomic, strong) NSString *categoryContext;
@property (nonatomic, strong) PFObject *careMob;
@end
