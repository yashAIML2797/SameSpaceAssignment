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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
//        if let parent = parent as? PlayerViewController,
//           let delegate = parent.delegate,
//           let currentSong = parent.currentPlayingSong,
//           let index = delegate.songs.firstIndex(where: {$0.id == currentSong.id}),
//           let layout = collectionView.collectionViewLayout as? CoverFlowViewLayout
//        {
//            collectionView.contentOffset.x = layout.getTargetOffsetX(for: index)
//        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let inset: CGFloat = (collectionView.frame.width * 0.5) - (304 * 0.5)
        collectionView.contentInset.left =  inset
        collectionView.contentInset.right = inset
        
        if !didLaunch {
            if let parent = parent as? PlayerViewController,
               let delegate = parent.delegate,
               let currentSong = parent.currentPlayingSong,
               let index = delegate.songs.firstIndex(where: {$0.id == currentSong.id}),
               let layout = collectionView.collectionViewLayout as? CoverFlowViewLayout
            {
                collectionView.contentOffset.x = layout.getTargetOffsetX(for: index)
            }
            didLaunch = true
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let parent = parent as? PlayerViewController {
            return parent.delegate?.songs.count ?? .zero
        }
        return .zero
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CoverFlowCell
        if let parent = parent as? PlayerViewController, let delegate = parent.delegate {
            let song = delegate.songs[indexPath.item]
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
            layout.currentDisplayItemIndex = layout.getCellIndex(from: scrollView.contentOffset)
        }
    }
}
