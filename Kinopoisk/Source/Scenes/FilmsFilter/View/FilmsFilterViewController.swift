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
    
    // MARK: - Views

    private lazy var scrollView = UIScrollView()
    private lazy var mainContainer = UIView()
    
    // MARK: StackViews
    //private lazy var mainStackView = UIStackView.createStackView(axis: .vertical, distribution: .equalSpacing, alignment: .center, spacing: Metric.mainStackViewSpacing)
    private lazy var contentStackView = UIStackView.createStackView(axis: .vertical, distribution: .fill, alignment: .top, spacing: Metric.contentStackViewSpacing)
    
    // MARK: Labels
    private lazy var categoryTitleLabel = UILabel.createLabel(fontWeight: .bold, fontSize: 20)
    
    private lazy var filterTableView = UITableView(frame: view.bounds, style: UITableView.Style.grouped)
    
    // MARK: - Settings
    
    private func setupHierarchy() {
        view.addSubview(filterTableView)
//        scrollView.addSubview(mainContainer)
//        mainContainer.addSubview(contentStackView)
////        mainContainer.addSubview(filterTableView)
//
////        mainStackView.addArrangedSubview(contentStackView)
//        contentStackView.addArrangedSubview(categoryTitleLabel)
//        contentStackView.addArrangedSubview(filterTableView)
//        filterTableView.backgroundColor = .systemCyan
    }

    private func setupView() {
        view.backgroundColor = .secondarySystemBackground | .systemBackground
//        scrollView.backgroundColor = .systemYellow
//        mainContainer.backgroundColor = .systemRed
//        //contentStackView.backgroundColor = .systemBlue
//
//        categoryTitleLabel.text = "Категория"
    }
    
    private func setupLayout() {
        filterTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
//        scrollView.snp.makeConstraints { make in
//            make.top.equalToSuperview().offset(Metric.scrollViewTopOffset)
//            make.leading.equalToSuperview().offset(CommonMetrics.leadingOffset)
//            make.trailing.equalToSuperview().offset(CommonMetrics.trailingOffset)
//            make.bottom.equalToSuperview()
//        }
//        mainContainer.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//            make.width.equalTo(view).offset(CommonMetrics.trailingOffset - CommonMetrics.leadingOffset)
//        }
//        contentStackView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//        filterTableView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
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
        
        //static let mainStackViewSpacing: CGFloat = 10
        static let contentStackViewSpacing: CGFloat = 10
    }
}
