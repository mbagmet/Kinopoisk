//
//  FilmsListViewModelType.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 06.01.2023.
//

import Foundation

protocol FilmsListViewModelType {
    
    // MARK: Delegates
    var errorHandlingDelegate: FilmsErrorHandlingDelegate? { get set }
    
    // MARK: Properties
    var model: [Film]? { get }
    var films: Box<[Film]?> { get }
    var isLoading: Bool { get set }
    
    // MARK: Fetching data
    func fetchMovies(page: Int?, completion: @escaping() -> ())
    
    // MARK: For table rows
    func numberOfRows() -> Int
    
    // MARK: For cells
    func makeCellViewModel(forIndexPath indexPath: IndexPath) -> FilmsTableViewCellViewModelType?
    
    // MARK: For Detail
    func makeDetailViewModel() -> FilmDetailViewModelType?
    func selectRow(atIndexPath indexPath: IndexPath)
}
