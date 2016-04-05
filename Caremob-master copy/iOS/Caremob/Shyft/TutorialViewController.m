//
//  TutorialViewController.m
//  Caremob
//
//  Created by Rick Strom on 1/21/16.
//  Copyright © 2016 Rick Strom. All rights reserved.
//

#import "TutorialViewController.h"

@interface TutorialViewController ()
@property (weak, nonatomic) IBOutlet UIView *containerView;

- (IBAction)closeButtonHit:(id)sender;
@end

@implementation TutorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

}

-(BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
 - (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     /*
     if ([segue.identifier isEqualToString: @"pageViewControllerEmbed"]) {
         self.pageImages = @[@"caremob_tutorial_p1",@"caremob_tutorial_p2",@"caremob_tutorial_p3",@"caremob_tutorial_p4"];
         
         self.pageViewController = (UIPageViewController *)segue.destinationViewController;

         self.pageViewController.delegate = self;
         self.pageViewController.dataSource = self;

         
         NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
         
         for (int i = 0; i < 1; i++) {
             TutorialPageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialPageContentViewController"];
             pageContentViewController.imageFile = self.pageImages[i];
             pageContentViewController.pageIndex = i;
             [viewControllers addObject:pageContentViewController];
         }
         
         [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
             // Do nothinfg
         }];
         
     }
     */
 }


- (IBAction)closeButtonHit:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        // Do nothing
    }];
}
@end
