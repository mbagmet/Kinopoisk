//
//  FilmsListFlow.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 02.01.2023.
//

import Foundation

protocol FilmsListFlow: AnyObject {
    func coordinateToFilmDetail(viewModel: FilmDetailViewModelType?)
    func coordinateToFilmFilter()
}
