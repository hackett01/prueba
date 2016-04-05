//
//  CreateMobViewController.m
//  Caremob
//
//  Created by Rick Strom on 1/2/16.
//  Copyright © 2016 Rick Strom. All rights reserved.
//

#import "CreateMobViewController.h"

@interface CreateMobViewController ()
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *mobImageImageView;
@property (weak, nonatomic) IBOutlet UITextField *mobTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *mobTextTextView;

@property (weak, nonatomic) IBOutlet UIButton *uploadImageButton;
@property (weak, nonatomic) IBOutlet UIButton *writeTitleButton;
@property (weak, nonatomic) IBOutlet UIButton *writeTextButton;
@property (weak, nonatomic) IBOutlet UIButton *activateButton;

- (IBAction)uploadImageButtonHit:(id)sender;
- (IBAction)writeTitleButtonHit:(id)sender;
- (IBAction)writeTextButtonHit:(id)sender;


- (IBAction)activateButtonHit:(id)sender;


@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *subMobButtons;
- (IBAction)subMobButtonHit:(id)sender;

@end

@implementation CreateMobViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Configure the navigation bar
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"caremob_navbar_logo"]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:12.0/255.0 green:105.0/255.0 blue:148.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UIBarButtonItem *MyBackButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    //[MyBackButton setImage:[UIImage imageNamed:@"caremob_navbar_back_button"]];
    //[MyBackButton setBackButtonBackgroundImage:[UIImage imageNamed:@"caremob_navbar_back_button"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    MyBackButton.title = @"";
    
    NSDictionary *myBackButtonTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                [UIFont fontWithName:@"NettoOT" size:16.0f], NSFontAttributeName,
                                                nil];
    [MyBackButton setTitleTextAttributes:myBackButtonTextAttributes forState:UIControlStateNormal];
    [MyBackButton setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.backBarButtonItem = MyBackButton;

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (!self.didInitialize) {
        [self initializeViewController];
        
        [self resetViewController];
        
        self.didInitialize = YES;
    }
    [self showTutorialPopover];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back {
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    [super prepareForSegue:segue sender:sender];
    
    if ([segue.identifier isEqualToString:@"showCaremobDisplayViewController"]) {
        CaremobDisplayViewController *destination = (CaremobDisplayViewController*)segue.destinationViewController;
        
        destination.careMob = self.careMob;
        destination.categoryContext = self.categoryContext;
        
        destination.hidesBottomBarWhenPushed = YES;
        
        [self resetViewController];
    }

}

-(void)showTutorialPopover {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:kNSUserDefaultsCreateMobTutorialWasShown] == NO) {
        
        if(NSClassFromString(@"UIPopoverController")) {
        
            // grab the view controller we want to show
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"CreateMobTutorialPopover"];
    
            // present the controller
            // on iPad, this will be a Popover
            // on iPhone, this will be an action sheet
            controller.modalPresentationStyle = UIModalPresentationPopover;
    
            // configure the Popover presentation controller
            UIPopoverPresentationController *popController = [controller popoverPresentationController];
            popController.permittedArrowDirections = 0;
    
            [controller setPreferredContentSize:CGSizeMake(240, 400)];
            popController.delegate = self;
    
            // in case we don't have a bar button as reference
            double width = self.view.frame.size.width;
            double height = self.view.frame.size.height;
    
            double xOffset = (width - 240) / 2;
            double yOffset = (height - 400) / 2;
    
            NSLog(@"%f, %f --- %f, %f", width, height, xOffset, yOffset);
    
            popController.sourceView = self.view;
            //popController.sourceRect = CGRectMake(0, 0, width, yOffset);
    
            CGRect sourceRect = CGRectZero;
            sourceRect.origin.x = CGRectGetMidX(self.view.bounds)-self.view.frame.origin.x/2.0;
            sourceRect.origin.y = CGRectGetMidY(self.view.bounds)-self.view.frame.origin.y/2.0;
            popController.sourceRect = sourceRect;
    
            [self presentViewController:controller animated:YES completion:nil];

        }
        
        [userDefaults setBool:YES forKey:kNSUserDefaultsCreateMobTutorialWasShown];
        [userDefaults synchronize];
        
    }
}

