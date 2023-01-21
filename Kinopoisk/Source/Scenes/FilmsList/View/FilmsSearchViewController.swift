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
    
    init() {
        super.init(searchResultsController: nil)
        
        // MARK: Configuration
        self.searchBar.placeholder = Strings.searchBarPlaceholder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Methods
    private func getFilmsFromSearchResult(filmName: String) {
        viewModel?.fetchMovies(filmName: filmName, filter: viewModel?.filter, completion: { [weak self] in
            self?.viewModel?.updateFilmsListModel()
        })
    }
}

extension FilmsSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let filmName = searchBar.text else { return }
        
        getFilmsFromSearchResult(filmName: filmName)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel?.getFilmsListFromModelOrFilter()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let filmName = searchBar.text else { return }
        
        if filmName  == "" {
            viewModel?.getFilmsListFromModelOrFilter()
        } else if filmName.count >= Metric.numberOfCharactersToStartSearch {
            getFilmsFromSearchResult(filmName: filmName)
        }
    }
}

// MARK: - Constants
extension FilmsSearchViewController {
    enum Metric {
        static let numberOfCharactersToStartSearch = 5
    }
    
    enum Strings {
        static let searchBarPlaceholder = "Поиск по названию фильма"
    }
}
