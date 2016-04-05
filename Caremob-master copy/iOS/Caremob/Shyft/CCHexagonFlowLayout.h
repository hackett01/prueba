//
//  CCHexagonFlowLayout.h
//  CCHexagonFlowLayout
//
//  Created by Cyril CHANDELIER on 4/8/14.
//  Copyright (c) 2014 Cyril CHANDELIER. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CCHexagonDelegateFlowLayout <UICollectionViewDelegateFlowLayout>

@end



@interface CCHexagonFlowLayout : UICollectionViewFlowLayout

// Properties
@property (nonatomic, assign) CGFloat gap;

// Delegate
 @property (nonatomic, assign) id<CCHexagonDelegateFlowLayout> delegate;

@end