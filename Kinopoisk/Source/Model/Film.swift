//
//  Film.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 03.01.2023.
//

import Foundation

// MARK: - Film

struct Film: Decodable {
    let logo: Poster?
    let poster: Poster?
    let backdrop: Poster?
    let rating: Rating
    let votes: Rating
    let id: Int
    let type: FilmType
    let name: String?
    let description: String?
    let year: Int?
    let facts: [Fact]?
    let genres: [Genre]?
    let countries: [Country]?
    let persons: [Person]?
    let alternativeName: String?
    let movieLength: Int?
    let names: [Name]
    let shortDescription: String?
    let ageRating: Int?
}

extension Film {

    // MARK: - Name
    struct Name: Decodable {
        let name: String
    }

    // MARK: - Poster, Backdrop, Logo
    struct Poster: Decodable {
        let url: String?
        let previewURL: String?
        
        func getImage(size: ImageSize = .big, queue: DispatchQueue = DispatchQueue.global(qos: .utility), completion: @escaping (Data?) -> ()) {
            var data: Data?
            
            let workItem = DispatchWorkItem {
                guard let imageURL = URL(string: "\(size == .small ? previewURL ?? "" : url ?? "")"),
                      let imageData = try? Data(contentsOf: imageURL)
                else { return }
                data = imageData
            }
            
            workItem.notify(queue: .main) {
                completion(data)
            }
            
            queue.async(execute: workItem)
        }
        
        enum ImageSize {
            case small
            case big
        }
        
        enum CodingKeys: String, CodingKey {
            case url
            case previewURL = "previewUrl"
        }
    }

    // MARK: - Rating
    struct Rating: Codable {
        let kp: Double
        let imdb: Double
        let filmCritics: Double
        let russianFilmCritics: Double
        let await: Double
    }

    // MARK: - FilmType
    enum FilmType: String, CaseIterable, Comparable, Decodable {
        case movie = "movie"
        case tvSeries = "tv-series"
        case cartoon = "cartoon"
        case animatedSeries = "animated-series"
        case anime = "anime"

        var displayValue: String {
            switch self {
            case .movie: return "Фильмы"
            case .tvSeries: return "Сериалы"
            case .cartoon: return "Мультфильмы"
            case .animatedSeries: return "Многосерийные мультфильмы"
            case .anime: return "Аниме"
            }
        }
        
        static let localizedTitle = "Категория"
        
        static func < (lhs: FilmType, rhs: FilmType) -> Bool {
            return lhs.displayValue < rhs.displayValue
        }
    }
    
    // MARK: - Trailer
    struct Trailer: Decodable {
        let url: String?
        let name: String?
        let site: String?
        let type: String?
    }

    // MARK: - Fact
    struct Fact: Decodable {
        let value: String?
        let spoiler: Bool?
    }
    
    // MARK: - Genre
    struct Genre: Decodable {
        let name: String?
    }
    
    // MARK: - Country
    struct Country: Decodable {
        let name: String?
    }
    
    // MARK: - Person
    struct Person: Decodable {
        let photo: String?
        let name: String?
        let enName: String?
        let enProfession: Profession?
    }

    enum Profession: String, Decodable {
        case actor = "actor"
        case composer = "composer"
        case designer = "designer"
        case director = "director"
        case editor = "editor"
        case enProfessionOperator = "operator"
        case producer = "producer"
        case voiceActor = "voice_actor"
        case writer = "writer"
        case other
        
        init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            let professionString = try container.decode(String.self)
            switch professionString {
                case "actor": self = .actor
                case "composer": self = .composer
                case "designer": self = .designer
                case "director": self = .director
                case "editor": self = .editor
                case "operator": self = .enProfessionOperator
                case "producer": self = .producer
                case "voice_actor": self = .voiceActor
                case "writer": self = .writer
                default: self = .other
            }
        }
    }
}
