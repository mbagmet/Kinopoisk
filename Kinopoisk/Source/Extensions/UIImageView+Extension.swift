//
//  UIImageView+Extension.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 13.01.2023.
//

import UIKit

// MARK: - ImageView creation

extension UIImageView {
    static func createImageView(contentMode: UIView.ContentMode,
                                image: UIImage? = nil,
                                backgroundColor: UIColor? = nil,
                                tintColor: UIColor? = nil) -> UIImageView {
        let imageView = UIImageView()
        
        imageView.contentMode = contentMode
        imageView.tintColor = backgroundColor
        imageView.backgroundColor = tintColor

        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        
        imageView.image = image
        
        return imageView
    }
}