- (IBAction)uploadImageButtonHit:(id)sender {
    
    if (self.mobTextTextView.isFirstResponder) [self.mobTextTextView resignFirstResponder];
    if (self.mobTitleTextField.isFirstResponder) [self.mobTitleTextField resignFirstResponder];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Source?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Camera" otherButtonTitles:@"Library", nil];
    //[actionSheet showFromTabBar:self.tabBarController.tabBar];
    
    if (self.tabBarController != nil && self.tabBarController.tabBar != nil)
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    else
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];

}

- (IBAction)writeTitleButtonHit:(id)sender {
    self.writeTitleButton.enabled = NO;
    self.writeTitleButton.hidden = YES;
    
    [self.mobTitleTextField becomeFirstResponder];
}

- (IBAction)writeTextButtonHit:(id)sender {
    self.writeTextButton.enabled = NO;
    self.writeTextButton.hidden = YES;
    
    [self.mobTextTextView becomeFirstResponder];
}

- (IBAction)activateButtonHit:(id)sender {
    if (self.subMobButtonsShown == YES) [self showSubmobButtons:NO animated:YES];
    else [self showSubmobButtons:YES animated:YES];
}

-(void)updateActivateButton {
    if (self.didChooseImage == YES                  &&
        self.mobTitleTextField.text != nil          &&
        self.mobTitleTextField.text.length > 0      &&
        //self.mobTextTextView.text != nil            &&
        //self.mobTextTextView.text.length > 0        &&
        !self.mobTitleTextField.isFirstResponder    &&
        !self.mobTextTextView.isFirstResponder) {
        
        NSLog(@"Showing activate");
        
        self.activateButton.enabled = YES;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.activateButton.alpha = 1;
        } completion:^(BOOL finished) {
            // Do nothing
        }];
    } else {
        NSLog(@"Hiding activate");
        if (self.mobTextTextView.isFirstResponder) NSLog(@"Because text view is first responder");
        self.activateButton.enabled = NO;
        
        [UIView animateWithDuration:0.5 animations:^{
            self.activateButton.alpha = 0;
        } completion:^(BOOL finished) {
            // Do nothing
        }];

    }
}

-(void)initializeViewController {
    self.categoryList = @[@"support",@"protest",@"celebration",@"peace",@"mourning",@"empathy"];
    
    // Store the initial frames of all the buttons
    self.categoryButtonInitialFrames = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < self.subMobButtons.count; i++) {
        self.categoryButtonInitialFrames[[NSString stringWithFormat:@"%d",i]] = [NSValue valueWithCGRect:CGRectMake(((UIButton*)self.subMobButtons[i]).frame.origin.x, ((UIButton*)self.subMobButtons[i]).frame.origin.y, ((UIButton*)self.subMobButtons[i]).frame.size.width, ((UIButton*)self.subMobButtons[i]).frame.size.height)];
    }
    
    // Store the initial centers of all the buttons
    self.categoryButtonInitialCenters = [[NSMutableDictionary alloc] init];
    
    
    for (int i = 0; i < self.subMobButtons.count; i++) {
        UIButton *b = (UIButton*)self.subMobButtons[i];
        
        self.categoryButtonInitialCenters[[NSString stringWithFormat:@"%d",i]] = [NSValue valueWithCGPoint:CGPointMake(b.center.x, b.center.y)];
    }
    
    //CGPoint joinButtonCenter = [self.categoryButtonInitialCenters[@"join"] CGPointValue];
    
    [self showSubmobButtons:NO animated:NO];
}

