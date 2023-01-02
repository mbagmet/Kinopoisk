//
//  FilmsListViewController.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 02.01.2023.
//

import UIKit

class FilmsListViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var coordinator: FilmsListFlow?
    var viewModel: FilmsListViewModel?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemCyan
        navigationController?.title = "Фильмы"
    }
}
