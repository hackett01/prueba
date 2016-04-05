//
//  SignupViewController.h
//  Caremob
//
//  Created by Rick Strom on 12/21/15.
//  Copyright © 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "CareMobConstants.h"
#import "CareMobHelper.h"
#import "MBProgressHUD.h"

@interface SignupViewController : UIViewController <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>
@property (nonatomic, strong) PFFile *imageFile;
@end
