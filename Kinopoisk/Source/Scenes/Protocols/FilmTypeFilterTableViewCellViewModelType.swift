//
//  FilmTypeFilterTableViewCellViewModelType.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 17.01.2023.
//

import Foundation

protocol FilmTypeFilterTableViewCellViewModelType: AnyObject {
    var categoryTitle: String? { get }
    var isSelected: Bool { get set }
}
