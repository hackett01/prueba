//
//  CreateCircle_CategoryDrilldownViewController.h
//  Shyft
//
//  Created by Rick Strom on 2/11/15.
//  Copyright (c) 2015 Rick Strom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CreateCircle_CategoryDrilldownTableViewCell.h"

@protocol CreateCircle_CategoryDrilldownTableViewCellDelegate <NSObject>

@optional
-(void)selectCategory:(NSString*)category;
@end

@interface CreateCircle_CategoryDrilldownViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) id <CreateCircle_CategoryDrilldownTableViewCellDelegate> delegate;

@property (nonatomic, strong) NSArray *categories;
@end
