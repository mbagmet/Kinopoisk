//
//  FilmsListViewModel.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 02.01.2023.
//

import Foundation

class FilmsListViewModel: FilmsListViewModelType {
    
    // MARK: - DataCommunicator
    
    var dataCommunicator: DataCommunicator
    
    private var selectedFilmTypes: [Film.FilmType] = [] {
        didSet {
//            print("FilmsListViewModel \(selectedFilmTypes)")
        }
    }
    
    // MARK: - Delegate
    
    weak var errorHandlingDelegate: FilmsErrorHandlingDelegate?
    
    // MARK: - Properties
    
    var model: [Film]?
    var films: Box<[Film]?> = Box(nil)
    
    var isLoading = false
    
    private var selectedIndexPath: IndexPath?
    private let networkManager = NetworkManager()
    private var isSearching = false
    private var currentPage: Int?
    private var totalPages: Int?
    
    // MARK: - Initializers
    
    init(dataCommunicator: DataCommunicator) {
        self.dataCommunicator = dataCommunicator
        dataCommunicator.subscribe(subscriberId: "filmsListViewModel") { (selectedFilmTypes: [Film.FilmType]) in
            self.selectedFilmTypes = selectedFilmTypes
        }
        
        networkManager.delegate = self
    }
    
    deinit {
        dataCommunicator.unsubscribe(subscriberId: "filmsListViewModel")
    }
    
    // MARK: - Methods
    
    func fetchMovies(page: Int? = nil, completion: @escaping() -> ()) {
        isLoading = true
        networkManager.fetchData(page: page) { [weak self] movies, page, totalPages in
            if self?.model != nil {
                self?.model?.append(contentsOf: movies)
            } else {
                self?.model = movies
            }
            self?.films.value = self?.model
            self?.currentPage = page
            self?.totalPages = totalPages
            completion()
        }
    }
    
    func numberOfRows() -> Int {
        return films.value?.count ?? 0
    }
    
    func makeCellViewModel(forIndexPath indexPath: IndexPath) -> FilmsTableViewCellViewModelType? {
        guard let film = films.value?[indexPath.row] else { return nil }
        
        checkIfEndOfPage(indexPath: indexPath)
        
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
    
    func provideDefaultFilterData() -> [Film.FilmType] {
        return selectedFilmTypes
    }
    
    // MARK: - Private Methods
    
    private func checkIfEndOfPage(indexPath: IndexPath) {
        if indexPath.row == (films.value?.count ?? 0) - Metric.rowsBeloreFetch {
            if !isSearching {
                loadNextPage()
            }
        }
    }
    
    private func loadNextPage() {
        guard let currentPage = currentPage, let totalPages = totalPages else { return }
        
        if currentPage < totalPages && !isLoading {
            fetchMovies(page: currentPage + 1) { [weak self] in
                self?.isLoading = false
            }
        }
    }
}

// MARK: - FilmsSearchViewModel Delegate

extension FilmsListViewModel: FilmsSearchViewModelDelegate {
    func updateModel(with searchResults: [Film]?) {
        films.value = searchResults
        isSearching = true
    }
    
    func resetModel() {
        films.value = model
        isSearching = false
    }
}

// MARK: - NetworkManagerErrorHandlerDelegate

extension FilmsListViewModel: NetworkManagerErrorHandlerDelegate {
    func handleErrorMessage(message: String?) {
        errorHandlingDelegate?.showAlert(message: message)
    }
}

// MARK: - Constants

extension FilmsListViewModel {
    enum Metric {
        static let rowsBeloreFetch = 10
    }
}
