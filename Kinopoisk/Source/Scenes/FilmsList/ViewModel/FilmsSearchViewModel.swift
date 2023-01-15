//
//  FilmsSearchViewModel.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 15.01.2023.
//

import Foundation

class FilmsSearchViewModel: FilmsSearchViewModelType {
    
    // MARK: - Delegate
    
    weak var errorHandlingDelegate: FilmsErrorHandlingDelegate?
    weak var delegate: FilmsSearchViewModelDelegate?
    
    // MARK: - Properties

    var model: [Film]?

    private let networkManager = NetworkManager()
    
    // MARK: - Initializers
    
    init() {
        networkManager.delegate = self
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

// MARK: - NetworkManagerErrorHandlerDelegate

extension FilmsSearchViewModel: NetworkManagerErrorHandlerDelegate {
    func handleErrorMessage(message: String?) {
        errorHandlingDelegate?.showAlert(message: message)
    }
}
