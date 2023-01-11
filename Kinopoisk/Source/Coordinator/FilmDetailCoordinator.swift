//
//  FilmDetailCoordinator.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 02.01.2023.
//

import UIKit

class FilmDetailCoordinator: Coordinator, FilmDetailFlow {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    var viewModel: FilmDetailViewModelType?
    
    // MARK: - Initializers
    
    init(navigationController: UINavigationController, viewModel: FilmDetailViewModelType?) {
        self.navigationController = navigationController
        self.viewModel = viewModel
    }
    
    // MARK: - Methods
    
    func start() {
        let filmDetailViewController = FilmDetailViewController()
        let viewModel = viewModel

        filmDetailViewController.coordinator = self
        filmDetailViewController.viewModel = viewModel as? FilmDetailViewModel
        
        navigationController.pushViewController(filmDetailViewController, animated: true)
    }
    
    func dismissDetail() {
        navigationController.dismiss(animated: true)
    }
}
