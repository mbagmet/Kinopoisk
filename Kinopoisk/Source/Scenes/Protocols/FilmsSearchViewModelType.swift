//
//  FilmsSearchViewModelType.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 15.01.2023.
//

import Foundation

protocol FilmsSearchViewModelType: AnyObject {
    
    // MARK: Delegates
    var delegate: FilmsSearchViewModelDelegate? { get set }
    var errorHandlingDelegate: FilmsErrorHandlingDelegate? { get set }
    
    // MARK: Properties
    var model: [Film]? { get }
    
    // MARK: Fetching data
    func fetchMovies(filmName: String?, completion: @escaping() -> ())
    func updateFilmsListModel()
    func getFilmsListFromModel()
}
