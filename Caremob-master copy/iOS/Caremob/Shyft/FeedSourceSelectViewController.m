//
//  FeedSourceSelectViewController.m
//  Caremob
//
//  Created by Rick Strom on 7/8/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import "FeedSourceSelectViewController.h"

@interface FeedSourceSelectViewController ()
- (IBAction)sourceButtonHit:(id)sender;

- (IBAction)createYourOwnButtonHit:(id)sender;
@end

@implementation FeedSourceSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /// Configure the navigation bar
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"caremob_navbar_logo"]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:12.0/255.0 green:105.0/255.0 blue:148.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UIBarButtonItem *MyBackButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    MyBackButton.title = @"";
    
    NSDictionary *myBackButtonTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                                [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                [UIFont fontWithName:@"NettoOT" size:16.0f], NSFontAttributeName,
                                                nil];
    [MyBackButton setTitleTextAttributes:myBackButtonTextAttributes forState:UIControlStateNormal];
    [MyBackButton setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.backBarButtonItem = MyBackButton;
    
    /*
    // Add the user level control to the nav bar
    self.userLevelViewController = [[UserLevelControlViewController alloc] initWithNibName:@"UserLevelControlViewController" bundle:nil];
    
    [self.navigationController.navigationBar addSubview:self.userLevelViewController.view];
    
    [self.userLevelViewController setFrameRelativeTo:self.navigationController.navigationBar];
    [self.userLevelViewController initialize];
    */
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidPerformMobAction:) name:kNSNotificationMobActionWasPerformed object:nil];


    
}

-(void)back {
    
}

-(void)userDidPerformMobAction:(NSNotification*)notification {
    if (self.userLevelViewController != nil) [self.userLevelViewController userNeedsRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showFeedStoryViewController"]) {
        FeedStoryViewController *destination = (FeedStoryViewController*)segue.destinationViewController;
        
        destination.source = self.selectedSource;
    }
}


- (IBAction)sourceButtonHit:(id)sender {
    UIButton *b = (UIButton*)sender;
    
    NSLog(@"Button %ld hit", (long)b.tag);
    
    if (b.tag == 0) {
        self.selectedSource = @"humanrightswatch";
    } else if (b.tag == 1) {
        self.selectedSource = @"positivenews";
    } else if (b.tag == 2) {
        self.selectedSource = @"abcnews";
    } else if (b.tag == 3) {
        self.selectedSource = @"foxnews";
    } else if (b.tag == 4) {
        self.selectedSource = @"aljazeera";
    } else if (b.tag == 5) {
        self.selectedSource = @"unl";
    }  else if (b.tag == 6) {
        self.selectedSource = @"sunnyskyz";
    }  else if (b.tag == 7) {
        self.selectedSource = @"dailynebraskan";
    }
    
    [self performSegueWithIdentifier:@"showFeedStoryViewController" sender:self];
}

- (IBAction)createYourOwnButtonHit:(id)sender {
    [self performSegueWithIdentifier:@"showCreateMobViewController" sender:self];
}
@end
