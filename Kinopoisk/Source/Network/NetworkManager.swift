//
//  NetworkManager.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 03.01.2023.
//

import Alamofire

class NetworkManager: NetworkManagerErrorHandler {
    
    // MARK: - Properties
    
    var delegate: NetworkManagerDelegate?
    
    private var url: String { "\(kinopoiskAPI.domain)/\(kinopoiskSections.movie)" }
    private var parameters = ["token": kinopoiskAPI.token,
                              "limit": kinopoiskAPI.itemsPerPage,
                              "sortType": kinopoiskAPI.sortType,
                              "sortField": kinopoiskAPI.sortField]

    // MARK: - Methods
    
    func fetchData(filmName: String?, completion: @escaping ([Film]) -> ()) {
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
    
        AF.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    print("Validation Successful")
                case let .failure(error):
                    self.delegate?.showAlert(message: error.errorDescription?.description)
                }
            }
            .responseDecodable(of: Films.self) { (response) in
                debugPrint(response)
                guard let films = response.value?.all else { return }
                if films.count == 0 {
                    print("No films found!")
                    self.delegate?.showAlert(message: nil)
                }
                completion(films)
       }
    }
}

extension NetworkManager {
    enum kinopoiskAPI {
        static let domain = "https://api.kinopoisk.dev"
        static let token = "ZQQ8GMN-TN54SGK-NB3MKEC-ZKB8V06"
        static let field = "name"
        static let itemsPerPage = "100"
        static let sortField = "rating.kp"
        static let sortType = "-1"
    }
    
    enum kinopoiskSections {
        case movie
        case person
        case review
        case image
        case season
    }
}
