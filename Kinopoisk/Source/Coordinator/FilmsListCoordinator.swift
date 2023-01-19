//
//  FilmsListCoordinator.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 02.01.2023.
//

import UIKit

class FilmsListCoordinator: Coordinator, FilmsListFlow {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    var dataCommunicator: DataCommunicator
    var viewModel: FilmsListViewModelType?
    var filmsListViewController: FilmsListViewController
    
    // MARK: - Initializers
    
    init(navigationController: UINavigationController, dataCommunicator: DataCommunicator) {
        self.navigationController = navigationController
        self.dataCommunicator = dataCommunicator
        self.viewModel = FilmsListViewModel(dataCommunicator: dataCommunicator)
        self.filmsListViewController = FilmsListViewController()
    }
    
    // MARK: - Methods
    
    func start() {        
        filmsListViewController.coordinator = self
        filmsListViewController.viewModel = viewModel
        filmsListViewController.searchCoordinator = coordinateToFilmSearch()
        
        filmsListViewController.navigationItem.searchController = filmsListViewController.searchCoordinator?.searchViewController
        
        navigationController.pushViewController(filmsListViewController, animated: true)
    }
    
    func coordinateToFilmDetail(viewModel: FilmDetailViewModelType?) {
        let filmDetailCoordinator = FilmDetailCoordinator(navigationController: navigationController, viewModel: viewModel)
        coordinate(to: filmDetailCoordinator)
    }
    
    func coordinateToFilmFilter() {
        let filmFilterCoordinator = FilmFilterCoordinator(navigationController: navigationController,
                                                          dataCommunicator: dataCommunicator,
                                                          defaultData: viewModel?.provideDefaultFilterData())
        coordinate(to: filmFilterCoordinator)
    }
    
    // MARK: - Private Methods
    
    private func coordinateToFilmSearch() -> FilmsSearchCoordinator {
        let filmsSearchCoordinator = FilmsSearchCoordinator(navigationController: navigationController,
                                                            dataCommunicator: dataCommunicator,
                                                            viewModelDelegate: viewModel as? FilmsSearchViewModelDelegate,
                                                            errorHandlingDelegate: filmsListViewController)
        coordinate(to: filmsSearchCoordinator)
        
        return filmsSearchCoordinator
    }
}
