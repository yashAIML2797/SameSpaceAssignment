//
//  APIService.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 28/09/23.
//

import Foundation
import UIKit

class APIService {
    static let shared = APIService()
    
    private init() {
        
    }
    
    func fetchMusicData(completion: @escaping (Results) -> Void) {
        let urlString = "https://cms.samespace.com/items/songs"
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let data = data,
               let result = try? JSONDecoder().decode(Results.self, from: data)
            {
                completion(result)
            }
        }
        task.resume()
    }
    
    func fetchCoverImage(for coverImageID: String, completion: @escaping (UIImage?) -> Void) {
        let urlString = "https://cms.samespace.com/assets/\(coverImageID)"
        
        guard let url = URL(string: urlString) else {
            print("invalid url")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            if let data = data {
                completion(UIImage(data: data))
            }
        }
        task.resume()
    }
}
