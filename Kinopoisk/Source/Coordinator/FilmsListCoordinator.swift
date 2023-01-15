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
    
    // MARK: - Initializers
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    
    func start() {
        let filmsListViewController = FilmsListViewController()
        let viewModel = FilmsListViewModel()
        
        filmsListViewController.coordinator = self
        filmsListViewController.viewModel = viewModel
        
        navigationController.pushViewController(filmsListViewController, animated: true)
    }
    
    func coordinateToFilmDetail(viewModel: FilmDetailViewModelType?) {
        let filmDetailCoordinator = FilmDetailCoordinator(navigationController: navigationController, viewModel: viewModel)
        coordinate(to: filmDetailCoordinator)
    }
}
