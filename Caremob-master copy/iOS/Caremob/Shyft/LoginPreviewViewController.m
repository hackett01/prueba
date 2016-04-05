//
//  LoginPreviewViewController.m
//  Caremob
//
//  Created by Rick Strom on 12/7/15.
//  Copyright © 2015 Rick Strom. All rights reserved.
//

#import "LoginPreviewViewController.h"

@interface LoginPreviewViewController ()
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *mobActionActivitySpinnerImageViews;
@property (weak, nonatomic) IBOutlet UIButton *thumbButton;

- (IBAction)thumbButtonHit:(id)sender;
@end

@implementation LoginPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    

    
    
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

-(BOOL)prefersStatusBarHidden {
    return YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
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

-(void)showSpinner {
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:0.0];
    fadeAnim.toValue = [NSNumber numberWithFloat:1.0];
    fadeAnim.duration = 0.5;
    
    for (int i = 0; i < self.mobActionActivitySpinnerImageViews.count; i++) {
        UIImageView *img = (UIImageView*)self.mobActionActivitySpinnerImageViews[i];
        
        if (i == 0) img.layer.opacity = 1.0;
        else {
            [img.layer addAnimation:fadeAnim forKey:@"opacity"];
            img.layer.opacity = 1.0;
        }
    }
}

-(void)animateSpinners {
    // Start the spinners animating (except for 0 which is solid circle)
    CABasicAnimation *halfTurn_1;
    halfTurn_1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    halfTurn_1.fromValue = [NSNumber numberWithFloat:0];
    halfTurn_1.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
    halfTurn_1.duration = 2.5;
    halfTurn_1.repeatCount = HUGE_VALF;
    
    UIImageView *spinner1 = (UIImageView*)self.mobActionActivitySpinnerImageViews[1];
    [[spinner1 layer] addAnimation:halfTurn_1 forKey:@"180_1"];
    
    CABasicAnimation *halfTurnReverse_2;
    halfTurnReverse_2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    halfTurnReverse_2.fromValue = [NSNumber numberWithFloat:0];
    halfTurnReverse_2.toValue = [NSNumber numberWithFloat:(-(360*M_PI)/180)];
    halfTurnReverse_2.duration = 2.5;
    halfTurnReverse_2.repeatCount = HUGE_VALF;
    
    UIImageView *spinner2 = (UIImageView*)self.mobActionActivitySpinnerImageViews[2];
    [[spinner2 layer] addAnimation:halfTurnReverse_2 forKey:@"180r_2"];
    
    CABasicAnimation *halfTurn_3;
    halfTurn_3 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    halfTurn_3.fromValue = [NSNumber numberWithFloat:0];
    halfTurn_3.toValue = [NSNumber numberWithFloat:((360*M_PI)/180)];
    halfTurn_3.duration = 2.0;
    halfTurn_3.repeatCount = HUGE_VALF;
    
    UIImageView *spinner3 = (UIImageView*)self.mobActionActivitySpinnerImageViews[3];
    [[spinner3 layer] addAnimation:halfTurn_3 forKey:@"180_3"];
    
    CABasicAnimation *halfTurnReverse_4;
    halfTurnReverse_4 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    halfTurnReverse_4.fromValue = [NSNumber numberWithFloat:0];
    halfTurnReverse_4.toValue = [NSNumber numberWithFloat:(-(360*M_PI)/180)];
    halfTurnReverse_4.duration = 2.0;
    halfTurnReverse_4.repeatCount = HUGE_VALF;
    
    UIImageView *spinner4 = (UIImageView*)self.mobActionActivitySpinnerImageViews[4];
    [[spinner4 layer] addAnimation:halfTurnReverse_4 forKey:@"180r_4"];
}
- (IBAction)thumbButtonHit:(id)sender {
    self.thumbButton.enabled = NO;
    
    [self animateSpinners];
    
    [self showSpinner];
    
    [self performSelector:@selector(goToLogin:) withObject:nil afterDelay:5.0];
    
    
}

-(void)goToLogin:(id)sender {
    [self performSegueWithIdentifier:@"showMultiLoginViewController" sender:self];
}
@end
