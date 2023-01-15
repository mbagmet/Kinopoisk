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
    var films: Box<[Film]?> = Box(nil)
    
    private var selectedIndexPath: IndexPath?
    private let networkManager = NetworkManager()
    
    // MARK: - Initializers
    
    init() {
        print("FilmsListViewModel initialized")
    }
    
    // MARK: - Methods
    
    func fetchMovies(completion: @escaping() -> ()) {
        networkManager.fetchData(filmName: nil) { [weak self] movies in
            self?.model = movies
            self?.films.value = movies
            completion()
        }
    }
    
    func numberOfRows() -> Int {
        return films.value?.count ?? 0
    }
    
    func makeCellViewModel(forIndexPath indexPath: IndexPath) -> FilmsTableViewCellViewModelType? {
        guard let film = films.value?[indexPath.row] else { return nil }
        return FilmsTableViewCellViewModel(film: film)
    }
    
    func makeDetailViewModel() -> FilmDetailViewModelType? {
        guard let selectedIndexPath = selectedIndexPath else { return nil }
        let filmID = films.value?[selectedIndexPath.row].id

        return FilmDetailViewModel(filmID: filmID)
    }
    
    func selectRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
}

// MARK: - FilmsSearchViewModel Delegate

extension FilmsListViewModel: FilmsSearchViewModelDelegate {
    func updateModel(with searchResults: [Film]?) {
        films.value = searchResults
    }
    
    func resetModel() {
        films.value = model
    }
}
