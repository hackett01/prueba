//
//  ShareViewController.h
//  Shyft
//
//  Created by Rick Strom on 11/21/14.
//  Copyright (c) 2014 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

@interface ShareViewController : UIViewController
@property (nonatomic, strong) NSString *shareMessageText;
@property (nonatomic, strong) UIImage *shareImage;
@end
