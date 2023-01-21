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
    var searchQuery: String? { get set }
    var filter: [String]? { get }
    var isLoading: Bool { get set }
    var hasParametersForFiltering: Bool { get }
    
    // MARK: Fetching data
    func fetchMovies(filmName: String?, filter: [String]?, completion: @escaping() -> ())
    func updateFilmsListModel()
    func getFilmsListFromModelOrFilter()
}