-(void)showSubmobButtons:(BOOL)show animated:(BOOL)animated {
    if (show == YES) {
        if (animated == YES) {
            // Show all submob buttons
            for (int i = 0; i < self.subMobButtons.count; i++) {
                UIButton *b = (UIButton*)self.subMobButtons[i];
            
                CGPoint p = [self.categoryButtonInitialCenters[[NSString stringWithFormat:@"%d",i]] CGPointValue];
                b.enabled = YES;
            
                [UIView animateWithDuration:0.2 delay:0.05 * (float)i options:UIViewAnimationOptionCurveLinear animations:^{
                    b.alpha = 1;
                    b.center = p;
                    b.transform = CGAffineTransformMakeScale(1, 1);
                } completion:^(BOOL finished) {
                    self.subMobButtonsShown = YES;
                }];
            }
        } else {
            // Show all submob buttons
            for (int i = 0; i < self.subMobButtons.count; i++) {
                UIButton *b = (UIButton*)self.subMobButtons[i];
                
                CGPoint p = [self.categoryButtonInitialCenters[[NSString stringWithFormat:@"%d",i]] CGPointValue];
                b.enabled = YES;
                
                b.alpha = 1;
                b.center = p;
                b.transform = CGAffineTransformMakeScale(1, 1);
        
                self.subMobButtonsShown = YES;
        
            }
        }
    } else {
        
        if (animated == YES) {
            CGPoint activateCenter = self.activateButton.center;
        
            // Hide all submob buttons
            for (int i = 0; i < self.subMobButtons.count; i++) {
                UIButton *b = (UIButton*)self.subMobButtons[i];
                b.enabled = NO;
            
                [UIView animateWithDuration:0.2 delay:0.05 * (float)i options:UIViewAnimationOptionCurveLinear animations:^{
                    b.alpha = 0;
                    b.center = activateCenter;
                    b.transform = CGAffineTransformMakeScale(1, 1);
                } completion:^(BOOL finished) {
                    self.subMobButtonsShown = NO;
                }];
            }
        } else {
            CGPoint activateCenter = self.activateButton.center;
            
            // Hide all submob buttons
            for (int i = 0; i < self.subMobButtons.count; i++) {
                UIButton *b = (UIButton*)self.subMobButtons[i];
                b.enabled = NO;
                
                b.alpha = 0;
                b.center = activateCenter;
                b.transform = CGAffineTransformMakeScale(1, 1);
                
                self.subMobButtonsShown = NO;
            }
        }
    }
}

-(void)resetViewController {
    self.careMob = nil;
    
    self.imageFile = nil;
    self.mobImageImageView.image = [UIImage imageNamed:@"start_mob_default_image"];
    self.didChooseImage = NO;
    
    self.mobTextTextView.text = @"";
    self.mobTitleTextField.text = @"";

    self.writeTitleButton.enabled = YES;
    self.writeTitleButton.hidden = NO;
    
    self.writeTextButton.enabled = YES;
    self.writeTextButton.hidden = NO;

    [self.uploadImageButton setTitle:@"UPLOAD IMAGE" forState:UIControlStateNormal];
    [self.uploadImageButton setImage:[UIImage imageNamed:@"icon_start"] forState:UIControlStateNormal];
    
    self.activateButton.enabled = NO;
    self.activateButton.alpha = 0;
    
    if ([PFUser currentUser] != nil) {
        self.sourceLabel.text = [NSString stringWithFormat:@"Source: %@", [[PFUser currentUser] objectForKey:kUserFieldUsernameKey]];
    } else {
        self.sourceLabel.text = @"";
    }
    
    NSDateFormatter *nowDateFormatter = [[NSDateFormatter alloc] init];
    [nowDateFormatter setDateFormat:@"MMMM d, yyyy"];
    NSString *dateString = [nowDateFormatter stringFromDate:[NSDate date]];
    
    self.dateLabel.text = dateString;
}

-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    return UIModalPresentationNone;
}

#pragma mark - Action Sheet Delegate Methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        
        [self presentViewController:imagePicker animated:YES completion:NULL];
    } else if (buttonIndex == 1) {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = YES;
        
        [self presentViewController:imagePicker animated:YES completion:NULL];
        
    } else {
        
    }
}

#pragma mark - Image Picker Delegate Methods
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    // Size and save these files
    
    // Full size
    UIGraphicsBeginImageContext(CGSizeMake(600,600));
    [image drawInRect:CGRectMake(0,0,600,600)];
    UIImage *sizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.mobImageImageView.image = sizedImage;
    
    // Now that we have an image, we can hide the button contents (but keep it active)
    [self.uploadImageButton setTitle:@"" forState:UIControlStateNormal];
    [self.uploadImageButton setImage:nil forState:UIControlStateNormal];
    
    self.didChooseImage = YES;
    
    [self updateActivateButton];
    
    self.imageFile = [PFFile fileWithName:@"story_image.jpg" data:UIImageJPEGRepresentation(sizedImage, 0.8)];

    [self.imageFile saveInBackground];
}

