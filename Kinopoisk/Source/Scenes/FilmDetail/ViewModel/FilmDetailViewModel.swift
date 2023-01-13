//
//  FilmDetailViewModel.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 02.01.2023.
//

import Foundation
import UIKit.UIImage

class FilmDetailViewModel: FilmDetailViewModelType {
    
    // MARK: - Model
    
    var filmID: Int?
    var film: Film?

    // MARK: - Properties
    
    private let networkManager = NetworkManager()
    
    var filmTitleID: String? {
        return String(describing: film?.name) //film?.name ?? film?.names.first?.name
    }
    
    var filmBackgroundImage: Box<UIImage?> = Box(nil)
    var filmLogoImage: Box<UIImage?> = Box(nil)
    var filmTitle: Box<String?> = Box(nil)
    
    // MARK: - Methods
    
    func fetchMovie(completion: @escaping() -> ()) {
        networkManager.fetchFilm(for: filmID) { [weak self] movie in
            self?.film = movie
            completion()
        }
    }
    
    func updateModel() {
        filmTitle = Box(film?.name ?? film?.names.first?.name)
        //filmBackgroundImageURL = Box(film?.backdrop)
    }
    
    // MARK: - Initializers
    
    init(filmID: Int?) {
        self.filmID = filmID
    }
    
    // MARK: - Methods
    
    func getImage(for imageView: UIImageView?, type: ImageType, size: Film.Poster.ImageSize = .big) {
        var imageData: Film.Poster?
        
        switch type {
        case .background:
            if film?.backdrop?.previewURL != nil {
                imageData = film?.backdrop
            } else {
                imageData = film?.poster
            }
        default:
            imageData = film?.logo
        }
        
        imageData?.getImage(size: size, completion: { data in
            guard let data = data else { return }
            imageView?.image = UIImage(data: data)
        })
    }
    
//    func getLogo(for imageView: UIImageView?) {
//        film?.logo?.getImage(completion: { data in
//            guard let data = data else { return }
//            imageView?.image = UIImage(data: data)
//        })
//    }
    
    // MARK: - Private Methods
}

extension FilmDetailViewModel {
    enum ImageType {
        case background
        case logo
    }
}
