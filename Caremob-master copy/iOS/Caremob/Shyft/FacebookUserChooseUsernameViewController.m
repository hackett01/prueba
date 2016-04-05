//
//  FacebookUserChooseUsernameViewController.m
//  Caremob
//
//  Created by Rick Strom on 1/1/16.
//  Copyright © 2016 Rick Strom. All rights reserved.
//

#import "FacebookUserChooseUsernameViewController.h"

@interface FacebookUserChooseUsernameViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;

@property (weak, nonatomic) IBOutlet UIButton *setUsernameButton;


- (IBAction)setUsernameButtonHit:(id)sender;

@end

@implementation FacebookUserChooseUsernameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if ([PFUser currentUser] == nil) {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)setUsernameButtonHit:(id)sender {
    if (self.usernameTextField.text == nil || self.usernameTextField.text.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"Enter a username" message:@"You must enter a valid username" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        
        return;
    }
    
    PFUser *user = [PFUser currentUser];
    [user setObject:self.usernameTextField.text forKey:kUserFieldUsernameKey];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error) {
            [[[UIAlertView alloc] initWithTitle:@"Can't save user" message:error.localizedDescription delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        } else {
            [user setObject:[NSNumber numberWithBool:YES] forKey:kUserFieldDidSetUsernameKey];
            [user saveEventually];
            
            // Let the app know a new user logged in
            [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationUserDidChange object:nil];
            
            //[self dismissViewControllerAnimated:YES completion:^{
                // Do nothing
            //}];
            [self performSegueWithIdentifier:@"showPostSignupForceFollowViewController" sender:self];
        }
    }];
}

#pragma mark - UITextFieldDelegate methods
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}

@end
