//
//  CoverFlowViewLayout.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 29/09/23.
//

import UIKit

class CoverFlowViewLayout: UICollectionViewFlowLayout {
    
    var previousItemIndex = 0
    var currentItemIdex = 0
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        var contentOffset = super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
        
        var cellIndex = previousItemIndex
        let targetCellIndex = getCellIndex(from: contentOffset)
        
        if abs(velocity.x) > 0.5 {
            cellIndex += (velocity.x > 0 ? 1 : -1)
        } else {
            if targetCellIndex > previousItemIndex {
                cellIndex += 1
            } else if targetCellIndex < previousItemIndex {
                cellIndex -= 1
            }
        }
        
        contentOffset.x = getTargetOffsetX(for: cellIndex)
        currentItemIdex = cellIndex
        
        return contentOffset

    }
    
    func getCellIndex(from contentOffset: CGPoint) -> Int {
        guard let collectionView = collectionView else {
            return .zero
        }
        
        let temp = (contentOffset.x + collectionView.contentInset.left) / (304 + 16)
        let index = Int(round(temp))
        
        return index
    }
    
    func getTargetOffsetX(for index: Int) -> CGFloat {
        guard let collectionView = collectionView else {
            return .zero
        }
        
        let targetOffsetX = CGFloat((304 + 16) * index) - collectionView.contentInset.left
        return targetOffsetX
    }
}
