//
//  TwitterAuthManager.swift
//  DemoTwitterCounter
//
//  Created by Mostafa Hendawi on 29/08/2025.
//


import Foundation
import AuthenticationServices

final class TwitterAuthManager: NSObject {
    static let shared = TwitterAuthManager()
    
    private let clientID = "WmJCS2t6d2VXWXg5OWJ6LWFVcmk6MTpjaQ"
    private let redirectURI = "myapp://auth"
    private let scopes = "tweet.read tweet.write users.read offline.access"
    private let authURL = "https://twitter.com/i/oauth2/authorize"
    private let tokenURL = "https://api.twitter.com/2/oauth2/token"
    private var webAuthSession: ASWebAuthenticationSession?

    var accessToken: String?

    func authenticate(completion: @escaping (Bool) -> Void) {
        let state = UUID().uuidString
        let codeChallenge = "challenge"
        
        var urlComponents = URLComponents(string: authURL)!
        urlComponents.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "client_id", value: clientID),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "scope", value: scopes),
            URLQueryItem(name: "state", value: state),
            URLQueryItem(name: "code_challenge", value: codeChallenge),
            URLQueryItem(name: "code_challenge_method", value: "plain")
        ]
        
        guard let url = urlComponents.url else {
            completion(false)
            return
        }

        webAuthSession = ASWebAuthenticationSession(
            url: url,
            callbackURLScheme: "myapp") { callbackURL, error in
                guard
                    error == nil,
                    let callbackURL = callbackURL,
                    let code = URLComponents(string: callbackURL.absoluteString)?
                        .queryItems?.first(where: { $0.name == "code" })?.value
                else {
                    completion(false)
                    return
                }

                self.exchangeCodeForToken(code: code, completion: completion)
            }
        
        webAuthSession?.presentationContextProvider = self
        webAuthSession?.start()
    }
    
    private func exchangeCodeForToken(code: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: tokenURL) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let params = [
            "code": code,
            "grant_type": "authorization_code",
            "client_id": clientID,
            "redirect_uri": redirectURI,
            "code_verifier": "challenge"
        ]
        
        request.httpBody = params
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .data(using: .utf8)
        
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let token = json["access_token"] as? String
            else {
                completion(false)
                return
            }

            self.accessToken = token
            completion(true)
        }.resume()
    }
}

extension TwitterAuthManager: ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return UIApplication.shared
            .connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow } ?? ASPresentationAnchor()
    }
}
