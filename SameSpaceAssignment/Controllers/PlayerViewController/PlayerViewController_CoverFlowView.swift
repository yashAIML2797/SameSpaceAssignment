//
//  PlayerViewController_CoverFlowView.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 02/10/23.
//

import UIKit

extension PlayerViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func setupCoverFlowView() {
        view.addSubview(coverFlowView)
        coverFlowView.anchor(
            top:        view.topAnchor,
            leading:    view.leadingAnchor,
            trailing:   view.trailingAnchor,
            height:     304,
            inset:      .init(top: 146, left: 0, bottom: 0, right: 0)
        )
        coverFlowView.dataSource = self
        coverFlowView.delegate = self
        
        coverFlowView.register(CoverFlowCell.self, forCellWithReuseIdentifier: "cellID")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! CoverFlowCell
        let song = songs[indexPath.item]
        cell.configure(with: song.cover)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 304, height: 304)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let layout = coverFlowView.collectionViewLayout as? CoverFlowViewLayout {
            layout.previousItemIndex = layout.getCellIndex(from: scrollView.contentOffset)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let layout = coverFlowView.collectionViewLayout as? CoverFlowViewLayout {
            if layout.currentItemIdex >= 0 && layout.currentItemIdex < songs.count {
                let song = songs[layout.currentItemIdex]
                currentPlayingSong = song
                configure(with: song)
                start()
            }
        }
    }
}
