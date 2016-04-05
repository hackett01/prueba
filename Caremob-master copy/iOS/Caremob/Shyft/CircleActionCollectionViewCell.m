//
//  CircleActionCollectionViewCell.m
//  Shyft
//
//  Created by Rick Strom on 2/4/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import "CircleActionCollectionViewCell.h"

@implementation CircleActionCollectionViewCell
-(void)initializeWithUsers:(NSArray*)userList andDelay:(float)delay andShowTime:(float)showTime {
    self.userList = [NSArray arrayWithArray:userList];
    self.delay = delay;
    self.showTime = showTime;
    
    //self.circleUserImageView.frame = CGRectMake(self.circleUserImageView.frame.origin.x, self.circleUserImageView.frame.origin.y, 0.0,0.0);
    //self.circleFriendOverlayImageView.frame = CGRectMake(self.circleUserImageView.frame.origin.x, self.circleUserImageView.frame.origin.y, 0.0,0.0);

    self.circleUserImageView.transform = CGAffineTransformScale(self.circleUserImageView.transform, 0.0, 0.0);
    self.circleFriendOverlayImageView.transform = CGAffineTransformMakeScale(0.0, 0.0);
    
}


-(void)show {
    self.isShowing = YES;
    
    [self performSelector:@selector(showNewUser) withObject:nil afterDelay:self.delay];
}

-(void)hide {
    [self.contentView.layer removeAllAnimations];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    
    self.isShowing = NO;
    [UIView animateWithDuration:0.5 delay:self.delay options:UIViewAnimationOptionCurveEaseIn animations:^{
    //[UIView animateWithDuration:1.0 delay:self.delay usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
        //self.circleUserImageView.frame = CGRectMake(self.circleUserImageView.frame.origin.x, self.circleUserImageView.frame.origin.y, 0.0,0.0);
        //self.circleFriendOverlayImageView.frame = CGRectMake(self.circleUserImageView.frame.origin.x, self.circleUserImageView.frame.origin.y, 0.0,0.0);
        self.circleUserImageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        self.circleFriendOverlayImageView.transform = CGAffineTransformMakeScale(0.01, 0.01);
        
    } completion:^(BOOL finished) {
        self.circleUserImageView.transform = CGAffineTransformScale(self.circleUserImageView.transform, 0.0, 0.0);
        self.circleFriendOverlayImageView.transform = CGAffineTransformScale(self.circleFriendOverlayImageView.transform, 0.0, 0.0);
    }];
}

-(void)showNewUser {
    if (!self.isShowing) {
        [self hide];
        return;
    }
    
    if (self.userList == nil || self.userList.count == 0) return;
    
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
    //[UIView animateWithDuration:1.0 animations:^{
        //self.circleUserImageView.frame = CGRectMake(self.circleUserImageView.frame.origin.x, self.circleUserImageView.frame.origin.y, 0.0,0.0);
        //self.circleFriendOverlayImageView.frame = CGRectMake(self.circleUserImageView.frame.origin.x, self.circleUserImageView.frame.origin.y, 0.0,0.0);
        self.circleUserImageView.transform = CGAffineTransformScale(self.circleUserImageView.transform, 0.01, 0.01);
        self.circleFriendOverlayImageView.transform = CGAffineTransformScale(self.circleFriendOverlayImageView.transform, 0.01, 0.01);

    } completion:^(BOOL finished) {
        if (finished) {
            self.circleUserImageView.transform = CGAffineTransformScale(self.circleUserImageView.transform, 0.0, 0.0);
            self.circleFriendOverlayImageView.transform = CGAffineTransformScale(self.circleFriendOverlayImageView.transform, 0.0, 0.0);
        
            PFUser *currentUser = self.userList[self.currentUserIndex];
            PFFile *currentUserProfileImage = (PFFile*)[currentUser objectForKey:kUserFieldProfileImageKey];
        
            if ([currentUserProfileImage isDataAvailable]) {
                self.circleUserImageView.image = [UIImage imageWithData:[currentUserProfileImage getData]];
                [self animateInRepeating];
            } else {
                [currentUserProfileImage getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (error) {
                    
                    } else {
                        self.circleUserImageView.image = [UIImage imageWithData:data];
                        [self animateInRepeating];
                    }
                }];
            }
        } else {
            self.circleUserImageView.transform = CGAffineTransformScale(self.circleUserImageView.transform, 0.0, 0.0);
            self.circleFriendOverlayImageView.transform = CGAffineTransformScale(self.circleFriendOverlayImageView.transform, 0.0, 0.0);
        }
        
        /*
        [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{

            //self.circleUserImageView.frame = CGRectMake(self.circleUserImageView.frame.origin.x, self.circleUserImageView.frame.origin.y, 42.0,42.0);
            //self.circleFriendOverlayImageView.frame = CGRectMake(self.circleUserImageView.frame.origin.x, self.circleUserImageView.frame.origin.y, 44.0,44.0);
            self.circleUserImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            self.circleFriendOverlayImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);


        } completion:^(BOOL finished) {
            if (self.userList.count > 1) {
                self.currentUserIndex++;
                if (self.currentUserIndex >= self.userList.count) self.currentUserIndex = 0;
                
                [self performSelector:@selector(showNewUser) withObject:nil afterDelay:self.showTime];
            }
        }];
         */
    }];
    
}

-(void)animateInRepeating {
    [UIView animateWithDuration:1.0 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
            
        self.circleUserImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        self.circleFriendOverlayImageView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        
    } completion:^(BOOL finished) {
        if (finished) {
            if (self.userList.count > 1) {
                self.currentUserIndex++;
                if (self.currentUserIndex >= self.userList.count) self.currentUserIndex = 0;
            
                [self performSelector:@selector(showNewUser) withObject:nil afterDelay:self.showTime];
            }
        } else {
            self.circleUserImageView.transform = CGAffineTransformScale(self.circleUserImageView.transform, 0.0, 0.0);
            self.circleFriendOverlayImageView.transform = CGAffineTransformScale(self.circleFriendOverlayImageView.transform, 0.0, 0.0);
        }
     }];
}
@end
