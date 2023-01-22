//
//  FilmsListViewModelDelegate.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 22.01.2023.
//

import Foundation

protocol FilmsListViewModelDelegate: AnyObject {
    func loadNextPage()
}
