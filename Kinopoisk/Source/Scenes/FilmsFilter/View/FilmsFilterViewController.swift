//
//  FilmsFilterViewController.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 16.01.2023.
//

import UIKit

class FilmsFilterViewController: UIViewController {
    
    // MARK: - Properties
    
    var coordinator: Coordinator?
    var viewModel: FilmsFilterViewModelType?

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: View Setup
        setupHierarchy()
        setupView()
        setupLayout()
        
        // MARK: UITableView Setup
        setupDataSource()
        setupDelegate()
        setupTableCells()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel?.isFiltering = false
    }
    
    // MARK: - Views

    private lazy var scrollView = UIScrollView()
    private lazy var mainContainer = UIView()
    
    // MARK: StackViews
    private lazy var contentStackView = UIStackView.createStackView(axis: .vertical, distribution: .fill, alignment: .top, spacing: Metric.contentStackViewSpacing)
    
    // MARK: TableView
    private lazy var filterTableView = UITableView(frame: view.bounds, style: UITableView.Style.grouped)
    
    // MARK: - Settings
    
    private func setupHierarchy() {
        view.addSubview(filterTableView)
    }

    private func setupView() {
        view.backgroundColor = .secondarySystemBackground | .systemBackground
    }
    
    private func setupLayout() {
        filterTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupDataSource() {
        filterTableView.dataSource = self
    }

    private func setupDelegate() {
        filterTableView.delegate = self
    }
    
    private func setupTableCells() {
        filterTableView.register(FilmTypeFilterTableViewCell.self, forCellReuseIdentifier: FilmTypeFilterTableViewCell.identifier)
    }
}

// MARK: - Data source, cell model

extension FilmsFilterViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRows() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  
        let cell = tableView.dequeueReusableCell(withIdentifier: FilmTypeFilterTableViewCell.identifier, for: indexPath) as? FilmTypeFilterTableViewCell
        
        guard let tableViewCell = cell, let viewModel = viewModel else { return UITableViewCell() }
        
        let cellViewModel = viewModel.makeCellViewModel(forIndexPath: indexPath)
        tableViewCell.viewModel = cellViewModel

        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.setSectionName()
    }
}

// MARK: - Delegate

extension FilmsFilterViewController: UITableViewDelegate {
    
    // MARK: Cell tap handling
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        viewModel.selectRow(atIndexPath: indexPath)
        viewModel.selectOptions {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let viewModel = viewModel else { return }
        viewModel.selectRow(atIndexPath: indexPath)
        viewModel.selectOptions {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - Constants

extension FilmsFilterViewController {
    enum Metric {
        static let scrollViewTopOffset: CGFloat = 30
        
        static let contentStackViewSpacing: CGFloat = 10
    }
}
