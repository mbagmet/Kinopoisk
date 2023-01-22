//
//  FilmsSearchViewModelDelegate.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 15.01.2023.
//

import Foundation

protocol FilmsSearchViewModelDelegate: AnyObject {
    func updateModel(with searchResults: [Film]?)
    func resetModel()
    func askToScrollTableToTop()
}
