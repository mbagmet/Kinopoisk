//
//  FilmsSearchViewModelType.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 15.01.2023.
//

import Foundation

protocol FilmsSearchViewModelType: AnyObject {
    var model: [Film]? { get }
    var delegate: FilmsSearchViewModelDelegate? { get set }
    var errorHandlingDelegate: FilmsErrorHandlingDelegate? { get set }
    
    // MARK: Fetching data
    func fetchMovies(filmName: String?, completion: @escaping() -> ())
    func updateFilmsListModel()
    func getFilmsListFromModel()
}
