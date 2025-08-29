//
//  TweetCounter.swift
//  Twitter Counter
//
//  Created by Mostafa Hendawi on 29/08/2025.
//


import Foundation

public struct TweetCounter {
    /// Calculates the weighted character count based on Twitter's rules
    public static func count(_ text: String) -> Int {
        var count = 0
        let words = text.split(separator: " ", omittingEmptySubsequences: false)
        
        for word in words {
            let wordStr = String(word)
            
            // If it's a valid URL → fixed 23 chars
            if let url = URL(string: wordStr), url.scheme != nil {
                count += 23
            } else {
                for char in wordStr {
                    if char.isEmoji || char.isCJK {
                        count += 2
                    } else {
                        count += 1
                    }
                }
            }
            // Count spaces explicitly
            count += 1
        }
        
        // Remove the last extra space if present
        return max(count - 1, 0)
    }
}

// MARK: - Helpers

private extension Character {
    /// Detect emojis, including composed ones
    var isEmoji: Bool {
        unicodeScalars.first?.properties.isEmojiPresentation ?? false
    }
    
    /// Detect Chinese, Japanese, and Korean characters
    var isCJK: Bool {
        guard let scalar = unicodeScalars.first else { return false }
        return (0x4E00...0x9FFF).contains(scalar.value) ||  // CJK Unified Ideographs
               (0x3400...0x4DBF).contains(scalar.value) ||  // CJK Extension A
               (0x20000...0x2A6DF).contains(scalar.value)   // CJK Extension B
    }
}
