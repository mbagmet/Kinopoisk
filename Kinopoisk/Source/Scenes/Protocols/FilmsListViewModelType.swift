//
//  FilmsListViewModelType.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 06.01.2023.
//

import Foundation

protocol FilmsListViewModelType {
    
    // MARK: Fetching data from model
    func fetchMovies(completion: @escaping() -> ())
    
    // MARK: For table rows
    func numberOfRows() -> Int
    
    // MARK: For cells
    func makeCellViewModel(forIndexPath indexPath: IndexPath) -> FilmsTableViewCellViewModelType?
    
    // MARK: For Detail
    func makeDetailViewModel() -> FilmDetailViewModelType?
    func selectRow(atIndexPath indexPath: IndexPath)
}
