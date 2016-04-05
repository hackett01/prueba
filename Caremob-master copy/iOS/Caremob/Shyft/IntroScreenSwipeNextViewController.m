//
//  IntroScreenSwipeNextViewController.m
//  Shyft
//
//  Created by Rick Strom on 11/20/14.
//  Copyright (c) 2014 Rick Strom. All rights reserved.
//

#import "IntroScreenSwipeNextViewController.h"

@interface IntroScreenSwipeNextViewController ()

@end

@implementation IntroScreenSwipeNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    
    UISwipeGestureRecognizer *swipeLeftGesture=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGesture:)];
    [self.view addGestureRecognizer:swipeLeftGesture];
    swipeLeftGesture.direction=UISwipeGestureRecognizerDirectionLeft;
    
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

-(void)handleSwipeGesture:(UIGestureRecognizer *) sender
{
    NSUInteger touches = sender.numberOfTouches;
    if (touches == 1)
    {
        if (sender.state == UIGestureRecognizerStateEnded)
        {
            //Add view controller here
            [self performSegueWithIdentifier:@"showNextViewController" sender:self];
        }
    }
}

@end
