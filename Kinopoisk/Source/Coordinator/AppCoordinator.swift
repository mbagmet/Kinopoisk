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
    var dataCommunicator = DataCommunicator()
    
    // MARK: - Initializers
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    
    func start() {
        let filmsListCoordinator = FilmsListCoordinator(navigationController: navigationController, dataCommunicator: dataCommunicator)
        coordinate(to: filmsListCoordinator)
    }
}
