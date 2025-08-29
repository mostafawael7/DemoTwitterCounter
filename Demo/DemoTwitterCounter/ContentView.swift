//
//  ContentView.swift
//  DemoTwitterCounter
//
//  Created by Mostafa Hendawi on 29/08/2025.
//

import SwiftUI
import TwitterCounter

struct ContentView: View {
    @State private var tweetText = ""
    @State private var isLoading = false

    var body: some View {
        ZStack {
            TwitterCounterView(tweetText: $tweetText, onPostTapped: { tweetText in
                isLoading = true
                print("Tweet to post: \(tweetText)")
                TwitterAuthManager.shared.authenticate { success in
                    if success {
                        TwitterAPI.shared.postTweet(tweetText) { posted in
                            DispatchQueue.main.async {
                                isLoading = false
                                if posted {
                                    Toast.shared.show(message: "Tweeted!")
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        self.tweetText = ""
                                    }
                                } else {
                                    Toast.shared.show(message: "Failed to tweet.")
                                }
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            isLoading = false
                            Toast.shared.show(message: "Authentication failed.")
                        }
                    }
                }
            })
            if isLoading {
                ProgressView()
            }
        }
    }
}

#Preview {
    ContentView()
}


import SwiftUI
import Combine

final class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0

    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        let willShow = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height }

        let willHide = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }

        Publishers.Merge(willShow, willHide)
            .assign(to: \.currentHeight, on: self)
            .store(in: &cancellableSet)
    }
}
