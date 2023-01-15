//
//  FilmDetailViewModelType.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 08.01.2023.
//

import UIKit.UIImage

protocol FilmDetailViewModelType: AnyObject {
    var filmBackgroundImage: Box<UIImage?> { get }
    var filmLogoImage: Box<UIImage?> { get }
    var filmTitle: Box<String?> { get }
    var ratingKp: Box<String?> { get }
    var votesKp: Box<String?> { get }
    var alterntiveTitle: Box<String?> { get }
    var yearGenresRow: Box<String?> { get }
    var countryLengthAgeRow: Box<String?> { get }
    var shortDescription: Box<String?> { get }
    var description: Box<String?> { get }
    var mainActors: Box<String?> { get }
    
    func fetchMovie(completion: @escaping() -> ())
    func updateModel()
    func getImage(for imageView: UIImageView?, type: FilmDetailViewModel.ImageType, size: Film.Poster.ImageSize)
}
