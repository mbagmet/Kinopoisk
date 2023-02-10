//
//  Communicator.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 19.01.2023.
//

import Foundation

protocol Communicator {
    func subscribe<T>(subscriberId: String, completion: @escaping (T) -> Void)
    func update<T>(data: T)
    func unsubscribe(subscriberId: String)
}
