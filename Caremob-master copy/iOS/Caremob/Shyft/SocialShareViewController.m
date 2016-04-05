//
//  SocialShareViewController.m
//  Shyft
//
//  Created by Rick Strom on 2/5/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import "SocialShareViewController.h"

@interface SocialShareViewController ()
@property (weak, nonatomic) IBOutlet UIView *sharableMediaObjectView;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UIImageView *subMobCategoryImageView;
@property (weak, nonatomic) IBOutlet UIImageView *heatmapImageView;


@property (weak, nonatomic) IBOutlet UILabel *totalMobActionsLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalMobValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobActionSummaryLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;
@property (weak, nonatomic) IBOutlet UILabel *careMobTitleLabel;


- (IBAction)facebookShareButtonHit:(id)sender;
- (IBAction)twitterShareButtonHit:(id)sender;
- (IBAction)mailShareButtonHit:(id)sender;

@end

@implementation SocialShareViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Configure the navigation bar
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"caremob_navbar_logo"]];
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:12.0/255.0 green:105.0/255.0 blue:148.0/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTranslucent:NO];


}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self presentCircleInfo];    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)presentCircleInfo {
    if (self.careMob != nil && self.subMob != nil && self.mobAction != nil) {
        //self.careMobImageView.file = (PFFile*)[self.careMob objectForKey:kCareMobImageKey];
        //[self.careMobImageView loadInBackground];
        
        self.careMobTitleLabel.text = (NSString*)[self.careMob objectForKey:kCareMobTitleKey];
        
        NSString *subMobCategory = (NSString*)[self.subMob objectForKey:kSubMobCategoryKey];
        self.subMobCategoryImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"caremob_smo_%@", subMobCategory]];
        
        //PFObject *userObject = (PFObject*)[PFUser currentUser];
        //NSString *userName = [userObject objectForKey:kUserFieldNameKey];
        
        //float timeSpentInSubMob = [[self.mobAction objectForKey:kMobActionValueKey] doubleValue];
        
        
        //int timeSpentInSubMobMinutes = (int)timeSpentInSubMob / 60;
        //int timeSpentInSubMobSeconds = (int)(timeSpentInSubMob - 60 * timeSpentInSubMobMinutes);

        NSNumber *totalMobActions = (NSNumber*)[self.subMob objectForKey:kSubMobTotalMobActionsKey];
        NSNumber *totalMobActionValue = (NSNumber*)[self.subMob objectForKey:kSubMobTotalMobActionValueKey];
        
        //NSString *summaryString;
        NSString *timeString = [CareMobHelper timeToString:[totalMobActionValue doubleValue]];
        
        //if (timeSpentInSubMobMinutes > 0) timeString = [NSString stringWithFormat:@"%dm %ds", timeSpentInSubMobMinutes, timeSpentInSubMobSeconds];
        //else timeString = [NSString stringWithFormat:@"%ds", timeSpentInSubMobSeconds];
        
        //summaryString = [NSString stringWithFormat:@"%@ spent %@ in a mob of %@", userName, timeString, subMobCategory];
        self.mobActionSummaryLabel.text = [subMobCategory uppercaseString];
        
        
        self.totalMobActionsLabel.text = [NSString stringWithFormat:@"%d", [totalMobActions intValue]];
        self.totalMobValueLabel.text = [NSString stringWithFormat:@"%@", timeString];
        
        if (self.heatmapImage != nil) self.heatmapImageView.image = self.heatmapImage;
        
        NSString *source = [self.careMob objectForKey:kCareMobSourceKey];
        PFObject *sourceUser = (PFObject*)[self.careMob objectForKey:kCareMobSourceUserKey];
        
        if (source != nil) {
            NSString *sourceString = @"Other";
            NSString *formattedDateString = @"Today";
        
            if ([source isEqualToString:@"theguardian_world_protest"]) source = @"theguardian";
            
            sourceString = [CareMobHelper feedSourceValueToPrintableString:source];
        
            NSDateFormatter *nowDateFormatter = [[NSDateFormatter alloc] init];
            [nowDateFormatter setDateFormat:@"MMMM d, yyyy"];
            formattedDateString = [nowDateFormatter stringFromDate:self.careMob.createdAt];
        
            self.sourceLabel.text = [NSString stringWithFormat:@"Source: %@, %@", sourceString, formattedDateString];
        } else if (sourceUser != nil) {
            NSString *sourceUserUsername = (NSString*)[sourceUser objectForKey:kUserFieldUsernameKey];
            
            NSDateFormatter *nowDateFormatter = [[NSDateFormatter alloc] init];
            [nowDateFormatter setDateFormat:@"MMMM d, yyyy"];
            NSString *dateString = [nowDateFormatter stringFromDate:self.careMob.createdAt];
            
            self.sourceLabel.text = [NSString stringWithFormat:@"Source: %@, %@", sourceUserUsername, dateString];
        } else {
            self.sourceLabel.text = @"";
        }

        
    }

    
}

