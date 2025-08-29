//
//  TwitterCounterView.swift
//  Twitter Counter
//
//  Created by Mostafa Hendawi on 26/08/2025.
//

import SwiftUI

public struct TwitterCounterView: View {
    @Binding public var tweetText: String
    @State private var showToast = false
    @State private var toastText = ""
    
    public var onPostTapped: ((String) -> Void)?
    
    private var countedChars: Int {
        TweetCounter.count(tweetText)
    }
    
    var charactersTyped: Int { countedChars }
    var charactersRemaining: Int { max(280 - countedChars, 0) }
    
    public init(tweetText: Binding<String>, onPostTapped: @escaping (String) -> Void) {
        self._tweetText = tweetText
        self.onPostTapped = onPostTapped
    }
    
    public var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text("Twitter character count")
                    .bold()
                
                Divider()
                    .frame(maxWidth: .infinity)
                
                Image("twitterIcon", bundle: .module)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                
                HStack(spacing: 16) {
                    VStack(spacing: 0) {
                        Text("Characters Typed")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(Color(hex: "#E6F6FE"))
                        
                        Text("\(charactersTyped)/280")
                            .font(.title2)
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "#E6F6FE"), lineWidth: 2)
                    )
                    
                    VStack(spacing: 0) {
                        Text("Characters Remaining")
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(Color(hex: "#E6F6FE"))
                        
                        Text("\(charactersRemaining)")
                            .font(.title2)
                            .foregroundColor(charactersRemaining == 0 ? .red : .primary)
                            .frame(maxWidth: .infinity)
                            .padding(12)
                            .background(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(hex: "#E6F6FE"), lineWidth: 2)
                    )
                }
                
                ZStack(alignment: .topLeading) {
                    // Background & border
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color(.white))
                        .overlay(
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .stroke(Color(hex: "E0E0E0"), lineWidth: 0.5)
                        )
                    
                    // Placeholder
                    if tweetText.isEmpty {
                        Text("Start typing! You can enter up to 280 characters")
                            .foregroundColor(.gray.opacity(0.6))
                            .padding(.top, 22)
                            .padding(.leading, 18)
                            .font(.subheadline)
                    }
                    
                    // Multiline editor
                    if #available(iOS 16.0, *) {
                        DoneTextView(text: $tweetText)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 14)
                            .frame(minHeight: 120, alignment: .topLeading)
                            .onChange(of: tweetText) { newValue in
                                if TweetCounter.count(newValue) > 280 {
                                    tweetText = String(newValue.prefix(280))
                                }
                            }
                    } else {
                        TextEditor(text: $tweetText)
                            .background(.clear)
                            .padding(.vertical, 12)
                            .padding(.horizontal, 14)
                            .frame(minHeight: 120, alignment: .topLeading)
                            .textInputAutocapitalization(.sentences)
                            .onChange(of: tweetText) { newValue in
                                if TweetCounter.count(newValue) > 280 {
                                    tweetText = String(newValue.prefix(280))
                                }
                            }
                    }
                }
                .frame(height: 220)
                
                HStack(spacing: 16) {
                    Button("Copy Text") {
                        if tweetText.isEmpty {
                            toastText = "Nothing to copy"
                        }
                        else {
                            UIPasteboard.general.string = tweetText
                            toastText = "Copied"
                        }
                        showToast = true
                    }
                    .padding()
                    .background(Color(hex: "#00A970"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    
                    Spacer()
                        .padding()
                    
                    Button("Clear Text") {
                        tweetText = ""
                    }
                    .padding()
                    .background(Color(hex: "#DC0125"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                
                Button("Post tweet") {
                    if tweetText.isEmpty {
                        toastText = "Nothing to tweet"
                        showToast = true
                    }else{
                        onPostTapped?(tweetText)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(hex: "#03A9F4"))
                .foregroundColor(.white)
                .cornerRadius(8)
                
                // Toast overlay
                if showToast {
                    Text(toastText)
                        .font(.subheadline)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Color.black.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .transition(.opacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation {
                                    showToast = false
                                }
                            }
                        }
                }
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    struct TwitterCounterPreviewWrapper: View {
        @State var text = ""
        
        var body: some View {
            TwitterCounterView(tweetText: $text, onPostTapped: { _ in })
        }
    }
    
    return TwitterCounterPreviewWrapper()
}

// Custom UITextView wrapper for iOS 16+ to allow .submitLabel(.done) and .onSubmit-like behavior
struct DoneTextView: UIViewRepresentable {
    @Binding var text: String
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.returnKeyType = .done
        textView.backgroundColor = .clear
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: DoneTextView
        
        init(_ parent: DoneTextView) {
            self.parent = parent
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            if text == "\n" {
                textView.resignFirstResponder()
                return false
            }
            return true
        }
    }
}
