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
    var dataCommunicator: DataCommunicator
    var defaultData: [Film.FilmType]
    
    // MARK: - Initializers
    
    init(navigationController: UINavigationController, dataCommunicator: DataCommunicator, defaultData: [Film.FilmType]?) {
        self.navigationController = navigationController
        self.dataCommunicator = dataCommunicator
        self.defaultData = defaultData ?? []
    }
    
    // MARK: - Methods
    
    func start() {
        let filterViewController = FilmsFilterViewController()
        let viewModel = FilmsFilterViewModel(dataCommunicator: dataCommunicator, defaultData: defaultData)
        
        filterViewController.coordinator = self
        filterViewController.viewModel = viewModel
        filterViewController.viewModel?.selectedFilmTypes = defaultData
        
        filterViewController.modalPresentationStyle = .popover
        if let popover = filterViewController.popoverPresentationController {
            let sheet = popover.adaptiveSheetPresentationController
            sheet.detents = [.medium()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
        }

        navigationController.present(filterViewController, animated: true, completion: nil)
    }
}
