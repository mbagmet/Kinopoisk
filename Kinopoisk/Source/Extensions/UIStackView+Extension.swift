//
//  UIStackView+Extension.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 12.01.2023.
//

import UIKit

extension UIStackView {
    static func createStackView(axis: NSLayoutConstraint.Axis,
                                distribution: UIStackView.Distribution,
                                alignment: UIStackView.Alignment,
                                spacing: CGFloat = 0) -> UIStackView {
        let stackView = UIStackView()

        stackView.axis = axis
        stackView.distribution = distribution
        stackView.alignment = alignment
        stackView.spacing = spacing

        return stackView
    }
}
