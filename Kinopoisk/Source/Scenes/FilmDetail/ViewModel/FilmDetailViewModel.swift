//
//  FilmDetailViewModel.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 02.01.2023.
//

import Foundation

class FilmDetailViewModel: FilmDetailViewModelType {
    
    // MARK: - Model
    
    var filmID: Int?
    var film: Film?

    // MARK: - Properties
    
    private let networkManager = NetworkManager()
    
    var filmTitleID: String? {
        return String(describing: film?.name) //film?.name ?? film?.names.first?.name
    }
    
    var filmTitle: Box<String?> = Box(nil)
    
    // MARK: - Methods
    
    func fetchMovie(completion: @escaping() -> ()) {
        networkManager.fetchData(filmID: filmID) { [weak self] movies in
            self?.film = movies.first
            completion()
        }
    }
    
    // MARK: - Initializers
    
    init(filmID: Int?) {
        //self.film = film
        self.filmID = filmID
    }
}
