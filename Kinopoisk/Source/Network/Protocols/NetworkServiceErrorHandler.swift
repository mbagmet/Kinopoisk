//
//  NetworkServiceErrorHandler.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 03.01.2023.
//

import Foundation

protocol NetworkServiceErrorHandler {
    var delegate: NetworkServiceDelegate? { get set }
}
