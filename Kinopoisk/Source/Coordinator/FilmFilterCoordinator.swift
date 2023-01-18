//
//  FilmFilterCoordinator.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 16.01.2023.
//

import UIKit

class FilmFilterCoordinator: Coordinator {
    
    // MARK: - Properties
    
    var navigationController: UINavigationController
    
    // MARK: - Initializers
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    
    func start() {
        let filterViewController = FilmsFilterViewController()
        let viewModel = FilmsFilterViewModel()
        
        filterViewController.coordinator = self
        filterViewController.viewModel = viewModel
        
        filterViewController.modalPresentationStyle = .popover
        if let popover = filterViewController.popoverPresentationController {
            let sheet = popover.adaptiveSheetPresentationController
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
        }

        navigationController.present(filterViewController, animated: true, completion: nil)
    }
}
