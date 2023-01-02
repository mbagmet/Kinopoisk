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
    
    // MARK: - Initializers
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    
    func start() {
        let filmDetailViewController = FilmDetailViewController()
        let viewModel = FilmDetailViewModel()
        
        filmDetailViewController.coordinator = self
        filmDetailViewController.viewModel = viewModel
        
        navigationController.pushViewController(filmDetailViewController, animated: true)
    }
    
    func dismissDetail() {
        navigationController.dismiss(animated: true)
    }
}