#pragma mark - UITextFieldDelegate methods
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    self.writeTitleButton.enabled = NO;
    self.writeTitleButton.hidden = YES;
    
    [self updateActivateButton];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.text == nil || textField.text.length == 0) {
        // Re-enable the button
        self.writeTitleButton.enabled = YES;
        self.writeTitleButton.hidden = NO;
    } // else leave it hidden
    
    [self updateActivateButton];
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    [self updateActivateButton];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if (textField.text == nil || textField.text.length == 0) {
        // Re-enable the button
        self.writeTitleButton.enabled = YES;
        self.writeTitleButton.hidden = NO;
    } // else leave it hidden
    
    return YES;
}

#pragma mark - UITextFieldDelegate methods
-(void)textViewDidBeginEditing:(UITextView *)textView {
    self.writeTextButton.enabled = NO;
    self.writeTextButton.hidden = YES;
    
    [self updateActivateButton];
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    
    if (textView.text == nil || textView.text.length == 0) {
        // Re-enable the button
        self.writeTextButton.enabled = YES;
        self.writeTextButton.hidden = NO;
    } // else leave it hidden

    [self updateActivateButton];
    
    return YES;
}

- (IBAction)subMobButtonHit:(id)sender {
    // Find the index of the hit button
    int index = -1;
    
    for (int i = 0; i < self.subMobButtons.count; i++) {
        if (sender == self.subMobButtons[i]) index = i;
    }
    
    if (index >= 0 && index < self.categoryList.count) {
        [self showSubmobButtons:NO animated:YES];
        
        self.categoryContext = [NSString stringWithString:(NSString*)self.categoryList[index]];
        
        //NSLog(@"Hit category %@", category);
        
        // Create and save the new mob, and transition into the mob display screen
        self.careMob = [PFObject objectWithClassName:kCareMobClassKey];
        [self.careMob setObject:self.mobTitleTextField.text forKey:kCareMobTitleKey];
        [self.careMob setObject:self.categoryContext forKey:kCareMobOriginalCategoryKey];
        
        if (self.mobTextTextView.text != nil && self.mobTextTextView.text.length > 0) {
            [self.careMob setObject:self.mobTextTextView.text forKey:kCareMobLongTextKey];
            [self.careMob setObject:self.mobTextTextView.text forKey:kCareMobShortTextKey];
        } else {
            [self.careMob setObject:@"" forKey:kCareMobLongTextKey];
            [self.careMob setObject:@"" forKey:kCareMobShortTextKey];
        }
        
        [self.careMob setObject:self.imageFile forKey:kCareMobImageKey];
        [self.careMob setObject:[PFUser currentUser] forKey:kCareMobSourceUserKey];
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Creating your mob!";
        
        [self.careMob saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            [hud hide:YES];
            
            if (error) {
                [[[UIAlertView alloc] initWithTitle:@"Error creating mob!" message:@"Could not create your mob at this time.  Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            } else {
                MBProgressHUD *initializeHud  = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                initializeHud.labelText = @"Initializing your mob!";
                
                // Now we need to fetch the mob including the submobs key
                PFQuery *caremobQuery = [PFQuery queryWithClassName:kCareMobClassKey];
                [caremobQuery whereKey:kCareMobObjectIdKey equalTo:self.careMob.objectId];
                [caremobQuery includeKey:kCareMobSubMobsKey];
                [caremobQuery includeKey:kCareMobSourceUserKey];
                
                [caremobQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                    [initializeHud hide:YES];
                    
                    if (error) {
                        [[[UIAlertView alloc] initWithTitle:@"Error creating mob!" message:@"Could not create your mob at this time.  Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                    } else {
                        if (objects == nil || objects.count == 0) {
                            [[[UIAlertView alloc] initWithTitle:@"Error creating mob!" message:@"Could not create your mob at this time.  Please try again later" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
                        } else {
                            self.careMob = (PFObject*)objects[0];
                            
                            [self performSegueWithIdentifier:@"showCaremobDisplayViewController" sender:self];
                        }
                    }
                }];

            }
        }];
    }
}
@end
