//
//  HeatmapUserPinViewController.m
//  Caremob
//
//  Created by Rick Strom on 9/2/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import "HeatmapUserPinViewController.h"

@interface HeatmapUserPinViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *pinImageView;
@property (weak, nonatomic) IBOutlet PFImageView *userImageView;

@end

@implementation HeatmapUserPinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.transform = CGAffineTransformMakeScale(0.01,0.01);
    
    NSLog(@"In awake from nib");
    if (self.user != nil) {
        if (self.isCurrentUser) self.pinImageView.image = [UIImage imageNamed:@"heatmap_pin_user"];
        else self.pinImageView.image = [UIImage imageNamed:@"heatmap_pin_mobber"];
        
        PFFile *userImage = (PFFile*)[self.user objectForKey:kUserFieldProfileImageKey];
        self.userImageView.file = userImage;
        
        if (self.userImageView == nil) NSLog(@"Userimageview is nil!");
        [self.userImageView loadInBackground:^(UIImage *image, NSError *error) {
            if (!error) {
                NSLog(@"Image loaded fine!");
            } else {
                NSLog(@"Error!");
            }
        }];
        NSLog(@"Initializing with user image %@!", userImage.description);
        
        [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.0f options:0 animations:^{
            self.view.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL finished) {
            //if (finished)
                //self.view.transform = CGAffineTransformMakeScale(1, 1);
        }];
        
        // Play sound
        //[[Sound soundNamed:kSoundHeatmapUserEnter] play];
    }
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

-(void)initializeWithUser:(PFObject*)user isCurrentUser:(BOOL)isCurrentUser {
    self.user = user;
    self.isCurrentUser = isCurrentUser;
    NSLog(@"Initialize called");
}

-(void)hideAndRemoveFromSuperview {
    //self.view.transform = CGAffineTransformIdentity;
    self.view.transform = CGAffineTransformMakeScale(1, 1);
    
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.transform = CGAffineTransformMakeScale(0.01,0.01);
    } completion:^(BOOL finished) {
        if (finished)
            [self.view removeFromSuperview];
    }];
    
    // Play sound
    //[[Sound soundNamed:kSoundHeatmapUserLeave] play];
}
@end
