//
//  FilmsFilterViewModel.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 16.01.2023.
//

import Foundation

class FilmsFilterViewModel: FilmsFilterViewModelType {
    
    // MARK: - DataCommunicator
    
    var dataCommunicator: DataCommunicator
    var selectedFilmTypes: [Film.FilmType] = [] {
        didSet {
            dataCommunicator.update(data: selectedFilmTypes)
        }
    }

    // MARK: - Properties
    
    var filmType: [Film.FilmType: String]?
    //var selectedFilmTypes: [Film.FilmType] = []
    
    var selectedFilmTypesChanged: (([Film.FilmType]) -> Void)?
    
    private var keys: [Film.FilmType]?
    private var selectedIndexPath: IndexPath?
    
    // MARK: - Initializers
    
    init(dataCommunicator: DataCommunicator, defaultData: [Film.FilmType]) {
        self.dataCommunicator = dataCommunicator
        self.selectedFilmTypes = defaultData
        self.filmType = generateFilterData()
        self.keys = filmType?.keys.sorted()
    }
    
    // MARK: - Methods
    
    func numberOfRows() -> Int {
        return filmType?.values.count ?? 0
    }
    
    func makeCellViewModel(forIndexPath indexPath: IndexPath) -> FilmTypeFilterTableViewCellViewModelType? {
        guard let type = keys?[indexPath.row] else { return nil }

        let isSelected = selectedFilmTypes.contains(type) ? true : false
        
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
        
        print("FilmsFilterViewModel \(selectedFilmTypes)")
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
