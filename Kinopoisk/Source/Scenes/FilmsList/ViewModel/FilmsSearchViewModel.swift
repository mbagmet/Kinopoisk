//
//  FilmsSearchViewModel.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 15.01.2023.
//

import Foundation

class FilmsSearchViewModel: FilmsSearchViewModelType {
    
    // MARK: - Properties

    var model: [Film]?
    var delegate: FilmsSearchViewModelDelegate?

    private let networkManager = NetworkManager()
    
    // MARK: - Initializers
    
    init() {
        print("FilmsSearchViewModel initialized")
    }

    // MARK: - Methods

    func fetchMovies(filmName: String?, completion: @escaping() -> ()) {
        networkManager.fetchData(filmName: filmName) { [weak self] movies in
            self?.model = movies
            completion()
        }
    }
    
    func updateFilmsListModel() {
        delegate?.updateModel(with: model)
    }
    
    func getFilmsListFromModel() {
        delegate?.resetModel()
    }
}
