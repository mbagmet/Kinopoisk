//
//  UILabel+Extension.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 13.01.2023.
//

import UIKit

extension UILabel {
    static func createLabel(fontWeight: UIFont.Weight,
                            fontSize: CGFloat = CommonMetrics.defaultFontSize,
                            numberOfLines: Int = CommonMetrics.defaultNumberOfLines,
                            textColor: UIColor = .label) -> UILabel {
       let label = UILabel()
       label.font = .systemFont(ofSize: fontSize, weight: fontWeight)
       label.numberOfLines = numberOfLines
       label.textColor = textColor
       label.textAlignment = .center
       
       return label
   }
}
