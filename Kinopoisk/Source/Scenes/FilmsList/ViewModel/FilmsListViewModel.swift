//
//  FilmsListViewModel.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 02.01.2023.
//

import Foundation

class FilmsListViewModel: FilmsListViewModelType {
    
    // MARK: - Properties
    
    var model: [Film]?
    
    private var selectedIndexPath: IndexPath?
    private let networkManager = NetworkManager()
    
    // MARK: - Methods
    
    func fetchMovies(completion: @escaping() -> ()) {
        networkManager.fetchData(filmName: nil) { [weak self] movies in
            self?.model = movies
            completion()
        }
    }
    
    func numberOfRows() -> Int {
        return model?.count ?? 0
    }
    
    func makeCellViewModel(forIndexPath indexPath: IndexPath) -> FilmsTableViewCellViewModelType? {
        guard let film = model?[indexPath.row] else { return nil }
        return FilmsTableViewCellViewModel(film: film)
    }
    
//    func titleForCell(atIndexPath indexPath: IndexPath) -> String {
//        guard let movies = model else { return "" }
//        return movies[indexPath.row].names[0].name
//    }
    
}
