//
//  SongsListTableViewController.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 28/09/23.
//

import UIKit

class SongsListTableViewController: UITableViewController {
    
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
}
