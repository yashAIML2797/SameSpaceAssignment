//
//  SongsListTableViewController.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 28/09/23.
//

import UIKit

class SongsListTableViewController: UITableViewController, PlayerViewControllerDelegate {
    
    var songs: [Song] = []
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .black
        tableView.contentInset.bottom = 120
        tableView.register(SongsListTableViewCell.self, forCellReuseIdentifier: cellID)
        
        APIService.shared.fetchMusicData { result in
            self.songs = result.data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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
        let song = songs[indexPath.item]
        launchPlayer(with: song)
    }
    
    func launchPlayer(with song: Song) {
        let playerController = PlayerViewController()
        playerController.delegate = self
        playerController.configure(with: song)
        playerController.currentPlayingSong = song
        
        let playerView = playerController.view!
        
        if let tabView = parent as? TabViewController {
//            tabView.view.addSubview(playerView)
//            tabView.addChild(playerController)
//            playerController.didMove(toParent: tabView)
//
//            playerView.fillInSuperview()
            playerController.modalPresentationStyle = .fullScreen
            self.present(playerController, animated: true)
        }
    }
}
