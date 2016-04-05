//
//  CircularCollectionViewLayout.m
//  Collections
//
//  Created by Edward Ashak on 12/17/12.
//  Copyright (c) 2012 EdwardIshaq. All rights reserved.
//

#import "CircularCollectionViewLayout.h"

@implementation CircularCollectionViewLayout

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _numItems = 0;
        angle = 0;
    }
    return self;
}
- (void)prepareLayout {
    [super prepareLayout];

    //calculate the degree increment
    //360 / items_count
    if (self.numItems) {
        angle = (CGFloat)2*M_PI/self.numItems;
    }
    else{
        angle = 0;
    }
}

- (void)setNumItems:(NSUInteger)numItems {
    _numItems = numItems;
    [self.collectionView reloadData];
    [self invalidateLayout];
}

- (CGSize)collectionViewContentSize {
    CGRect collectionFrame = self.collectionView.frame;
    return collectionFrame.size;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    if (self.numItems == 0) {
        return nil;
    }
    
    CGRect collectionFrame   = self.collectionView.frame;
    CGPoint center = CGPointMake(collectionFrame.size.width/2, collectionFrame.size.height/2);
    
    CGFloat R  = fminf(collectionFrame.size.width, collectionFrame.size.height)/2.0 - 100;
    
    NSMutableArray *array = [NSMutableArray new];
    CGFloat x,y,alpha;
    UICollectionViewLayoutAttributes *attrs;
    int z=0;
    for (int i=0; i<self.numItems; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        alpha = i * angle;
        x = floorf(R * cosf(alpha) + center.x);
        y = floorf(R * cosf(M_PI_2-alpha) + center.y);
        attrs.center = CGPointMake(x, y);
        attrs.size = CGSizeMake(100, 100);
        
        if ((alpha > 0 && alpha <= M_PI_2) || (alpha > 1.5*M_PI && alpha <= 2*M_PI)) {
            attrs.zIndex = z++;
        }
        else if (alpha > M_PI_2 && alpha <= 1.5*M_PI)
        {
            attrs.zIndex = z--;
        }

        [array addObject:attrs];
    }
    
    NSArray *result = [NSArray arrayWithArray:array];

    return result;
}

@end
