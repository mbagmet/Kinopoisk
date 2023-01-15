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
            DispatchQueue.main.async {
                self?.viewModel?.getImage(for: self?.backgroundImage, type: .background, size: .small)
                self?.viewModel?.getImage(for: self?.logoImage, type: .logo)
                self?.viewModel?.updateModel()
                self?.bindViewModel()
            }
        }
        
        // MARK: View Setup
        setupView()
        setupHierarchy()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // MARK: Navigation
        setupNavigation()
    }
    
    // MARK: - Views
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var mainContainer = UIView()
    private lazy var blackContainer = UIView()
    private lazy var contentContainer = UIView()
    
    // MARK: StackViews
    private lazy var mainStackView = UIStackView.createStackView(axis: .vertical, distribution: .equalSpacing, alignment: .center, spacing: Metric.mainStackViewSpacing)
    private lazy var ratingStackView = UIStackView.createStackView(axis: .horizontal, distribution: .equalSpacing, alignment: .center, spacing: Metric.ratingStackViewSpacing)
    private lazy var contentStackView = UIStackView.createStackView(axis: .vertical, distribution: .fill, alignment: .top, spacing: Metric.contentStackViewSpacing)

    // MARK: Poster Image
    private lazy var backgroundImage = UIImageView.createImageView(contentMode: .scaleAspectFill, backgroundColor: .systemGray)
    private lazy var gradientImage = UIImageView.createImageView(contentMode: .scaleAspectFit, image: UIImage(named: "GradientBackground"))
    private lazy var logoImage = UIImageView.createImageView(contentMode: .scaleAspectFit)
    
    // MARK: Labels
    private lazy var titleLabel = UILabel.createLabel(fontWeight: .black,
                                                      fontSize: Metric.titleFontSize,
                                                      numberOfLines: CommonMetrics.titleNumberOfLines,
                                                      textColor: .white,
                                                      textAlignment: .center)
    private lazy var ratingLabel = UILabel.createLabel(fontWeight: .bold,textColor: .white)
    private lazy var votesLabel = UILabel.createLabel(textColor: .systemGray)
    private lazy var alternativeTitleLabel = UILabel.createLabel(textColor: .white, textAlignment: .center)
    private lazy var yearGenresLabel = UILabel.createLabel(textColor: .systemGray, textAlignment: .center)
    private lazy var countryLengthAgeLabel = UILabel.createLabel(textColor: .systemGray, textAlignment: .center)
    private lazy var mainActorsLabel = UILabel.createLabel(numberOfLines: Metric.mainActorNumberOfLines, textColor: .systemGray, textAlignment: .center)
    private lazy var shortDescriptionLabel = UILabel.createLabel(fontWeight: .bold, numberOfLines: Metric.descriptionNumberOfLines, textColor: .label)
    private lazy var descriptionLabel = UILabel.createLabel(numberOfLines: Metric.descriptionNumberOfLines, textColor: .label)
    
    // MARK: Auxiliary views
    private lazy var ratingView: UIView = {
        let view = UIView()
        
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = Metric.ratingCornerRadius
        
        return view
    }()
    
    // MARK: Line Separators
    private lazy var lineSeparator = makeLineSeparator()
    
    // MARK: - Settings
    
    private func setupView() {
        view.backgroundColor = .secondarySystemBackground | .systemBackground
        blackContainer.backgroundColor = .black
        
        scrollView.contentInsetAdjustmentBehavior = .never
    }

    private func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(mainContainer)
        mainContainer.addSubview(backgroundImage)
        mainContainer.addSubview(gradientImage)
        mainContainer.addSubview(blackContainer)
        
        blackContainer.addSubview(logoImage)
        blackContainer.addSubview(titleLabel)
        blackContainer.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(ratingStackView)
        ratingStackView.addArrangedSubview(ratingView)
        ratingView.addSubview(ratingLabel)
        ratingStackView.addArrangedSubview(votesLabel)
        
        mainStackView.addArrangedSubview(alternativeTitleLabel)
        mainStackView.addArrangedSubview(yearGenresLabel)
        mainStackView.addArrangedSubview(countryLengthAgeLabel)
        mainStackView.addArrangedSubview(mainActorsLabel)
        
        blackContainer.addSubview(lineSeparator)
        
        mainContainer.addSubview(contentContainer)
        contentContainer.addSubview(contentStackView)
        contentStackView.addArrangedSubview(shortDescriptionLabel)
        contentStackView.addArrangedSubview(descriptionLabel)
    }

    private func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        mainContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(view)
        }
        
        backgroundImage.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(Metric.backgroundImageHeight)
        }
        gradientImage.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(Metric.gradientImageTopOffset)
            make.trailing.equalToSuperview()
        }
        blackContainer.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(backgroundImage.snp.bottom)
            make.trailing.equalToSuperview()
        }

        logoImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Metric.logoLeadingOffset)
            make.trailing.equalToSuperview().offset(Metric.logoTrailingOffset)
            make.bottom.equalTo(blackContainer.snp.top)
            make.centerX.equalToSuperview()
            make.height.lessThanOrEqualTo(Metric.logoMaxHeight)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(CommonMetrics.leadingOffset)
            make.trailing.equalToSuperview().offset(CommonMetrics.trailingOffset)
            make.bottom.equalTo(blackContainer.snp.top)
        }

        mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Metric.mainStackViewTopOffset)
            make.leading.equalToSuperview().offset(CommonMetrics.leadingOffset)
            make.trailing.equalToSuperview().offset(CommonMetrics.trailingOffset)
            make.bottom.equalToSuperview().offset(Metric.contentBottomOffset)
        }

        ratingView.snp.makeConstraints { make in
            make.height.equalTo(Metric.ratingHeight)
            make.width.equalTo(Metric.ratingWidth)
        }

        ratingLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        makeLineSeparatorConstraints(line: lineSeparator)
        
        contentContainer.snp.makeConstraints { make in
            make.top.equalTo(blackContainer.snp.bottom)
            make.leading.equalToSuperview().offset(CommonMetrics.leadingOffset)
            make.trailing.equalToSuperview().offset(CommonMetrics.trailingOffset)
            make.bottom.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Metric.contentTopOffset)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(Metric.contentBottomOffset)
        }
    }
    
    // MARK: - Private Methods
    
    private func makeLineSeparator() -> UIView {
        let line = UIView()
        line.layer.borderColor = UIColor.white.cgColor
        line.layer.borderWidth = (Metric.lineWidth / UIScreen.main.scale) / 2

        return line
    }
    
    private func makeLineSeparatorConstraints(line: UIView) {
        line.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(CommonMetrics.leadingOffset)
            make.trailing.equalToSuperview().offset(CommonMetrics.trailingOffset)
            make.bottom.equalToSuperview().offset(-Metric.lineWidth)
            make.height.equalTo(Metric.lineWidth)
        }
    }
}

