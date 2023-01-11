//
//  FilmsListTableViewCell.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 06.01.2023.
//

import UIKit

class FilmsListTableViewCell: UITableViewCell {
    
    static let identifier = "FilmsListTableViewCell"
    
    // MARK: - ViewModel
    
    weak var viewModel: FilmsTableViewCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            
            titleLabel.text = viewModel.filmTitle
            alternativeTitleLabel.text = viewModel.alterntiveTitle
            yearLabel.text = viewModel.year
            ratingLabel.text = viewModel.rating
            
            viewModel.getImage(for: thumbnailImage)
        }
    }
    
    // MARK: - Views
    
    // MARK: Poster Image
    private lazy var thumbnailImage: UIImageView = {
        var imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .secondarySystemBackground
        imageView.backgroundColor = .secondarySystemBackground

        imageView.clipsToBounds = true
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    // MARK: Stack views
    private lazy var mainStackView = createStackView(axis: .vertical, distribution: .equalSpacing, alignment: .leading)
    private lazy var textStackView = createStackView(axis: .vertical, distribution: .equalSpacing, alignment: .leading)
    
    // MARK: Labels
    private lazy var titleLabel = createLabel(fontWeight: .bold, fontSize: Metric.titleFontSize, numberOfLines: Metric.titleNumberOfLines)
    private lazy var alternativeTitleLabel = createLabel(fontWeight: .regular, textColor: .secondaryLabel)
    private lazy var yearLabel = createLabel(fontWeight: .regular, textColor: .secondaryLabel)
    private lazy var ratingLabel = createLabel(fontWeight: .bold, textColor: .white)
    
    // MARK: Auxiliary views
    private lazy var ratingView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGreen
        
        view.clipsToBounds = true
        view.layer.masksToBounds = true
        view.layer.cornerRadius = Metric.ratingCornerRadius
        
        return view
    }()

    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // MARK: View Setup
        setupHierarchy()
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Settings

    private func setupHierarchy() {
        self.addSubview(thumbnailImage)
        self.addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(textStackView)
        mainStackView.addArrangedSubview(ratingView)
        
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(alternativeTitleLabel)
        textStackView.addArrangedSubview(yearLabel)
        
        ratingView.addSubview(ratingLabel)
    }

    private func setupLayout() {
        thumbnailImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Metric.horizontalOffset)
            make.top.equalToSuperview().offset(Metric.verticalOffset)
            make.trailing.equalTo(mainStackView.snp.leadingMargin).offset(-Metric.horizontalOffset)
            make.bottom.equalToSuperview().offset(-Metric.verticalOffset)
            make.width.equalTo(thumbnailImage.snp.height).dividedBy(Metric.posterRatio)
        }
        
        mainStackView.snp.makeConstraints { make in
            make.leading.equalTo(thumbnailImage.snp.trailing).offset(Metric.horizontalOffset)
            make.top.equalToSuperview().offset(Metric.verticalOffset)
            make.trailing.equalToSuperview().offset(-Metric.horizontalOffset)
            make.bottom.equalToSuperview().offset(-Metric.verticalOffset)
        }
        
        ratingView.snp.makeConstraints { make in
            make.height.equalTo(Metric.ratingHeight)
            make.width.equalTo(Metric.ratingWidth)
        }
        
        ratingLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    // MARK: - Private functions

    private func createStackView(axis: NSLayoutConstraint.Axis, distribution: UIStackView.Distribution, alignment: UIStackView.Alignment) -> UIStackView {
        let stackView = UIStackView()

        stackView.axis = axis
        stackView.distribution = distribution
        stackView.spacing = Metric.stackViewSpacing
        stackView.alignment = alignment

        return stackView
    }
    
    private func createLabel(fontWeight: UIFont.Weight,
                             fontSize: CGFloat = Metric.defaultFontSize,
                             numberOfLines: Int = Metric.defaultNumberOfLines,
                             textColor: UIColor = .label) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: fontSize, weight: fontWeight)
        label.numberOfLines = numberOfLines
        label.textColor = textColor
        
        return label
    }
}

// MARK: - Constants

extension FilmsListTableViewCell {
    enum Metric {
        static let stackViewSpacing: CGFloat = 2
        static let verticalOffset: CGFloat = 10
        static let horizontalOffset: CGFloat = 20
        
        static let posterRatio: CGFloat = 1.48
        
        static let ratingHeight: CGFloat = 18
        static let ratingWidth: CGFloat = 32
        static let ratingCornerRadius: CGFloat = 3
        
        static let defaultFontSize: CGFloat = 14
        static let titleFontSize: CGFloat = 16
        
        static let defaultNumberOfLines: Int = 1
        static let titleNumberOfLines: Int = 2
    }
}
