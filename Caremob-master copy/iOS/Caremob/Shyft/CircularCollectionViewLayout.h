//
//  CircularCollectionViewLayout.h
//  Collections
//
//  Created by Edward Ashak on 12/17/12.
//  Copyright (c) 2012 EdwardIshaq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircularCollectionViewLayout : UICollectionViewLayout {
    @private
    CGFloat angle;
}

@property (nonatomic, assign) NSUInteger numItems;
@end