- (UIImage *)captureScreenInRect:(CGRect)captureFrame {
    CALayer *layer;
    layer = self.sharableMediaObjectView.layer;

    UIGraphicsBeginImageContext(captureFrame.size);
    CGContextClipToRect (UIGraphicsGetCurrentContext(),captureFrame);
    [layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenImage;
}


- (IBAction)facebookShareButtonHit:(id)sender {
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
        
        float timeSpentInSubMob = [[self.mobAction objectForKey:kMobActionValueKey] floatValue];
        int timeSpentInSubMobMinutes = (int)timeSpentInSubMob / 60;
        int timeSpentInSubMobSeconds = (int)(timeSpentInSubMob - 60 * timeSpentInSubMobMinutes);
        
        NSString *subMobCategory = (NSString*)[self.subMob objectForKey:kSubMobCategoryKey];
        NSString *mobTitle = (NSString*)[self.careMob objectForKey:kCareMobTitleKey];
        
        NSString *summaryString;
        NSString *timeString;
        
        if (timeSpentInSubMobMinutes > 0) timeString = [NSString stringWithFormat:@"%dm %ds", timeSpentInSubMobMinutes, timeSpentInSubMobSeconds];
        else timeString = [NSString stringWithFormat:@"%ds", timeSpentInSubMobSeconds];
        

        summaryString = [NSString stringWithFormat:@"I just united in a %@ mob for %@", subMobCategory, mobTitle];
        
        [composeViewController setInitialText:summaryString];

        CGRect screenRect = self.sharableMediaObjectView.layer.bounds;
        UIImage *screenshot = [self captureScreenInRect:CGRectMake(0.0, 0.0, screenRect.size.width, screenRect.size.height)];

        [composeViewController addImage:screenshot];
        
        [self presentViewController:composeViewController animated:YES completion:Nil];
        
    }

}

- (IBAction)twitterShareButtonHit:(id)sender {
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

        float timeSpentInSubMob = [[self.mobAction objectForKey:kMobActionValueKey] floatValue];
        int timeSpentInSubMobMinutes = (int)timeSpentInSubMob / 60;
        int timeSpentInSubMobSeconds = (int)(timeSpentInSubMob - 60 * timeSpentInSubMobMinutes);
        
        NSString *subMobCategory = (NSString*)[self.subMob objectForKey:kSubMobCategoryKey];
        NSString *mobTitle = (NSString*)[self.careMob objectForKey:kCareMobTitleKey];
        
        NSString *summaryString;
        NSString *timeString;
        
        if (timeSpentInSubMobMinutes > 0) timeString = [NSString stringWithFormat:@"%dm %ds", timeSpentInSubMobMinutes, timeSpentInSubMobSeconds];
        else timeString = [NSString stringWithFormat:@"%ds", timeSpentInSubMobSeconds];
        
        summaryString = [NSString stringWithFormat:@"I just united in a %@ mob for %@", subMobCategory, mobTitle];
        [composeViewController setInitialText:summaryString];
        
        CGRect screenRect = self.sharableMediaObjectView.layer.bounds;
        UIImage *screenshot = [self captureScreenInRect:CGRectMake(0.0, 0.0, screenRect.size.width, screenRect.size.height)];

        [composeViewController addImage:screenshot];
        
        [self presentViewController:composeViewController animated:YES completion:Nil];
        
    }

}

- (IBAction)mailShareButtonHit:(id)sender {
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
    mailController.mailComposeDelegate = self;
    
    float timeSpentInSubMob = [[self.mobAction objectForKey:kMobActionValueKey] floatValue];
    int timeSpentInSubMobMinutes = (int)timeSpentInSubMob / 60;
    int timeSpentInSubMobSeconds = (int)(timeSpentInSubMob - 60 * timeSpentInSubMobMinutes);
    
    NSString *subMobCategory = (NSString*)[self.subMob objectForKey:kSubMobCategoryKey];
    NSString *mobTitle = (NSString*)[self.careMob objectForKey:kCareMobTitleKey];
    
    NSString *summaryString;
    NSString *timeString;
    
    if (timeSpentInSubMobMinutes > 0) timeString = [NSString stringWithFormat:@"%dm %ds", timeSpentInSubMobMinutes, timeSpentInSubMobSeconds];
    else timeString = [NSString stringWithFormat:@"%ds", timeSpentInSubMobSeconds];
    
    //summaryString = [NSString stringWithFormat:@"I spent %@ in a mob of %@", timeString, subMobCategory];
    summaryString = [NSString stringWithFormat:@"I just united in a %@ mob for %@", subMobCategory, mobTitle];
    
    [mailController setMessageBody:summaryString isHTML:NO];
    [mailController setSubject:summaryString];
    
    CGRect screenRect = self.sharableMediaObjectView.layer.bounds;
    UIImage *screenshot = [self captureScreenInRect:CGRectMake(0.0, 0.0, screenRect.size.width, screenRect.size.height)];

    [mailController addAttachmentData:UIImagePNGRepresentation(screenshot) mimeType:@"image/png" fileName:@"image.png"];
    
    [self presentViewController:mailController animated:YES completion:^{
        // Do nothng

    }];

}

#pragma mark - MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result {
    
    // We don't really need to do anything except dismiss the composer
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    // We don't really need to do anything except dismiss the composer
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
