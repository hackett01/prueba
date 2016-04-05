//
//  SignupViewController.m
//  Caremob
//
//  Created by Rick Strom on 12/21/15.
//  Copyright © 2015 Rick Strom. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()
@property (weak, nonatomic) IBOutlet UIButton *choosePhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)choosePhotoButtonHit:(id)sender;
- (IBAction)signUpButtonHit:(id)sender;

@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Configure the navigation bar
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"caremob_navbar_logo"]];
    //[self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:12.0/255.0 green:105.0/255.0 blue:148.0/255.0 alpha:1.0]];
    //[self.navigationController.navigationBar setTranslucent:NO];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.navigationController setNavigationBarHidden:YES animated:animated];
    
    // Dismiss this if we already have a user
    if ([PFUser currentUser]) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)back {
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)choosePhotoButtonHit:(id)sender {
    NSLog(@"Change photo requested");
    
    if (self.usernameTextField.isFirstResponder) [self.usernameTextField resignFirstResponder];
    if (self.nameTextField.isFirstResponder) [self.nameTextField resignFirstResponder];
    if (self.emailTextField.isFirstResponder) [self.emailTextField resignFirstResponder];
    if (self.passwordTextField.isFirstResponder) [self.passwordTextField resignFirstResponder];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Source?" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Camera" otherButtonTitles:@"Library", nil];
    //[actionSheet showFromTabBar:self.tabBarController.tabBar];
    
    if (self.tabBarController != nil && self.tabBarController.tabBar != nil)
        [actionSheet showFromTabBar:self.tabBarController.tabBar];
    else
        [actionSheet showInView:[UIApplication sharedApplication].keyWindow];

}

- (IBAction)signUpButtonHit:(id)sender {
    // Do validation
    if (self.emailTextField.text == nil || self.emailTextField.text.length == 0 || ![self validateEmail:self.emailTextField.text]) {
        [[[UIAlertView alloc] initWithTitle:@"Please enter email address" message:@"You did not enter a valid email address" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        
        return;
    } else if (self.usernameTextField.text == nil || self.usernameTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Please choose a username" message:@"You did not enter a valid username" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        
        return;
    } else if (self.nameTextField.text == nil || self.nameTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Please enter your name" message:@"You did not enter a valid name" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        
        return;
    } else if (self.passwordTextField.text == nil || self.passwordTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Please enter a password" message:@"You did not enter a valid password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];

        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Signing up!";
    
    // Attempt to create this user
    PFUser *user = [PFUser user];
    [user setObject:self.emailTextField.text forKey:kUserFieldEmailKey];
    [user setObject:self.passwordTextField.text forKey:kUserFieldPasswordKey];
    [user setObject:self.usernameTextField.text forKey:kUserFieldUsernameKey];
    [user setObject:self.nameTextField.text forKey:kUserFieldNameKey];
    
    if (self.imageFile != nil) [user setObject:self.imageFile forKey:kUserFieldProfileImageKey];
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        [hud hide:YES];
        
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Could not create user" message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
            return;
        } else {
            if ([PFUser currentUser] != nil) {
                [[PFUser currentUser] setObject:[NSNumber numberWithBool:YES] forKey:kUserFieldDidSetUsernameKey];
                [[PFUser currentUser] saveEventually];
                
                // Let the app know a new user logged in
                [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationUserDidChange object:nil];
                
                //[self dismissViewControllerAnimated:YES completion:^{
                //    // Do nothing
                //}];
                [self performSegueWithIdentifier:@"showPostSignupForceFollowViewController" sender:self];
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }
    }];
}

-(BOOL)validateEmail:(NSString *)candidate {
    NSString *emailRegex =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
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
    
    NSData *imageData = UIImageJPEGRepresentation(sizedImage, 0.05f);
    
    self.imageFile = [PFFile fileWithName:@"ProfileImage.jpg" data:imageData];
    
    // Save both files in background
    [self.imageFile saveInBackground];
    
    // Update the core table cell
    [self.choosePhotoButton setBackgroundImage:image forState:UIControlStateNormal];
}

#pragma mark - UITextFieldDelegate methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}
@end
