//
//  FilmDetailViewController.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 02.01.2023.
//

import UIKit

class FilmDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var coordinator: FilmDetailFlow?
    var viewModel: FilmDetailViewModel?
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: ViewModel configuration
        viewModel?.fetchMovie { [weak self] in
            print("here")
            DispatchQueue.main.async {
                self?.bindViewModel()
            }
        }
        
        // MARK: View Setup
        setupView()
        setupHierarchy()
        setupLayout()
        
        print("viewController initialized")
    }
    
    // MARK: - Views
    
    // MARK: Poster Image
    private lazy var backgroundImage: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .secondarySystemBackground
        imageView.backgroundColor = .secondarySystemBackground

        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    // MARK: Labels
    private lazy var titleLabel = createLabel(fontWeight: .bold, fontSize: 16, numberOfLines: 2)
    
    // MARK: - Settings
    
    private func setupView() {
        view.backgroundColor = .secondarySystemBackground | .systemBackground
    }

    private func setupHierarchy() {
        view.addSubview(titleLabel)
    }

    private func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Private Methods
    
    private func bindViewModel() {
        viewModel?.filmTitle.bind(listener: { filmTitle in
            DispatchQueue.main.async {
                self.titleLabel.text = filmTitle
            }
        })
    }
    
    private func createLabel(fontWeight: UIFont.Weight,
                             fontSize: CGFloat = 14,
                             numberOfLines: Int = 1,
                             textColor: UIColor = .label) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: fontSize, weight: fontWeight)
        label.numberOfLines = numberOfLines
        label.textColor = textColor
        
        return label
    }
}
