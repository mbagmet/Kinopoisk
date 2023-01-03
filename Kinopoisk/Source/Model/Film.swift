//
//  Film.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 03.01.2023.
//

import Foundation

// MARK: - Film

struct Film: Decodable {
    let externalID: ExternalID
    let logo: Logo
    let poster: Poster?
    let backdrop: Poster?
    let rating: Rating
    let votes: Rating
    let videos: Videos?
    let budget: Budget?
    let fees: Fees?
    let distributors: Distributors?
    let premiere: Premiere?
    let images: Images?
    let watchability: Watchability
    let collections, updateDates: [JSONAny]
    let status: String
    let productionCompanies: [ProductionCompany]
    let spokenLanguages: [SpokenLanguage]
    let id: Int
    let type: FilmType
    let name: String?
    let description: String?
    let year: Int?
    let facts: [Fact]
    let genres, countries: [Country]
    let seasonsInfo: [JSONAny]
    let persons: [Person]
    let lists: [JSONAny]
    let typeNumber: Int
    let alternativeName: String?
    let enName: JSONNull?
    let movieLength: Int?
    let names: [Name]
    let updatedAt, ratingMPAA: String
    let shortDescription: String?
    let technology: Technology
    let ticketsOnSale: Bool
    let sequelsAndPrequels: [SequelsAndPrequel]
    let similarMovies: [JSONAny]
    let imagesInfo: ImagesInfo
    let ageRating: Int
    let top10: JSONNull?
    let top250: Int
    let createDate: String
    let releaseYears: [JSONAny]
    
    enum CodingKeys: String, CodingKey {
        case externalID = "eternalId"
        case logo, poster, backdrop, rating, votes, videos, budget, fees, distributors, premiere, images, watchability, collections, updateDates, status, productionCompanies, spokenLanguages, id, type, name, description, year, facts, genres, countries, seasonsInfo, persons, lists, typeNumber, alternativeName, enName, movieLength, names, updatedAt
        case ratingMPAA = "ratingMpaa"
        case shortDescription, technology, ticketsOnSale, sequelsAndPrequels, similarMovies, imagesInfo, ageRating, top10, top250, createDate, releaseYears
    }
}

extension Film {
    // MARK: - ExternalID
    struct ExternalID: Decodable {
        let kpHD: String?
        let imdb: String?
        let id: String
        let tmdb: Int?

        enum CodingKeys: String, CodingKey {
            case kpHD, imdb
            case id = "_id"
            case tmdb
        }
    }

    // MARK: - Logo
    struct Logo: Decodable {
        let id: String
        let url: String?

        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case url
        }
    }

    // MARK: - Name
    struct Name: Decodable {
        let id: String
        let name: String

        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case name
        }
    }

    // MARK: - Poster
    struct Poster: Decodable {
        let id: String
        let url: String
        let previewURL: String

        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case url
            case previewURL = "previewUrl"
        }
    }

    // MARK: - Rating
    struct Rating: Decodable {
        let id: String
        let kp: Double
        let imdb: Int
        let filmCritics: Int
        let russianFilmCritics: Int
        let ratingAwait: Double

        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case kp, imdb, filmCritics, russianFilmCritics
            case ratingAwait = "await"
        }
    }

    enum FilmType: String, Decodable {
        case cartoon = "cartoon"
        case movie = "movie"
    }
    
    // MARK: - Videos
    struct Videos: Decodable {
        let id: String
        let trailers: [Trailer]
        let teasers: [JSONAny]

        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case trailers, teasers
        }
    }
    
    // MARK: - Trailer
    struct Trailer: Decodable {
        let url: String
        let name, site, type, id: String

        enum CodingKeys: String, CodingKey {
            case url, name, site, type
            case id = "_id"
        }
    }
    
    // MARK: - Budget
    struct Budget: Decodable {
        let id: String
        let value: Int
        let currency: String

        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case value, currency
        }
    }
    
    // MARK: - Fees
    struct Fees: Decodable {
        let world, russia, usa: Budget
        let id: String

        enum CodingKeys: String, CodingKey {
            case world, russia, usa
            case id = "_id"
        }
    }
    
    // MARK: - Distributors
    struct Distributors: Decodable {
        let distributor, distributorRelease: String
    }
    
    // MARK: - Premiere
    struct Premiere: Decodable {
        let id, country, world, russia: String
        let cinema, dvd, bluray: String

        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case country, world, russia, cinema, dvd, bluray
        }
    }
    
    // MARK: - Images
    struct Images: Decodable {
        let postersCount, backdropsCount, framesCount: Int
    }
    
    // MARK: - ImagesInfo
    struct ImagesInfo: Codable {
        let id: String
        let framesCount: Int

        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case framesCount
        }
    }

    // MARK: - Watchability
    struct Watchability: Decodable {
        let id: String
        let items: [Item]?

        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case items
        }
    }
    
    // MARK: - ProductionCompany
    struct ProductionCompany: Decodable {
        let name: String
        let url, previewURL: String

        enum CodingKeys: String, CodingKey {
            case name, url
            case previewURL = "previewUrl"
        }
    }
    
    // MARK: - SpokenLanguage
    struct SpokenLanguage: Decodable {
        let name, nameEn: String
    }
    
    // MARK: - Fact
    struct Fact: Decodable {
        let value: String
        let type: TypeEnum
        let spoiler: Bool
    }

    enum TypeEnum: String, Decodable {
        case fact = "FACT"
    }
    
    // MARK: - Country
    struct Country: Decodable {
        let name: String
    }
    
    // MARK: - Person
    struct Person: Codable {
        let id: Int
        let photo: String
        let name, enName: String?
        let enProfession: EnProfession
    }

    enum EnProfession: String, Codable {
        case actor = "actor"
        case composer = "composer"
        case designer = "designer"
        case director = "director"
        case editor = "editor"
        case enProfessionOperator = "operator"
        case producer = "producer"
        case voiceActor = "voice_actor"
        case writer = "writer"
    }
    
    // MARK: - Technology
    struct Technology: Codable {
        let id: String
        let hasImax, has3D: Bool

        enum CodingKeys: String, CodingKey {
            case id = "_id"
            case hasImax, has3D
        }
    }
    
    // MARK: - SequelsAndPrequel
    struct SequelsAndPrequel: Codable {
        let id: String

        enum CodingKeys: String, CodingKey {
            case id = "_id"
        }
    }

    // MARK: - Item
    struct Item: Decodable {
        let logo: Logo
        let name: String
        let url: String
        let id: String

        enum CodingKeys: String, CodingKey {
            case logo, name, url
            case id = "_id"
        }
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Decodable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(0)
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Decodable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
