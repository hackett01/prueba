//
//  TutorialPageContentViewController.m
//  Caremob
//
//  Created by Rick Strom on 1/21/16.
//  Copyright © 2016 Rick Strom. All rights reserved.
//

#import "TutorialPageContentViewController.h"

@interface TutorialPageContentViewController ()

@end

@implementation TutorialPageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.backgroundImageView.image = [UIImage imageNamed:self.imageFile];
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

@end
