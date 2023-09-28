//
//  Song.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 28/09/23.
//

import Foundation

//"id": 1,
//"status": "published",
//"sort": null,
//"user_created": "2085be13-8079-40a6-8a39-c3b9180f9a0a",
//"date_created": "2023-08-10T06:10:57.746Z",
//"user_updated": "2085be13-8079-40a6-8a39-c3b9180f9a0a",
//"date_updated": "2023-08-10T07:19:48.547Z",
//"name": "Colors",
//"artist": "William King",
//"accent": "#331E00",
//"cover": "4f718272-6b0e-42ee-92d0-805b783cb471",
//"top_track": true,
//"url": "https://pub-172b4845a7e24a16956308706aaf24c2.r2.dev/august-145937.mp3"

struct Song: Decodable {
    let id:             Int
    let status:         String
//    let sort: null
    let user_created:   String
    let date_created:   String
    let user_updated:   String
    let date_updated:   String
    let name:           String
    let artist:         String
    let accent:         String
    let cover:          String
    let top_track:      Bool
    let url:            String
}
