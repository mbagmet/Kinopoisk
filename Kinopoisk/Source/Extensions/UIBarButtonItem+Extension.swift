//
//  UIBarButtonItem+Extension.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 16.01.2023.
//

import UIKit

extension UIBarButtonItem {
    static func menuButton(_ target: Any?, action: Selector, image: UIImage?) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        button.tintColor = .darkText | .lightText

        let menuBarItem = UIBarButtonItem(customView: button)

        return menuBarItem
    }
}
