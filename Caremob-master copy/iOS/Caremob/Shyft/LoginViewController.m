//
//  LoginViewController.m
//  Shyft
//
//  Created by Rick Strom on 11/13/14.
//  Copyright (c) 2014 Rick Strom. All rights reserved.
//

#import "LoginViewController.h"
//#import <FacebookSDK/FacebookSDK.h>

#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicatorView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)loginButtonHit:(id)sender;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.activityIndicatorView.hidden = YES;
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
    } else {
        // Set up video on video canvas view
        NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"login_bg_video" ofType:@"mp4"];
        NSURL *videoURL = [NSURL fileURLWithPath:videoPath];
        self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:videoURL];
        [self.moviePlayer.view setFrame:self.view.bounds];
        [self.view addSubview:self.moviePlayer.view];
        [self.view sendSubviewToBack:self.moviePlayer.view];
        
        self.moviePlayer.controlStyle = MPMovieControlStyleNone;
        self.moviePlayer.repeatMode = MPMovieRepeatModeOne;
        self.moviePlayer.scalingMode = MPMovieScalingModeAspectFill;
        [self.moviePlayer prepareToPlay];
        [self.moviePlayer play];
        
        
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}

-(BOOL)prefersStatusBarHidden {
    return YES;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginButtonHit:(id)sender {
    // Set permissions required from the facebook user account
    NSArray *permissionsArray = @[ @"public_profile", @"email", @"user_location", @"user_friends"];
    
    // Login PFUser using Facebook

    [PFFacebookUtils logInInBackgroundWithReadPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
//    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [self.activityIndicatorView stopAnimating]; // Hide loading indicator
        self.activityIndicatorView.hidden = YES;
        self.loginButton.hidden = NO;
        self.loginButton.enabled = YES;
        
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
            
            
            // NEW: Dismiss view controller (no help screens)
            [self dismissViewControllerAnimated:YES completion:^{
     
            }];
            
            // OLD: push the first help view controller
            //[self performSegueWithIdentifier:@"showNextViewController" sender:self];
        }
    }];
    
    [self.activityIndicatorView startAnimating]; // Show loading indicator until login is finished
    self.activityIndicatorView.hidden = NO;
    self.loginButton.hidden = YES;
    self.loginButton.enabled = NO;
}
@end
