//
//  UILabel+Extension.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 13.01.2023.
//

import UIKit

extension UILabel {
    static func createLabel(fontWeight: UIFont.Weight = .regular,
                            fontSize: CGFloat = CommonMetrics.defaultFontSize,
                            numberOfLines: Int = CommonMetrics.defaultNumberOfLines,
                            textColor: UIColor = .label,
                            textAlignment: NSTextAlignment = .natural) -> UILabel {
       let label = UILabel()
       label.font = .systemFont(ofSize: fontSize, weight: fontWeight)
       label.numberOfLines = numberOfLines
       label.textColor = textColor
       label.textAlignment = textAlignment
       
       return label
   }
}
