//
//  FilmsListViewModelType.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 06.01.2023.
//

import Foundation

protocol FilmsListViewModelType {
    func fetchMovies(completion: @escaping() -> ())
    func numberOfRows() -> Int
//    func makeCellViewModel(forIndexPath indexPath: IndexPath) -> FilmsTableViewCellViewModelType?
    func titleForCell(atIndexPath indexPath: IndexPath) -> String
}
