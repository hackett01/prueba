//
//  TutorialPageViewController.m
//  Caremob
//
//  Created by Rick Strom on 1/21/16.
//  Copyright © 2016 Rick Strom. All rights reserved.
//

#import "TutorialPageViewController.h"

@interface TutorialPageViewController ()

@end

@implementation TutorialPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pageImages = @[@"caremob_tutorial_p1",@"caremob_tutorial_p2",@"caremob_tutorial_p3",@"caremob_tutorial_p4"];
    
    self.delegate = self;
    self.dataSource = self;
    
    self.pageImages = @[@"caremob_tutorial_p1",@"caremob_tutorial_p2",@"caremob_tutorial_p3",@"caremob_tutorial_p4"];
    
    
     self.pages = [[NSMutableArray alloc] init];
     
     for (int i = 0; i < self.pageImages.count; i++) {
         TutorialPageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TutorialPageContentViewController"];
         pageContentViewController.imageFile = self.pageImages[i];
         pageContentViewController.pageIndex = i;
         [self.pages addObject:pageContentViewController];
     }
     
     [self setViewControllers:@[self.pages[0]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:^(BOOL finished) {
         // Do nothinfg
     }];

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

#pragma mark - Page View Controller Data Source

-(UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    return self.pages[index];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
     viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [self.pages indexOfObject:viewController];
    
    --currentIndex;
    currentIndex = currentIndex % (self.pages.count);
    return [self.pages objectAtIndex:currentIndex];
}

-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [self.pages indexOfObject:viewController];
    
    ++currentIndex;
    currentIndex = currentIndex % (self.pages.count);
    return [self.pages objectAtIndex:currentIndex];
}

-(NSInteger)presentationCountForPageViewController:
(UIPageViewController *)pageViewController
{
    return self.pages.count;
}

-(NSInteger)presentationIndexForPageViewController:
(UIPageViewController *)pageViewController
{
    return 0;
}@end
