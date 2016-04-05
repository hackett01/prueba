//
//  AppDelegate.m
//  Shyft
//
//  Created by Rick Strom on 11/13/14.
//  Copyright (c) 2014 Rick Strom. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
//#import <FacebookSDK/FacebookSDK.h>
#import <Crashlytics/Crashlytics.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "CRToast.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [Crashlytics startWithAPIKey:@"ecd0787d401f2a87381220e213efd84a497ae33a"];
    
    // Connect to Parse
    [Parse setApplicationId:@"1o3GD3EqlVDROaQE6utk4kumjT0ewrtfdFtLk2fY"
                  clientKey:@"bQOoHF6Ihhwahc8AhNNrVsH0U0tPC8K9Zo7Gp5KL"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Make sure the app is aware of PFImageView (minor hack to use this class in Storyboard)
    [PFImageView class];
    
    // Initialize facebook utils
    [PFFacebookUtils initializeFacebookWithApplicationLaunchOptions:launchOptions];
    //[PFFacebookUtils initializeFacebook];
    
    // Set the default ACL
    PFACL *defaultACL = [PFACL ACL];
    [defaultACL setPublicReadAccess:YES];
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];

    /*
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    */
    
    // Register for remote notifications
    
    // OLD: moved to activity screen, with check for enabled state
    /*
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        [application registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeNewsstandContentAvailability)];
    }
     */
    
    /* enumerate fonts in project
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
    */
    
    // If we opened from a push notification, switch to the activity tab
    if (launchOptions != nil) {
        if ([launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] != nil) {
            //[[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationShouldShowActivityTab object:nil];
            RootViewController *rootView = (RootViewController*)self.window.rootViewController;
        
            if (rootView != nil) {
                [rootView switchToActivityTab];
         
            }
        }
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global",@"friendJoins",@"circles" ];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //[PFPush handlePush:userInfo];
    
    NSString *notificationText = userInfo[@"aps"][@"alert"];
    NSString *notificationCategoryContext = userInfo[@"categoryContext"];
    
    if (notificationCategoryContext == nil) notificationCategoryContext = @"generic";
    
    UIColor *notificationBGColor;
    UIImage *notificationImage;
    

    notificationImage = [UIImage imageNamed:[NSString stringWithFormat:@"notification_icon_%@", notificationCategoryContext]];
    
    if (notificationCategoryContext == nil) {
        notificationBGColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1.0];
    } else if ([notificationCategoryContext isEqualToString:@"celebration"]) {
        notificationBGColor = [UIColor colorWithRed:245.0/255.0 green:166.0/255.0 blue:35.0/255.0 alpha:1.0];
    }  else if ([notificationCategoryContext isEqualToString:@"support"]) {
        notificationBGColor = [UIColor colorWithRed:100.0/255.0 green:187.0/255.0 blue:0.0/255.0 alpha:1.0];
    } else if ([notificationCategoryContext isEqualToString:@"mourning"]) {
        notificationBGColor = [UIColor colorWithRed:189.0/255.0 green:16.0/255.0 blue:224.0/255.0 alpha:1.0];
    } else if ([notificationCategoryContext isEqualToString:@"peace"]) {
        notificationBGColor = [UIColor colorWithRed:61.0/255.0 green:200.0/255.0 blue:169.0/255.0 alpha:1.0];
    } else if ([notificationCategoryContext isEqualToString:@"protest"]) {
        notificationBGColor = [UIColor colorWithRed:208.0/255.0 green:2.0/255.0 blue:27.0/255.0 alpha:1.0];
    } else if ([notificationCategoryContext isEqualToString:@"empathy"]) {
        notificationBGColor = [UIColor colorWithRed:53.0/255.0 green:135.0/255.0 blue:192.0/255.0 alpha:1.0];
    } else {
        notificationBGColor = [UIColor colorWithRed:65.0/255.0 green:209.0/255.0 blue:240.0/255.0 alpha:1.0];
    }
    
    NSDictionary *options = @{
                              kCRToastTextKey : notificationText,
                              kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
                              kCRToastBackgroundColorKey : notificationBGColor,
                              kCRToastFontKey : [UIFont fontWithName:@"NettoOT" size:16.0],
                              kCRToastTextColorKey : [UIColor whiteColor],
                              kCRToastImageKey : notificationImage,
                              kCRToastAnimationInTypeKey : @(CRToastAnimationTypeLinear),
                              kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeLinear),
                              kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionTop),
                              kCRToastNotificationTypeKey: @(CRToastTypeNavigationBar)
                              };
    
    [CRToastManager showNotificationWithOptions:options completionBlock:^{
        NSLog(@"Showed notification");
    }];
    
    [[Sound soundNamed:kSoundNotificationAlert] play];
    
    // Post a notification that an action was performed
    // This notification should be received by the UserLevelControlView if one is active, causing it to refresh the uer and show the new user level and points
    NSLog(@"Posting notification");
    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationMobActionWasPerformed object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNSNotificationNewActivityIsAvailable object:nil];
    
    if (application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground) {
        //opened from a push notification when the app was on background
        RootViewController *rootView = (RootViewController*)self.window.rootViewController;
        
        if (rootView != nil) {
            [rootView switchToActivityTab];
            
        }
    }


}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //[FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //[[PFFacebookUtils session] close];
}

//- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
//    // attempt to extract a token from the url
//    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
//}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

@end
