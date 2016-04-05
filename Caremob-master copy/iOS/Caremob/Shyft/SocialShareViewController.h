//
//  SocialShareViewController.h
//  Shyft
//
//  Created by Rick Strom on 2/5/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "CareMobConstants.h"
#import "CareMobHelper.h"

@interface SocialShareViewController : UIViewController <MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>
@property (nonatomic, weak) PFObject *careMob;
@property (nonatomic, weak) PFObject *subMob;
@property (nonatomic, weak) PFObject *mobAction;
@property (nonatomic, strong) UIImage *heatmapImage;
@end
