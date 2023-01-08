//
//  FilmsTableViewCellViewModel.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 06.01.2023.
//

import UIKit.UIImage

class FilmsTableViewCellViewModel: FilmsTableViewCellViewModelType {
    
    // MARK: - Model
    
    private var film: Film

    // MARK: - Properties
    
    //static var poster: UIImage?
    var filmTitle: String? {
        return film.name ?? film.names.first?.name
    }
    var alterntiveTitle: String? {
        return film.alternativeName ?? nil
    }
    var year: String {
        guard let year = film.year else { return "" }
        return String(year)
    }
    var rating: String? {
        return String(format: "%.1f", film.rating.kp)
    }
    
    // MARK: - Initializers
    
    init(film: Film) {
        self.film = film
    }
    
    // MARK: - Private methods
    
    func getImage(for imageView: UIImageView?) {
        film.poster?.getImage(size: .small, completion: { data in
            guard let data = data else { return }
            imageView?.image = UIImage(data: data)
        })
    }
}
