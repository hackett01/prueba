//
//  Follow_BaseTableViewCell.h
//  Caremob
//
//  Created by Rick Strom on 7/23/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol FollowTableViewCellDelegate <NSObject>

@optional
-(void)follow:(PFUser*)user;
@end

@interface Follow_BaseTableViewCell : UITableViewCell

@end
