//
//  Toast.swift
//  TwitterCounter
//
//  Created by Mostafa Hendawi on 30/08/2025.
//

import UIKit

public final class Toast {
    public static let shared = Toast()

    public func show(message: String) {
        guard let window = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow }) else { return }

        let toastLabel = UILabel()
        toastLabel.text = message
        toastLabel.textColor = .white
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        toastLabel.alpha = 1.0
        toastLabel.numberOfLines = 0
        toastLabel.layer.cornerRadius = 12
        toastLabel.clipsToBounds = true

        let maxWidth = window.frame.width - 40
        let size = toastLabel.sizeThatFits(CGSize(width: maxWidth, height: .greatestFiniteMagnitude))
        let labelWidth = min(size.width + 32, maxWidth)
        let labelHeight = size.height + 20

        toastLabel.frame = CGRect(
            x: (window.frame.width - labelWidth) / 2,
            y: window.frame.height - 100,
            width: labelWidth,
            height: labelHeight
        )

        window.addSubview(toastLabel)

        UIView.animate(withDuration: 2.5, delay: 0.5, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }) { _ in
            toastLabel.removeFromSuperview()
        }
    }
}
