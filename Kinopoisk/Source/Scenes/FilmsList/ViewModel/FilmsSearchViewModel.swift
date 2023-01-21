//
//  FilmsSearchViewModel.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 15.01.2023.
//

import Foundation

class FilmsSearchViewModel: FilmsSearchViewModelType {
    
    // MARK: - DataCommunicator
    
    var dataCommunicator: DataCommunicator
    
    // MARK: Subscriptions from DataCommunicator
    private var selectedFilmTypes: [Film.FilmType] = [] {
        didSet {
            makeFiltering()
        }
    }
    private var isFiltering = false
    
    // MARK: - Delegate
    
    weak var errorHandlingDelegate: FilmsErrorHandlingDelegate?
    weak var delegate: FilmsSearchViewModelDelegate?
    
    // MARK: - Properties

    var model: [Film]?
    var isLoading = false
    var searchQuery: String?
    var filter: [String]? {
        return prepareFilterArray(selectedFilmTypes: selectedFilmTypes)
    }
    var hasParametersForFiltering: Bool {
        return selectedFilmTypes != [] ? true : false
    }

    private let networkManager = NetworkManager()
    
    // MARK: - Initializers
    
    init(dataCommunicator: DataCommunicator) {
        self.dataCommunicator = dataCommunicator
        dataCommunicator.subscribe(subscriberId: "filmsSearchViewModelFilmTypes") { (selectedFilmTypes: [Film.FilmType]) in
            self.selectedFilmTypes = selectedFilmTypes
        }
        dataCommunicator.subscribe(subscriberId: "filmsSearchViewModelIsFiltering") { (isFiltering: Bool) in
            self.isFiltering = isFiltering
        }
        
        networkManager.delegate = self
    }
    
    deinit {
        dataCommunicator.unsubscribe(subscriberId: "filmsSearchViewModelFilmTypes")
        dataCommunicator.unsubscribe(subscriberId: "filmsSearchViewModelIsFiltering")
    }

    // MARK: - Methods

    func fetchMovies(filmName: String?, filter: [String]? = nil, completion: @escaping() -> ()) {
        networkManager.fetchData(filmName: filmName, filter: filter) { [weak self] movies, page, totalPages  in
            self?.model = movies
            self?.searchQuery = filmName
            completion()
        }
    }
    
    func updateFilmsListModel() {
        delegate?.updateModel(with: model)
    }
    
    func getFilmsListFromModelOrFilter() {
        networkManager.removeParameterFromRequest(field: NetworkManager.kinopoiskAPI.fieldName)
        
        if hasParametersForFiltering {
            restoreFiltering()
        } else {
            delegate?.resetModel()
        }
    }
    
    // MARK: - Private Methods
    
    private func prepareFilterArray(selectedFilmTypes: [Film.FilmType]) -> [String]? {
        if !selectedFilmTypes.isEmpty {
            var filter: [String] = []
            for item in selectedFilmTypes {
                filter.append(item.rawValue)
            }
            return filter
        }
        return nil
    }
    
    private func makeFiltering() {
        guard let filter = filter, isFiltering else {
            if isFiltering {
                delegate?.resetModel()
            }
            return
        }

        fetchMovies(filmName: nil, filter: filter) { [weak self] in
            self?.isLoading = false
            self?.updateFilmsListModel()
        }
    }
    
    private func restoreFiltering() {
        guard let filter = filter else { return }

        fetchMovies(filmName: nil, filter: filter) { [weak self] in
            self?.isLoading = false
            self?.updateFilmsListModel()
        }
    }
    
//    private func resetPageNumber() {
//        currentPage = nil
//        totalPages = nil
//    }
}

// MARK: - NetworkManagerErrorHandlerDelegate

extension FilmsSearchViewModel: NetworkManagerErrorHandlerDelegate {
    func handleErrorMessage(message: String?) {
        errorHandlingDelegate?.showAlert(message: message)
    }
}
