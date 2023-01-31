//
//  NetworkManager.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 03.01.2023.
//

import Alamofire
import Foundation

class NetworkManager {
    
    // MARK: - Properties
    
    var delegate: NetworkManagerErrorHandlerDelegate?
    
    private var url: String { "\(kinopoiskAPI.domain)/\(kinopoiskSections.movie)" }
    private var parameters = ["token": [kinopoiskAPI.token],
                              "limit": [kinopoiskAPI.itemsPerPage],
                              "sortType": [kinopoiskAPI.sortType],
                              "sortField": [kinopoiskAPI.sortField]]
    
    private typealias ParametersDictionary = [String: [String: [String]]]
    private var parametersDictionary: ParametersDictionary = [:]

    // MARK: - Methods
    
    // MARK: - Fetch data for Films list, searching and filtering
    func fetchData(filmName: String? = nil, page: Int? = nil, filter: [String]? = nil, completion: @escaping ([Film], Int, Int) -> ()) {
        addParametersToRequest(filmName: filmName, page: page, filter: filter)
    
        AF.request(url, method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(arrayEncoding: .noBrackets)))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                self.validateResponse(response: response)
            }
            .responseDecodable(of: Films.self) { (response) in
                //debugPrint(response)
                guard let films = response.value?.all else { return }
                if films.count == 0 {
                    self.delegate?.handleErrorMessage(message: CommonStrings.failureMessageText)
                }
                guard let page = response.value?.page,
                      let totalPages = response.value?.pages
                else { return }
                
                completion(films, page, totalPages)
            }
    }
    
    // MARK: - Fetch data for Film detail
    func fetchFilm(for filmID: Int?, completion: @escaping (Film) -> ()) {
        addParametersToRequest(filmID: filmID)
        
        AF.request(url, method: .get, parameters: parameters, encoder: URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(arrayEncoding: .noBrackets)))
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                self.validateResponse(response: response)
            }
            .responseDecodable(of: Film.self) { (response) in
                //debugPrint(response)
                guard let film = response.value else { return }
                completion(film)
            }
    }
    
    // MARK: - Uses to remove searching parameter when search field cleared
    func removeParameterFromRequest(field: String) {
        parametersDictionary.removeValue(forKey: field)
    }
    
    // MARK: - Private Methods
    
    private func validateResponse(response: AFDataResponse<Data>) {
        switch response.result {
        case .success:
            print("Validation Successful")
        case let .failure(error):
            self.delegate?.handleErrorMessage(message: error.errorDescription?.description)
        }
    }
    
    private func addParametersToRequest(filmName: String? = nil, filmID: Int? = nil, page: Int? = nil, filter: [String]? = nil) {
        
        parametersDictionary = [:]
        
        updateValuesAtParametersDictionary(field: kinopoiskAPI.fieldName, value: filmName)
        updateValuesAtParametersDictionary(field: kinopoiskAPI.fieldType, values: filter)
        
        if let filmID = filmID {
            updateValuesAtParametersDictionary(field: kinopoiskAPI.fieldID, value: String(filmID))
        }
        if let page = page {
            updateValuesAtParametersDictionary(field: kinopoiskAPI.fieldPage, key: kinopoiskAPI.fieldPage, value: String(page))
        }
        
        makeParametersForRequest()
    }
    
    private func updateValuesAtParametersDictionary(field: String,
                                                    key: String = kinopoiskAPI.search,
                                                    value: String? = nil,
                                                    values: [String]? = nil) {
        if let parameterValues = values {
            parametersDictionary[field] = [key: parameterValues]
        } else if let parameterValue = value {
            parametersDictionary[field] = [key: [parameterValue]]
        } else {
            parametersDictionary.removeValue(forKey: field)
        }
    }
    
    private func makeParametersForRequest() {
        var fieldValues = [String]()
        var searchValues: [String]?
        
        for (mainKey, mainValue) in parametersDictionary {
            for (key, value) in mainValue {
                if key == kinopoiskAPI.search {
                    
                    // MARK: fields
                    fieldValues = fieldValues + Array(repeating: mainKey, count: value.count)
                    parameters.updateValue(fieldValues, forKey: kinopoiskAPI.field)
                    
                    // MARK: values array
                    searchValues = (searchValues ?? []) + value
                    
                } else {
                    parameters.updateValue(value, forKey: key)
                }
            }
        }
        
        guard let searchValues = searchValues else { return }
        parameters.updateValue(searchValues, forKey: kinopoiskAPI.search)
    }
}

extension NetworkManager {
    enum kinopoiskAPI {
        static let domain = "https://api.kinopoisk.dev"
        static let token = "EAFNMQM-5M1MBJM-HER29SG-6Y1K8HN"
        static let fieldName = "name"
        static let search = "search"
        static let field = "field"
        static let itemsPerPage = "100"
        static let sortField = "rating.kp"
        static let sortType = "-1"
        static let fieldID = "id"
        static let fieldType = "type"
        static let fieldPage = "page"
    }
    
    enum kinopoiskSections {
        case movie
        case person
        case review
        case image
        case season
    }
}
