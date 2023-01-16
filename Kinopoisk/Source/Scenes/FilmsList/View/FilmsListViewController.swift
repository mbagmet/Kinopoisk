//
//  FilmsListViewController.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 02.01.2023.
//

import UIKit
import SnapKit

class FilmsListViewController: UIViewController {
    
    // MARK: - Properties
    
    var coordinator: FilmsListFlow?
    var viewModel: FilmsListViewModelType?
    
    // MARK: - Views

    private lazy var filmsTableView = UITableView(frame: view.bounds, style: UITableView.Style.plain)
    
    private lazy var searchController = FilmsSearchViewController(viewModelDelegate: viewModel as? FilmsSearchViewModelDelegate,
                                                                  errorHandlingDelegate: self)
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: ViewModel configuration
        viewModel?.fetchMovies(page: nil) { [weak self] in
            DispatchQueue.main.async {
                self?.bindViewModel()
                self?.viewModel?.isLoading = false
            }
        }
        
        // MARK: View Setup
        setupHierarchy()
        setupView()
        setupLayout()
        
        // MARK: UITableView Setup
        setupDataSource()
        setupDelegate()
        setupTableCells()
        
        // MARK: Search setup
        setupSearch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // MARK: Navigation
        setupNavigation()
    }
    
    // MARK: - Settings
    
    private func setupHierarchy() {
        view.addSubview(filmsTableView)
    }

    private func setupView() {
        view.backgroundColor = .secondarySystemBackground | .systemBackground
    }
    
    private func setupLayout() {
        filmsTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupDataSource() {
        filmsTableView.dataSource = self
    }

    private func setupDelegate() {
        filmsTableView.delegate = self
        viewModel?.errorHandlingDelegate = self
    }
    
    private func setupTableCells() {
        filmsTableView.register(FilmsListTableViewCell.self, forCellReuseIdentifier: FilmsListTableViewCell.identifier)
    }
}

// MARK: - Binding
extension FilmsListViewController {
    private func bindViewModel() {
        viewModel?.films.bind(listener: { films in
            DispatchQueue.main.async {
                self.filmsTableView.reloadData()
            }
        })
    }
}

// MARK: - Navigation
extension FilmsListViewController {
    private func setupNavigation() {
        navigationItem.title = Strings.navigationTitle
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.tintColor = .darkText
    }
}

// MARK: - Data source, cell model

extension FilmsListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        let cell = tableView.dequeueReusableCell(withIdentifier: FilmsListTableViewCell.identifier, for: indexPath) as? FilmsListTableViewCell
        
        guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
        
        let cellViewModel = viewModel.makeCellViewModel(forIndexPath: indexPath)
        tableViewCell.viewModel = cellViewModel

        return tableViewCell
    }
}

// MARK: - Delegate

extension FilmsListViewController: UITableViewDelegate {

    // MARK: Make table row height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Metric.FilmListCellHeight
    }
    
    // MARK: Cell tap handling
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        viewModel.selectRow(atIndexPath: indexPath)
        
        coordinator?.coordinateToFilmDetail(viewModel: viewModel.makeDetailViewModel())
    }
}

// MARK: - Search

extension FilmsListViewController {
    private func setupSearch() {
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = searchController
    }
}

// MARK: - FilmsListViewModel Delegate

extension FilmsListViewController: FilmsErrorHandlingDelegate{
    func showAlert(message: String?) {
        let alert = UIAlertController(title: CommonStrings.failureMessageTitle, message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: CommonStrings.dismissButtonTitle, style: .default, handler: nil)
        alert.addAction(button)
        
        present(alert, animated: true)
    }
}

// MARK: - Constants
extension FilmsListViewController {
    enum Metric {
        static let FilmListCellHeight: CGFloat = 120
    }
    
    enum Strings {
        static let searchBarPlaceholder = "Поиск по названию фильма"
        static let navigationTitle = "Фильмы"
    }
}
