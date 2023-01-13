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
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Navigation
        setupNavigation()
        
        // MARK: ViewModel configuration
        viewModel?.fetchMovies { [weak self] in
            DispatchQueue.main.async {
                self?.filmsTableView.reloadData()
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
    }
    
    private func setupTableCells() {
        filmsTableView.register(FilmsListTableViewCell.self, forCellReuseIdentifier: FilmsListTableViewCell.identifier)
    }
}

// MARK: - Navigation
extension FilmsListViewController {
    private func setupNavigation() {
        navigationItem.title = Strings.navigationTitle
        self.navigationController?.navigationBar.prefersLargeTitles = true
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

// MARK: - Constants
extension FilmsListViewController {
    enum Metric {
        static let FilmListCellHeight: CGFloat = 120
    }
    
    enum Strings {
        static let searchBarPlaceholder = "Поиск по названию фильма"
        static let navigationTitle = "Фильмы"
        
        static let errorAlertTitle = "Ошибка"
        static let errorAlertText = "По вашему запросу ничего не найдено. Попробуйте ввести другой запрос."
        static let errorAlertButtonTitle = "OK"
    }
}
