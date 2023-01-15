//
//  FilmDetailViewModel.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 02.01.2023.
//

import Foundation
import UIKit.UIImage

class FilmDetailViewModel: FilmDetailViewModelType {
    
    // MARK: - Model
    
    var filmID: Int?
    private var film: Film?

    // MARK: - Private properties
    
    private let networkManager = NetworkManager()
    private var hasLogo = false
    
    // MARK: - Properties

    var filmBackgroundImage: Box<UIImage?> = Box(nil)
    var filmLogoImage: Box<UIImage?> = Box(nil)
    var filmTitle: Box<String?> = Box(nil)
    var ratingKp: Box<String?> = Box(nil)
    var votesKp: Box<String?> = Box(nil)
    var alterntiveTitle: Box<String?> = Box(nil)
    var yearGenresRow: Box<String?> = Box(nil)
    var countryLengthAgeRow: Box<String?> = Box(nil)
    var shortDescription: Box<String?> = Box(nil)
    var description: Box<String?> = Box(nil)
    var mainActors: Box<String?> = Box(nil)
    
    // MARK: - Initializers
    
    init(filmID: Int?) {
        self.filmID = filmID
    }
    
    // MARK: - Methods
    
    func fetchMovie(completion: @escaping() -> ()) {
        networkManager.fetchFilm(for: filmID) { [weak self] movie in
            self?.film = movie
            completion()
        }
    }
    
    func updateModel() {
        
        //MARK: Title
        updateTitle()
        
        //MARK: Rating and votes
        updateRatingAndVotes()
        
        // MARK: Alternative title
        alterntiveTitle.value = film?.alternativeName
        
        // MARK: Year, genre
        updateYearAndGenre()
        
        // MARK: Country, Movie length, Age rating
        updateCountryLeightAge()
        
        // MARK: Main Actors
        updateMainActors()

        // MARK: Short Description
        shortDescription.value = film?.shortDescription
        
        // MARK: Description
        description.value = film?.description
    }
    
    func getImage(for imageView: UIImageView?, type: ImageType, size: Film.Poster.ImageSize = .big) {
        var imageData: Film.Poster?
        
        switch type {
        case .background:
            if film?.backdrop?.previewURL != nil {
                imageData = film?.backdrop
            } else {
                imageData = film?.poster
            }
        default:
            imageData = film?.logo
        }
        
        imageData?.getImage(size: size, completion: { data in
            guard let data = data else { return }
            imageView?.image = UIImage(data: data)
            
            if type == .logo {
                self.hasLogo = true
                self.updateModel()
            }
        })
    }
}

// MARK: - Private Methods for update
extension FilmDetailViewModel {
    
    //MARK: Title
    private func updateTitle() {
        delay(delay: Metric.titleUpdateDelay) {
            if self.hasLogo {
                self.filmTitle.value = nil
            } else {
                self.filmTitle.value = self.film?.name ?? self.film?.names.first?.name
            }
        }
    }
    
    //MARK: Rating and votes
    private func updateRatingAndVotes() {
        if let rating = film?.rating.kp {
           ratingKp.value = String(format: "%.1f", rating)
        }
        if let votes = film?.votes.kp {
            votesKp.value = String(format: "%.0f", votes) + Strings.votesTitle
        }
    }
    
    // MARK: Year, genre
    private func updateYearAndGenre() {
        var yearGenresArray = [String?]()
        
        if let year = self.film?.year {
            yearGenresArray.append(String(year))
        }
        
        if let genres = film?.genres {
            for index in 0..<genres.count {
                if index == Metric.maxGenres { break }
                yearGenresArray.append(genres[index].name)
            }
        }

        yearGenresRow.value = yearGenresArray.compactMap { $0 }.joined(separator: ", ")
    }
    
    // MARK: Country, Movie length, Age rating
    private func updateCountryLeightAge() {
        var countryLengthAgeArray = [String?]()
        
        if let countries = self.film?.countries {
            for index in 0..<countries.count {
                countryLengthAgeArray.append(countries[index].name)
            }
        }
        if let movieLength = self.film?.movieLength {
            countryLengthAgeArray.append(convertMinutesToString(movieLength: movieLength))
        }
        
        if let ageRating = self.film?.ageRating {
            countryLengthAgeArray.append("\(ageRating)+")
        }
        
        countryLengthAgeRow.value = countryLengthAgeArray.compactMap { $0 }.joined(separator: ", ")
    }
    
    // MARK: Main Actors
    private func updateMainActors() {
        var mainActorsArray = [String?]()
        
        if let actors = self.film?.persons {
            for index in 0..<actors.count {
                if index == Metric.maxMainActors { break }
                mainActorsArray.append(actors[index].name)
            }
        }
        
        let actors = mainActorsArray.compactMap({ $0 }).joined(separator: ", ")
        if actors != "" {
            mainActors.value = Strings.castTitle + actors + Strings.castOthers
        }
    }
}

// MARK: Auxiliary Methods
extension FilmDetailViewModel {
    private func delay(delay: Double, clousure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(wallDeadline: .now() + delay) {
            clousure()
        }
    }
    
    private func convertMinutesToString(movieLength: Int) -> String? {
        let timeInterval = TimeInterval(movieLength * 60)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.zeroFormattingBehavior = .default
        formatter.allowedUnits = [.hour, .minute]

        return formatter.string(from: timeInterval)
    }
}

// MARK: - Constatnts
extension FilmDetailViewModel {
    enum Metric {
        static let titleUpdateDelay = 0.5
        static let maxGenres = 2
        static let maxMainActors = 4
    }
    
    enum Strings {
        static let castTitle = "В ролях: "
        static let castOthers = " и другие"
        static let votesTitle = " голосов"
    }
}

extension FilmDetailViewModel {
    enum ImageType {
        case background
        case logo
    }
}
