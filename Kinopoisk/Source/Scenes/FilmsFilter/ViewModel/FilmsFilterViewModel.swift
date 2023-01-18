//
//  FilmsFilterViewModel.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 16.01.2023.
//

import Foundation

class FilmsFilterViewModel: FilmsFilterViewModelType {

    // MARK: - Properties
    
    var filmType: [Film.FilmType: String]?
    var selectedFilmTypes: [Film.FilmType] = []
    
    private var keys: [Film.FilmType]?
    private var selectedIndexPath: IndexPath?
    
    // MARK: - Initializers
    
    init() {
        self.filmType = generateFilterData()
        self.keys = filmType?.keys.sorted()
        print("FilmsFilterViewModel initialzed")
    }
    
    // MARK: - Methods
    
    func numberOfRows() -> Int {
        return filmType?.values.count ?? 0
    }
    
    func makeCellViewModel(forIndexPath indexPath: IndexPath) -> FilmTypeFilterTableViewCellViewModelType? {
        guard let type = keys?[indexPath.row] else { return nil }

        let isSelected = selectedFilmTypes.contains(type) ? true : false

        print("Make model for cell \(type), \(isSelected)")
        
        return FilmTypeFilterTableViewCellViewModel(filmTypeCase: type, isSelected: isSelected)
    }
    
    func selectRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    func selectOptions(completion: @escaping () -> ()) {
        guard let selectedIndexPath = selectedIndexPath,
              let option = keys?[selectedIndexPath.row]
        else { return }

        if !selectedFilmTypes.contains(option) {
            selectedFilmTypes.append(option)
        } else if let index = selectedFilmTypes.firstIndex(of: option) {
            selectedFilmTypes.remove(at: index)
        }
        
        print(selectedFilmTypes)
        completion()
    }
    
    func setSectionName() -> String? {
        return Film.FilmType.localizedTitle
    }
    
    // MARK: - Private Methods
    
    private func generateFilterData() -> [Film.FilmType: String] {
        var data: [Film.FilmType: String] = [:]
        for option in Film.FilmType.allCases {
            data[option] = option.displayValue
        }
        return data
    }
}
