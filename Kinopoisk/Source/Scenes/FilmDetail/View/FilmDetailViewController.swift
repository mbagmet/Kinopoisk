//
//  FilmDetailViewController.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 02.01.2023.
//

import UIKit

class FilmDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var coordinator: FilmDetailFlow?
    var viewModel: FilmDetailViewModel?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
