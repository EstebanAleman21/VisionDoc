//
//  NetworkManager.swift
//  VisionDoc
//
//  Created by Esteban Aleman on 11/04/24.
//

import Foundation

class NetworkManager {
   static let shared = NetworkManager()
   
   func fetchData<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
       URLSession.shared.dataTask(with: url) { data, response, error in
           if let error = error {
               completion(.failure(error))
               return
           }
           guard let data = data else {
               completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
               return
           }
           do {
               let decodedData = try JSONDecoder().decode(T.self, from: data)
               DispatchQueue.main.async {
                   completion(.success(decodedData))
               }
           } catch {
               completion(.failure(error))
           }
       }.resume()
   }
}
