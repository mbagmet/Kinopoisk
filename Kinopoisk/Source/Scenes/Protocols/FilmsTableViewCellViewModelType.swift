//
//  FilmsTableViewCellViewModelType.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 06.01.2023.
//

import UIKit.UIImage

protocol FilmsTableViewCellViewModelType: AnyObject {
    var filmTitle: String? { get }
    var alterntiveTitle: String? { get }
    var year: String { get }
    var rating: String? { get }
    
    func getImage(for imageView: UIImageView?)
}
