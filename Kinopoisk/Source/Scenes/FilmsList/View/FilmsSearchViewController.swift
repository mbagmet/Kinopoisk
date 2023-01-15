//
//  FilmsSearchViewController.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 15.01.2023.
//

import UIKit

class FilmsSearchViewController: UISearchController {
    
    // MARK: - Properties
    
    var viewModel: FilmsSearchViewModelType?

    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Configuration
        self.obscuresBackgroundDuringPresentation = false
    }
    
    // MARK: - Init
    
    init(viewModelDelegate: FilmsSearchViewModelDelegate?, errorHandlingDelegate: FilmsErrorHandlingDelegate?) {
        super.init(searchResultsController: nil)
        
        // MARK: Configuration
        self.searchBar.placeholder = Strings.searchBarPlaceholder
        
        // MARK: ViewModel configuration
        viewModel = FilmsSearchViewModel()
        viewModel?.delegate = viewModelDelegate
        viewModel?.errorHandlingDelegate = errorHandlingDelegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func getFilmsFromSearchResult(filmName: String) {
        viewModel?.fetchMovies(filmName: filmName, completion: {
            self.viewModel?.updateFilmsListModel()
        })
    }
}

extension FilmsSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let filmName = searchBar.text else { return }
        
        getFilmsFromSearchResult(filmName: filmName)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.getFilmsListFromModel()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let filmName = searchBar.text else { return }
        
        if filmName  == "" {
            viewModel?.getFilmsListFromModel()
        } else if filmName.count > 4 {
            getFilmsFromSearchResult(filmName: filmName)
        }
    }
}

// MARK: - Constants
extension FilmsSearchViewController {
    enum Strings {
        static let searchBarPlaceholder = "Поиск по названию фильма"
        
        static let errorAlertTitle = "Ошибка"
        static let errorAlertText = "По вашему запросу ничего не найдено. Попробуйте ввести другой запрос."
        static let errorAlertButtonTitle = "OK"
    }
}
