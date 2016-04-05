//
//  IntroScreenCloseModalWithButtonViewController.m
//  Shyft
//
//  Created by Rick Strom on 11/20/14.
//  Copyright (c) 2014 Rick Strom. All rights reserved.
//

#import "IntroScreenCloseModalWithButtonViewController.h"

@interface IntroScreenCloseModalWithButtonViewController ()

- (IBAction)closeButtonHit:(id)sender;

@end

@implementation IntroScreenCloseModalWithButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
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
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        // Do nothing, just dismiss
    }];

}
@end
