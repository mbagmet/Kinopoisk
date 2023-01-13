//
//  FilmDetailViewModelType.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 08.01.2023.
//

import UIKit.UIImage

protocol FilmDetailViewModelType: AnyObject {
    func fetchMovie(completion: @escaping() -> ())
    func updateModel()
    func getImage(for imageView: UIImageView?, type: FilmDetailViewModel.ImageType, size: Film.Poster.ImageSize)
}
