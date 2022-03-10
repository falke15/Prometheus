//
//  TransformCollectionLayout.m
//  Maya
//
//  Created by pyretttt pyretttt on 06.03.2022.
//

#import "TransformCollectionLayout.h"

static const NSNumber *itemSpace = @(24);

@interface TransformCollectionLayout()

@property(nonatomic)NSMutableDictionary<NSIndexPath*, UICollectionViewLayoutAttributes*> *attributesCache;

@end

@implementation TransformCollectionLayout

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.attributesCache = [NSMutableDictionary new];
    }
    
    return self;
}

- (CGSize)collectionViewContentSize
{
    CGSize parentSize = self.collectionView.frame.size;
    CGFloat width = parentSize.width;
    CGFloat itemsCount = (CGFloat) self.attributesCache.count;
    CGFloat totalWidth = (width + [itemSpace doubleValue]) * itemsCount - [itemSpace doubleValue];
    
    return CGSizeMake(totalWidth, parentSize.height);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (void)prepareLayout
{
    for (int section = 0; section < self.collectionView.numberOfSections; section++)
    {
        for (int item = 0; item < [self.collectionView numberOfItemsInSection:section]; item++)
        {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath: indexPath];
            attributes.frame = [self rectForItemAtIndexPath:indexPath];
            [self transformAttributes:attributes];
            [self.attributesCache setObject:attributes forKey:indexPath];
        }
    }
}

- (CGFloat)translationAlongCenter:(CGRect)rect
{
    CGFloat xOffset = [self.collectionView contentOffset].x;
    CGFloat xCenter = self.collectionView.frame.size.width / 2.0 + xOffset;
    
    CGFloat translation = rect.size.width / 2.0 + rect.origin.x - xCenter;
    CGFloat translationRelative = 2 * translation / self.collectionView.frame.size.width;
    
    return -translationRelative;
}

- (CGFloat)relativeTranslationToRadians:(CGFloat)translation
{
    return 60 * M_PI * translation / 180;
}

- (void)transformAttributes:(UICollectionViewLayoutAttributes *)attributes
{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0 / 2000;
    CGFloat angle = [self relativeTranslationToRadians: [self translationAlongCenter:attributes.frame]];
    transform = CATransform3DRotate(transform, angle, 0.0, 1.0, 0.0);
    attributes.transform3D = transform;
}

- (CGRect)rectForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize parentSize = self.collectionView.frame.size;
    CGFloat width = parentSize.width;
    CGFloat xOffset = (width + [itemSpace doubleValue]) * indexPath.item;
    CGRect itemRect = CGRectMake(xOffset, [itemSpace doubleValue], width, parentSize.height - [itemSpace doubleValue] * 2);
    
    return itemRect;
}

-(NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray<UICollectionViewLayoutAttributes *> * result = [NSMutableArray new];
    for (UICollectionViewLayoutAttributes *item in self.attributesCache.allValues)
    {
        if (CGRectIntersectsRect(item.frame, rect))
        {
            [result addObject:item];
        }
    }
    
    return [result copy];
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
                                 withScrollingVelocity:(CGPoint)velocity
{
    CGFloat derivedOffsetX = CGFLOAT_MAX;
    CGFloat proposedCenterX = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2);
    CGRect proposedRect = CGRectMake(proposedContentOffset.x,
                                     16.f,
                                     CGRectGetWidth(self.collectionView.bounds),
                                     CGRectGetHeight(self.collectionView.bounds));
    
    NSArray<UICollectionViewLayoutAttributes *> *attributes = [self layoutAttributesForElementsInRect:proposedRect];
    for (UICollectionViewLayoutAttributes *attribute in attributes)
    {
        if (attribute.representedElementCategory != UICollectionElementCategoryCell) continue;
        CGFloat itemCenterX = CGRectGetMidX(attribute.frame);
        if (fabs(itemCenterX - proposedCenterX) < fabs(derivedOffsetX))
        {
            derivedOffsetX = itemCenterX - proposedCenterX;
        }
    }
    
    return CGPointMake(proposedContentOffset.x + derivedOffsetX, proposedContentOffset.y);
}

@end
