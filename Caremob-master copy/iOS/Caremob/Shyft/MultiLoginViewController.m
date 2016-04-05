//
//  MultiLoginViewController.m
//  Caremob
//
//  Created by Rick Strom on 12/10/15.
//  Copyright © 2015 Rick Strom. All rights reserved.
//

#import "MultiLoginViewController.h"

@interface MultiLoginViewController ()
@property (weak, nonatomic) IBOutlet UIView *loginControlContainerView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;


@property (weak, nonatomic) IBOutlet UIButton *signinButton;
@property (weak, nonatomic) IBOutlet UIButton *signinWithFacebookButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;

- (IBAction)signinButtonHit:(id)sender;
- (IBAction)signinWithFacebookButtonHit:(id)sender;
- (IBAction)signupButtonHit:(id)sender;
@end

@implementation MultiLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.activityIndicatorView.hidden = YES;
    
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
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if ([PFUser currentUser]) {
        // NEW: Dismiss view controller (no help screens)
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
        // OLD: push the first help view controller
        //[self performSegueWithIdentifier:@"showNextViewController" sender:self];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (IBAction)signinButtonHit:(id)sender {
    // Do validation
    if (self.usernameTextField.text == nil || self.usernameTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Please enter your username" message:@"You did not enter a valid username" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        
        return;
    } else if (self.passwordTextField.text == nil || self.passwordTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Please enter your password" message:@"You did not enter a valid password" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil] show];
        
        return;
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Logging in!";
    [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextField.text block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        [hud hide:YES];
        
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Could not log in" message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];

            return;
        } else {
            // Notify all screens that the user changed
            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationUserDidChange object:nil];
            
            [self dismissViewControllerAnimated:YES completion:^{
                // Do nothing
            }];
        }
    }];
}

- (IBAction)signinWithFacebookButtonHit:(id)sender {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"public_profile", @"email", @"user_location", @"user_friends"];
    
    // Login PFUser using Facebook
    
    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        //    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [self.activityIndicatorView stopAnimating]; // Hide loading indicator
        self.activityIndicatorView.hidden = YES;

        self.signinButton.enabled = YES;
        self.signinWithFacebookButton.enabled = YES;
        self.signupButton.enabled = YES;
        
        if (!user) {
            NSString *errorMessage = nil;
            if (!error) {
                NSLog(@"The user cancelled the Facebook login.");
                errorMessage = @"The user cancelled the Facebook login.";
            } else {
                NSLog(@"An error occurred: %@", error);
                errorMessage = [error localizedDescription];
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Dismiss", nil];
            [alert show];
        } else {
            if (user.isNew) {
                NSLog(@"User with facebook signed up and logged in!");
            } else {
                NSLog(@"User with facebook logged in!");
            }
            
            //[self _presentUserDetailsViewControllerAnimated:YES];
            
            
            
            // See if we need to get a username
            NSNumber *didSetUsername = (NSNumber*)[user objectForKey:kUserFieldDidSetUsernameKey];
            if (didSetUsername == nil || [didSetUsername boolValue] == NO) {
                [self performSegueWithIdentifier:@"showFacebookUserChooseUsernameViewController" sender:self];
            } else {
                // Let the app know a new user logged in
                [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationUserDidChange object:nil];
                
                // Dismiss the modal
                [self dismissViewControllerAnimated:YES completion:^{
                
                }];
            }
            
        }
    }];
    
    [self.activityIndicatorView startAnimating]; // Show loading indicator until login is finished
    self.activityIndicatorView.hidden = NO;

    self.signinButton.enabled = NO;
    self.signinWithFacebookButton.enabled = NO;
    self.signupButton.enabled = NO;
}

- (IBAction)signupButtonHit:(id)sender {
    [self performSegueWithIdentifier:@"showSignupViewController" sender:self];
}

#pragma mark - UITextFieldDelegate methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}
@end
