//
//  DataCommunicator.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 19.01.2023.
//

import Foundation

class DataCommunicator: Communicator {
    private var subscribers: [String: Any] = [:]
    private var data: Any?
    
    func subscribe<T>(subscriberId: String, completion: @escaping (T) -> Void) {
        subscribers[subscriberId] = completion
        if let data = data as? T {
            completion(data)
        }
    }

    func update<T>(data: T) {
        self.data = data
        for (_, completion) in subscribers {
            if let completion = completion as? (T) -> Void {
                completion(data)
            }
        }
    }

    func unsubscribe(subscriberId: String) {
        subscribers.removeValue(forKey: subscriberId)
    }
}
