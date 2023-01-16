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
    private var parameters = ["token": kinopoiskAPI.token,
                              "limit": kinopoiskAPI.itemsPerPage,
                              "sortType": kinopoiskAPI.sortType,
                              "sortField": kinopoiskAPI.sortField]

    // MARK: - Methods
    
    func fetchData(filmName: String? = nil, page: Int? = nil, completion: @escaping ([Film], Int, Int) -> ()) {
        addParametersToRequest(filmName: filmName, page: page)
    
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                self.validateResponse(response: response)
            }
            .responseDecodable(of: Films.self) { (response) in
//                debugPrint(response)
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
    
    func fetchFilm(for filmID: Int?, completion: @escaping (Film) -> ()) {
        addParametersToRequest(filmID: filmID)
        
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
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
    
    // MARK: - Private Methods
    
    private func validateResponse(response: AFDataResponse<Data>) {
        switch response.result {
        case .success:
            print("Validation Successful")
        case let .failure(error):
            self.delegate?.handleErrorMessage(message: error.errorDescription?.description)
        }
    }
    
    private func addParametersToRequest(filmName: String? = nil, filmID: Int? = nil, page: Int? = nil) {
        if let name = filmName {
            switch name {
            case "":
                parameters.removeValue(forKey: "search")
                parameters.removeValue(forKey: "field")
            default:
                parameters["search"] = name
                parameters["field"] = kinopoiskAPI.field
            }
        }
        if let id = filmID {
            parameters["search"] = String(id)
            parameters["field"] = kinopoiskAPI.fieldID
        }
        if let page = page {
            parameters["page"] = String(page)
        }
    }
}

extension NetworkManager {
    enum kinopoiskAPI {
        static let domain = "https://api.kinopoisk.dev"
        static let token = "MG7QBWA-KJ8MC4G-JZTTK0F-Q1C8N70"
        static let field = "name"
        static let itemsPerPage = "100"
        static let sortField = "rating.kp"
        static let sortType = "-1"
        static let fieldID = "id"
    }
    
    enum kinopoiskSections {
        case movie
        case person
        case review
        case image
        case season
    }
}
