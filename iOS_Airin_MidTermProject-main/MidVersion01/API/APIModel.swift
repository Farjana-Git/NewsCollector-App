//
//  APIModel.swift
//  MidVersion01
//
//  Created by Bjit on 13/1/23.
//

import Foundation

class APIModel {


    static let shared = APIModel()
    private init(){}


    func fetchData(category: String, completion: @escaping (Welcome?) -> Void){
        var result: Welcome?

        print(category)
        var url: String!
        if category == "All" {
            url = "https://newsapi.org/v2/top-headlines?country=us&apiKey=fd389e2a636446ceb22ff936c31e759d"
        } else {
            url = "https://newsapi.org/v2/top-headlines?country=us&category=\(category)&apiKey=fd389e2a636446ceb22ff936c31e759d"
        }
        

        guard let url = URL(string: url) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            guard let data = data, error == nil else {
                print("Error: ", error)
                return
            }
           
            do {
                let decoder = JSONDecoder()
                result = try decoder.decode(Welcome.self, from: data)
                print(result?.status)
                completion(result)
            }
            catch {
                print(error.localizedDescription)
            }

        }
        task.resume()
    }

}
    
