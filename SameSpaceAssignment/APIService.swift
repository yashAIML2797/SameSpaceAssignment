//
//  APIService.swift
//  SameSpaceAssignment
//
//  Created by Yash Uttekar on 28/09/23.
//

import Foundation

class APIService {
    static let shared = APIService()
    
    private init() {
        
    }
    
    func fetchMusicData(completion: @escaping (Result) -> Void) {
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
               let result = try? JSONDecoder().decode(Result.self, from: data)
            {
                completion(result)
            }
        }
        task.resume()
    }
}
