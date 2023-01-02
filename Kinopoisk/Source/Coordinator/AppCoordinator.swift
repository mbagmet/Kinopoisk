//
//  AppCoordinator.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 02.01.2023.
//

import UIKit

class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    
    // MARK: - Initializers
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    
    func start() {
        let filmsListCoordinator = FilmsListCoordinator(navigationController: navigationController)
        coordinate(to: filmsListCoordinator)
        
//        let filmDetailCoordintor = FilmDetailCoordinator(navigationController: navigationController)
//        coordinate(to: filmDetailCoordintor)
    }
}
