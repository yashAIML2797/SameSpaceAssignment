//
//  CoverFlowViewController.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 29/09/23.
//

import UIKit

class CoverFlowViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
    var didLaunch = false
    
    init() {
        let layout = CoverFlowViewLayout()
        layout.scrollDirection = .horizontal
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        
        collectionView.register(CoverFlowCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let inset: CGFloat = (collectionView.frame.width * 0.5) - (304 * 0.5)
        collectionView.contentInset.left =  inset
        collectionView.contentInset.right = inset
        
        if !didLaunch {
            if let parent = parent as? PlayerViewController,
               let currentSong = parent.currentPlayingSong,
               let index = parent.songs.firstIndex(where: {$0.id == currentSong.id}),
               let layout = collectionView.collectionViewLayout as? CoverFlowViewLayout
            {
                collectionView.contentOffset.x = layout.getTargetOffsetX(for: index)
                layout.currentItemIdex = index
            }
            didLaunch = true
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let parent = parent as? PlayerViewController {
            return parent.songs.count
        }
        return .zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CoverFlowCell
        if let parent = parent as? PlayerViewController {
            let song = parent.songs[indexPath.item]
            cell.configure(with: song.cover)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: 304, height: 304)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        16
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if let layout = collectionView.collectionViewLayout as? CoverFlowViewLayout {
            layout.previousItemIndex = layout.getCellIndex(from: scrollView.contentOffset)
        }
    }
    
    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let layout = collectionView.collectionViewLayout as? CoverFlowViewLayout,
           let parent = parent as? PlayerViewController
        {
            if layout.currentItemIdex >= 0 && layout.currentItemIdex < parent.songs.count {
                let song = parent.songs[layout.currentItemIdex]
                parent.currentPlayingSong = song
                parent.configure(with: song)
                parent.play()
            }
        }
    }
}
