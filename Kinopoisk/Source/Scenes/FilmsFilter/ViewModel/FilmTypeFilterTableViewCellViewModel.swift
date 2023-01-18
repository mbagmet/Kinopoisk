//
//  FilmTypeFilterTableViewCellViewModel.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 17.01.2023.
//

import Foundation

class FilmTypeFilterTableViewCellViewModel: FilmTypeFilterTableViewCellViewModelType {
    
    // MARK: - Model
    
    private var filmTypeCase: Film.FilmType
    
    // MARK: - Properties
    
    var isSelected = false
    
    var categoryTitle: String? {
        return filmTypeCase.displayValue
    }
    
    // MARK: - Initializers
    
    init(filmTypeCase: Film.FilmType, isSelected: Bool) {
        self.filmTypeCase = filmTypeCase
        self.isSelected = isSelected
    }
}
