//
//  ShareViewController.m
//  Shyft
//
//  Created by Rick Strom on 11/21/14.
//  Copyright (c) 2014 Rick Strom. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()
- (IBAction)closeButtonHit:(id)sender;
- (IBAction)twitterButtonHit:(id)sender;
- (IBAction)facebookButtonHit:(id)sender;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@", self.shareMessageText);
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

- (IBAction)closeButtonHit:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        // Do nothing
    }];
}

- (IBAction)twitterButtonHit:(id)sender {
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        [[[UIAlertView alloc] initWithTitle:@"Enable Twitter!" message:@"Twitter is not configured for this device.  Please open the Settings app to configure Twitter." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    } else {
        SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                // Do nothing
                NSLog(@"Cancelled");
                
            } else {
                // Do nothing
                NSLog(@"Done");
                [[[UIAlertView alloc] initWithTitle:@"Thank you!" message:@"Thank you for sharing your moment!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            }
            
            [composeViewController dismissViewControllerAnimated:YES completion:Nil];
        };
        composeViewController.completionHandler = myBlock;
        
        //Adding the Text to the facebook post value from iOS
        [composeViewController setInitialText:self.shareMessageText];
        
        if (self.shareImage != nil)
            [composeViewController addImage:self.shareImage];

        [self presentViewController:composeViewController animated:YES completion:Nil];
        
    }

}

- (IBAction)facebookButtonHit:(id)sender {
    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        [[[UIAlertView alloc] initWithTitle:@"Enable Facebook!" message:@"Facebook is not configured for this device.  Please open the Settings app to configure Facebook." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    } else {
        SLComposeViewController *composeViewController = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                // Do nothing
                NSLog(@"Cancelled");
                
            } else {
                // Do nothing
                NSLog(@"Done");
                [[[UIAlertView alloc] initWithTitle:@"Thank you!" message:@"Thank you for sharing your moment!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
            }
            
            [composeViewController dismissViewControllerAnimated:YES completion:Nil];
        };
        composeViewController.completionHandler = myBlock;
        
        //Adding the Text to the facebook post value from iOS
        [composeViewController setInitialText:self.shareMessageText];
        
        if (self.shareImage != nil)
            [composeViewController addImage:self.shareImage];
        
        [self presentViewController:composeViewController animated:YES completion:Nil];

    }

}
@end
