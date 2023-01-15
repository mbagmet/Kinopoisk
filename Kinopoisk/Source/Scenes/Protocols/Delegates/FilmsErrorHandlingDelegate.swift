//
//  FilmsErrorHandlingDelegate.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 15.01.2023.
//

import Foundation

protocol FilmsErrorHandlingDelegate: AnyObject {
    func showAlert(message: String?)
}
