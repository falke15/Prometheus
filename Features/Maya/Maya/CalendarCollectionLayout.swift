//
//  CalendarCollectionLayout.swift
//  Maya
//
//  Created by pyretttt pyretttt on 15.01.2022.
//

import UIKit
import Maya.Objective

@objc(MAYACalendarCollectionLayout)
@objcMembers
public final class CalendarCollectionLayout: UICollectionViewLayout {
    
    private enum Constants {
        static let numberOfColumns: Int = 7
        static let baseSpacing: CGFloat = 8
        static let sectionSpacing: CGFloat = baseSpacing
    }
    
    private var shouldInvalidateCache: Bool = false
    private var attributesCache: [IndexPath: UICollectionViewLayoutAttributes] = [:]
    
    private var baseItemSize: CGSize {
        let numberOfColumns = Constants.numberOfColumns
        guard let collectionView = collectionView else {
            return .zero
        }
        
        let itemsCount = collectionView.numberOfItems(inSection: 0)
        let rowsCount = itemsCount % Constants.numberOfColumns == 0 ?
            itemsCount / numberOfColumns :
            itemsCount / numberOfColumns + 1
        
        let parentSize = collectionView.frame.size
        // - 1 + 2: -1 stands for spacings between items; + 2 stand for section insets
        let itemWidth = (parentSize.width - CGFloat(numberOfColumns - 1 + 2) * Constants.baseSpacing) / CGFloat(numberOfColumns)
        let itemHeight = (parentSize.height - CGFloat(rowsCount - 1 + 2) * Constants.baseSpacing) / CGFloat(rowsCount)
        
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
    // MARK: - UICollectionViewLayout
    
    public override var collectionViewContentSize: CGSize {
        let width = collectionView?.frame.width ?? .zero
        let height = collectionView?.frame.height ?? .zero
        
        return CGSize(width: width, height: height)
    }
    
    public override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        guard let collectionView = collectionView else { return false }

        return newBounds.size != collectionView.bounds.size
    }
    
    public override func invalidateLayout() {
        shouldInvalidateCache = true
        super.invalidateLayout()
    }
    
    public override func prepare() {
        guard let collectionView = collectionView else {
            return
        }
        
        if shouldInvalidateCache {
            attributesCache = [:]
            
            for sectionIndex in (0..<collectionView.numberOfSections) {
                for itemIndex in (0..<collectionView.numberOfItems(inSection: sectionIndex)) {
                    let indexPath = IndexPath(item: itemIndex, section: sectionIndex)
                    let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                    attributes.frame = frameForItem(at: indexPath)
                    attributesCache[indexPath] = attributes
                }
            }
            
            shouldInvalidateCache = false
        }
    }
    
    public override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = attributesCache.values.filter {
            rect.intersects($0.frame)
        }
        
        let supplementaries = attributes
            .map { $0.indexPath }
            .compactMap { layoutAttributesForSupplementaryView(ofKind: MAYABageSupplementaryViewKind, at: $0) }
        
        return attributes + supplementaries
    }
    
    public override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesCache[indexPath]
    }
    
    public override func layoutAttributesForSupplementaryView(ofKind elementKind: String,
                                                              at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let dataProvider = collectionView?.dataSource as? MAYADataSourceProvider else {
            return nil
        }
        
        if elementKind == MAYABageSupplementaryViewKind {
            guard dataProvider.getMarkedIndexPathes().contains(indexPath),
                  let cellAttributes = attributesCache[indexPath] else { return nil }
            let maxX = cellAttributes.frame.maxX
            let maxY = cellAttributes.frame.maxY
            
            let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: MAYABageSupplementaryViewKind,
                                                              with: indexPath)
            let dimension: CGFloat  = 16
            attributes.frame = CGRect(x: maxX - dimension,
                                      y: maxY - dimension,
                                      width: dimension,
                                      height: dimension)
            
            return attributes
        }
        
        return nil
    }
    
    // MARK: - Helpers
    
    private func frameForItem(at indexPath: IndexPath) -> CGRect {
        let columnPosition = indexPath.item % Constants.numberOfColumns
        let rowPosition = indexPath.item / Constants.numberOfColumns + 1
        
        let itemSize = baseItemSize
        // + Constants.baseSpacing stands for section inset
        let xOrigin = CGFloat(columnPosition) * (Constants.baseSpacing + itemSize.width) + Constants.baseSpacing
        let yOrigin = CGFloat(rowPosition - 1) * (Constants.baseSpacing + itemSize.height) + Constants.baseSpacing
        
        return CGRect(x: xOrigin,
                      y: yOrigin,
                      width: itemSize.width,
                      height: itemSize.height)
    }
}
