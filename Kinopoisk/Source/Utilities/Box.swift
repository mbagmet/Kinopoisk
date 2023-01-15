//
//  Box.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 02.01.2023.
//

import Foundation

final class Box<T> {
    typealias Listener = (T) -> ()
    
    // MARK: - Properties
    
    private var listener: Listener?
    
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    // MARK: - Initializers
    
    init(_ value: T) {
        self.value = value
    }
    
    // MARK: - Methods
    
    func bind(listener: @escaping Listener) {
        self.listener = listener
        listener(value)
    }
}
