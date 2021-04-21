/*
 *  Extension.swift
 *  SFFocusViewLayout
 *
 *  Created by tuigynbekov on 2/26/21.
 */

import UIKit
 
open class SFFocusViewLayout: UICollectionViewLayout {

    @IBInspectable open var standardHeight: CGFloat = 100
    
    @IBInspectable open var focusedHeight: CGFloat = 280
    
    @IBInspectable open var dragOffset: CGFloat = 180
    
    internal var cached = [UICollectionViewLayoutAttributes]()
    
    override open var collectionViewContentSize: CGSize {
        let contentHeight = CGFloat(numberOfItems) * dragOffset + (height - dragOffset)
        return CGSize(width: width, height: contentHeight)
    }
    
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    open override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let proposedItemIndex = round(proposedContentOffset.y / dragOffset)
        let nearestPageOffset = proposedItemIndex * dragOffset
        return CGPoint(x: 0, y: nearestPageOffset)
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return cached.filter { attributes in
            return attributes.frame.intersects(rect)
        }
    }
    
    override open func prepare() {
        cached = [UICollectionViewLayoutAttributes]()
        
        var frame = CGRect()
        var y: CGFloat = 0
        
        for item in 0..<numberOfItems {
            let indexPath = IndexPath(item: item, section: 0)
            let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            attributes.zIndex = item
            
            var height = standardHeight
            
            if indexPath.item == currentFocusedItemIndex {
                y = yOffset - standardHeight * nextItemPercentageOffset
                height = focusedHeight
            } else if indexPath.item == (currentFocusedItemIndex + 1) && indexPath.item != numberOfItems {
                let maxY = y + standardHeight
                height = standardHeight + max((focusedHeight - standardHeight) * nextItemPercentageOffset, 0)
                y = maxY - height
            } else {
                y = frame.origin.y + frame.size.height
            }
            
            frame = CGRect(x: 0, y: y, width: width, height: height)
            attributes.frame = frame
            cached.append(attributes)
            y = frame.maxY
        }
    }
    
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cached[indexPath.item]
    }
}

private extension UICollectionViewLayout {
    
    var numberOfItems: Int {
        return collectionView?.numberOfItems(inSection: 0) ?? 0
    }
    
    var width: CGFloat {
        return collectionView?.frame.width ?? 0
    }
    
    var height: CGFloat {
        return collectionView?.frame.height ?? 0
    }
    
    var yOffset: CGFloat {
        return collectionView?.contentOffset.y ?? 0
    }
}

private extension SFFocusViewLayout {
    
    var currentFocusedItemIndex: Int {
        return max(0, Int(yOffset / dragOffset))
    }
    
    var nextItemPercentageOffset: CGFloat {
        return (yOffset / dragOffset) - CGFloat(currentFocusedItemIndex)
    }
}
