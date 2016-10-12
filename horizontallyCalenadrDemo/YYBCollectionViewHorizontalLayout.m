//
//  YYBCollectionViewHorizontalLayout.m
//  YiYiBnb
//
//  Created by Onein on 9/2/16.
//  Copyright © 2016 11bnb. All rights reserved.
//

#import "YYBCollectionViewHorizontalLayout.h"
#import "UIView+Add.h"

@interface YYBCollectionViewHorizontalLayout()
@property (strong, nonatomic) NSMutableArray *allAttributes;
@end
@implementation YYBCollectionViewHorizontalLayout
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return self;
}

- (void)prepareLayout
{
    [super prepareLayout];
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(self.dateArray.count * self.collectionView.width, self.collectionView.contentSize.height);
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes
{
    if(attributes.representedElementKind != nil)
    {
        return;
    }
    
    CGFloat stride = (self.scrollDirection == UICollectionViewScrollDirectionHorizontal) ? self.collectionView.frame.size.width : self.collectionView.frame.size.height;
    
    CGFloat offset = (attributes.indexPath.section) * stride;
    
    CGFloat xCellOffset = (attributes.indexPath.item % 7) * self.itemSize.width;
    
    CGFloat yCellOffset = (attributes.indexPath.item / 7) * self.itemSize.height;
    
    if(self.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        xCellOffset += offset;
    } else {
        yCellOffset += offset;
    }
    
    attributes.frame = CGRectMake(xCellOffset, yCellOffset, self.itemSize.width, self.itemSize.height);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attr = [super layoutAttributesForItemAtIndexPath:indexPath].copy;
    [self applyLayoutAttributes:attr];
    return attr;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect].copy;
    for (UICollectionViewLayoutAttributes *attr in attributes) {
        [self applyLayoutAttributes:attr];
    }
    
    return attributes;
}

@end
