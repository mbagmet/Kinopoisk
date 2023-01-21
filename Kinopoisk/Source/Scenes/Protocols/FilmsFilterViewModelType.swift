//
//  FilmsFilterViewModelType.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 16.01.2023.
//

import Foundation

protocol FilmsFilterViewModelType {
    
    // MARK: - Properties
    
    var filmType: [Film.FilmType: String]? { get }
    var selectedFilmTypes: [Film.FilmType] { get set }
    var isFiltering: Bool { get set }
    
    func numberOfRows() -> Int
    func makeCellViewModel(forIndexPath indexPath: IndexPath) -> FilmTypeFilterTableViewCellViewModelType?
    func selectRow(atIndexPath indexPath: IndexPath)
    func selectOptions(completion: @escaping () -> ())
    func setSectionName() -> String?
}