// MARK: - Navigation
extension FilmDetailViewController {
    private func setupNavigation() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()

        navigationController?.navigationBar.standardAppearance = appearance
        navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = .white
    }
}

// MARK: - Binding
extension FilmDetailViewController {
    private func bindViewModel() {
        viewModel?.filmTitle.bind(listener: { filmTitle in
            DispatchQueue.main.async {
                UIView.transition(with: self.titleLabel, duration: Metric.animationDuration, options: .transitionCrossDissolve, animations: {
                    self.titleLabel.text = filmTitle
                }, completion: nil)
            }
        })
        viewModel?.filmBackgroundImage.bind(listener: { filmBackgroundImage in
            DispatchQueue.main.async {
                UIView.transition(with: self.backgroundImage, duration: Metric.animationDuration, options: .transitionCrossDissolve, animations: {
                    self.backgroundImage.image = filmBackgroundImage
                }, completion: nil)
            }
        })
        viewModel?.filmLogoImage.bind(listener: { filmLogoImage in
            DispatchQueue.main.async {
                UIView.transition(with: self.logoImage, duration: Metric.animationDuration, options: .transitionCrossDissolve, animations: {
                    self.logoImage.image = filmLogoImage
                }, completion: nil)
            }
        })
        viewModel?.ratingKp.bind(listener: { ratingKp in
            DispatchQueue.main.async {
                self.ratingView.backgroundColor = .systemGreen
                self.ratingLabel.text = ratingKp
            }
        })
        viewModel?.votesKp.bind(listener: { votesKp in
            DispatchQueue.main.async {
                self.votesLabel.text = votesKp
            }
        })
        viewModel?.alterntiveTitle.bind(listener: { alterntiveTitle in
            DispatchQueue.main.async {
                self.alternativeTitleLabel.text = alterntiveTitle
            }
        })
        viewModel?.yearGenresRow.bind(listener: { yearGenresRow in
            DispatchQueue.main.async {
                self.yearGenresLabel.text = yearGenresRow
            }
        })
        viewModel?.countryLengthAgeRow.bind(listener: { countryLengthAgeRow in
            DispatchQueue.main.async {
                self.countryLengthAgeLabel.text = countryLengthAgeRow
            }
        })
        viewModel?.mainActors.bind(listener: { mainActors in
            DispatchQueue.main.async {
                self.mainActorsLabel.text = mainActors
            }
        })
        viewModel?.shortDescription.bind(listener: { shortDescription in
            DispatchQueue.main.async {
                self.shortDescriptionLabel.text = shortDescription
            }
        })
        viewModel?.description.bind(listener: { description in
            DispatchQueue.main.async {
                self.descriptionLabel.text = description
            }
        })
    }
}

// MARK: - Constants

extension FilmDetailViewController {
    enum Metric {
        static let backgroundImageHeight: CGFloat = 450
        static let gradientImageTopOffset: CGFloat = 20
        static let mainStackViewTopOffset: CGFloat = 20
        
        static let mainStackViewSpacing: CGFloat = 3
        static let ratingStackViewSpacing: CGFloat = 6
        static let contentStackViewSpacing: CGFloat = 15
        
        static let logoLeadingOffset: CGFloat = 40
        static let logoTrailingOffset: CGFloat = -40
        static let logoMaxHeight: CGFloat = 70
        
        static let contentTopOffset: CGFloat = 30
        static let contentBottomOffset: CGFloat = -30
        
        static let ratingHeight: CGFloat = 22
        static let ratingWidth: CGFloat = 36
        static let ratingCornerRadius: CGFloat = 4
        
        static let titleFontSize: CGFloat = 30
        
        static let mainActorNumberOfLines = 3
        static let descriptionNumberOfLines = 0
        
        static let lineWidth: CGFloat = 1
        
        static let animationDuration = 0.5
    }
}
