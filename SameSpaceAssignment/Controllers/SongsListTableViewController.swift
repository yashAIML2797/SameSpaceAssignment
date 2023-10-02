//
//  SongsListTableViewController.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 28/09/23.
//

import UIKit

class SongsListTableViewController: UITableViewController {
    weak var delegate: LaunchPlayerDelegate?
    
    var songs: [Song] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        tableView.contentInset.bottom = 120 + 64
        tableView.register(SongsListTableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        songs.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! SongsListTableViewCell
        let song = songs[indexPath.item]
        
        cell.configure(with: song)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let delegate = delegate else {
            return
        }
        
        let song = songs[indexPath.item]
        
        if delegate.isShowingMinimizedPlayer {
            AudioManager.shared.stop()
            if let url = URL(string: song.url) {
                AudioManager.shared.start(itemURL: url)
            }
            delegate.addMinimizedPlayer(songs: songs, for: song)
        } else {
            delegate.launchPlayer(with: songs, startingSong: song)
        }
    }
}
