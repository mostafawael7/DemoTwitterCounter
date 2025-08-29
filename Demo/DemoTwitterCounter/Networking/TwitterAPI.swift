//
//  TwitterAPI.swift
//  DemoTwitterCounter
//
//  Created by Mostafa Hendawi on 29/08/2025.
//


import Foundation

final class TwitterAPI {
    static let shared = TwitterAPI()

    func postTweet(_ text: String, completion: @escaping (Bool) -> Void) {
        guard let token = TwitterAuthManager.shared.accessToken else {
            completion(false)
            return
        }

        let url = URL(string: "https://api.twitter.com/2/tweets")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let payload = ["text": text]
        request.httpBody = try? JSONSerialization.data(withJSONObject: payload)

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                completion(true)
            } else {
                completion(false)
            }
        }.resume()
    }
}
