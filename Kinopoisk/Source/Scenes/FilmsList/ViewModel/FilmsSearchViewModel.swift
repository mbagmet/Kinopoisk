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
            resetPageNumber()
            makeFiltering()
        }
    }
    private var isFiltering = false
    
    // MARK: - Network
    
    private let networkManager = NetworkManager()
    
    // MARK: - Delegate
    
    weak var errorHandlingDelegate: FilmsErrorHandlingDelegate?
    weak var delegate: FilmsSearchViewModelDelegate?
    
    // MARK: - Model
    
    var model: [Film]?
    
    // MARK: - Properties

    var isLoading = false
    var searchQuery: String?
    var filter: [String]? {
        return prepareFilterArray(selectedFilmTypes: selectedFilmTypes)
    }
    var hasParametersForFiltering: Bool {
        return selectedFilmTypes != [] ? true : false
    }
    
    private var currentPage: Int?
    private var totalPages: Int?
    
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

    func fetchMovies(filmName: String?, filter: [String]? = nil, page: Int? = nil, completion: @escaping() -> ()) {
        networkManager.fetchData(filmName: filmName, page: page, filter: filter) { [weak self] movies, page, totalPages  in
            if self?.model != nil && page > 1 {
                self?.model?.append(contentsOf: movies)
            } else {
                self?.model = movies
            }
            self?.currentPage = page
            self?.totalPages = totalPages
            completion()
        }
    }
    
    func updateFilmsListModel() {
        delegate?.updateModel(with: model)
    }
    
    func getFilmsListFromModelOrFilter() {
        networkManager.removeParameterFromRequest(field: NetworkManager.kinopoiskAPI.fieldName)
        searchQuery = nil
        resetPageNumber()
        
        if hasParametersForFiltering {
            restoreFiltering()
        } else {
            delegate?.resetModel()
            delegate?.askToScrollTableToTop()
        }
    }
    
    func resetPageNumber() {
        currentPage = nil
        totalPages = nil
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
                delegate?.askToScrollTableToTop()
            }
            return
        }

        fetchMovies(filmName: nil, filter: filter) { [weak self] in
            self?.isLoading = false
            self?.updateFilmsListModel()
            self?.delegate?.askToScrollTableToTop()
        }
    }
    
    private func restoreFiltering() {
        guard let filter = filter else { return }

        fetchMovies(filmName: nil, filter: filter) { [weak self] in
            self?.updateFilmsListModel()
            self?.isLoading = false
            self?.delegate?.askToScrollTableToTop()
        }
    }
}

// MARK: - FilmsListViewModelDelegate

extension FilmsSearchViewModel: FilmsListViewModelDelegate {
    func loadNextPage() {
        guard let currentPage = currentPage, let totalPages = totalPages else { return }
        
        if currentPage < totalPages && !isLoading {
            print("loading...")
            fetchMovies(filmName: searchQuery, filter: filter, page: currentPage + 1) { [weak self] in
                self?.updateFilmsListModel()
                self?.isLoading = false
            }
        }
    }
}

// MARK: - NetworkManagerErrorHandlerDelegate

extension FilmsSearchViewModel: NetworkManagerErrorHandlerDelegate {
    func handleErrorMessage(message: String?) {
        errorHandlingDelegate?.showAlert(message: message)
    }
}
