//
//  FilmsSearchCoordinator.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 19.01.2023.
//

import UIKit

class FilmsSearchCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    var searchViewController: FilmsSearchViewController
    var dataCommunicator: DataCommunicator
    var viewModel: FilmsSearchViewModel?
    var viewModelDelegate: FilmsSearchViewModelDelegate?
    var errorHandlingDelegate: FilmsErrorHandlingDelegate?
    
    // MARK: - Initializers
    
    init(navigationController: UINavigationController,
         dataCommunicator: DataCommunicator,
         viewModelDelegate: FilmsSearchViewModelDelegate?,
         errorHandlingDelegate: FilmsErrorHandlingDelegate) {
        
        self.navigationController = navigationController
        self.searchViewController = FilmsSearchViewController()
        self.dataCommunicator = dataCommunicator
        self.viewModelDelegate = viewModelDelegate
        self.errorHandlingDelegate = errorHandlingDelegate
    }
    
    // MARK: - Methods
    
    func start() {
        viewModel = FilmsSearchViewModel(dataCommunicator: dataCommunicator)
        
        searchViewController.viewModel = viewModel
        searchViewController.viewModel?.delegate = viewModelDelegate
        searchViewController.viewModel?.errorHandlingDelegate = errorHandlingDelegate
        
        searchViewController.searchBar.delegate = searchViewController
    }
}

