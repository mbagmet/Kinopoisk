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
        
//        mainStackView.backgroundColor = .systemGreen
//        mainContainer.backgroundColor = .systemBlue
//        scrollView.backgroundColor = .systemMint
        blackContainer.backgroundColor = .black
    }
    
    // MARK: - Views
    
    private lazy var scrollView = UIScrollView()
    
    private lazy var mainContainer = UIView()
    private lazy var blackContainer = UIView()
    
    private lazy var mainStackView = UIStackView.createStackView(axis: .vertical, distribution: .fill, alignment: .fill)

    // MARK: Poster Image
    private lazy var backgroundImage = UIImageView.createImageView(contentMode: .scaleAspectFill, backgroundColor: .systemGray)
    private lazy var gradientImage = UIImageView.createImageView(contentMode: .scaleAspectFit, image: UIImage(named: "GradientBackground"))
    private lazy var logoImage = UIImageView.createImageView(contentMode: .scaleAspectFit)
    
    // MARK: Labels
    private lazy var titleLabel = UILabel.createLabel(fontWeight: .medium, fontSize: 24, numberOfLines: 2, textColor: .white)
    
    // MARK: - Settings
    
    private func setupView() {
        view.backgroundColor = .secondarySystemBackground | .systemBackground
    }

    private func setupHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(mainContainer)
        mainContainer.addSubview(backgroundImage)
        mainContainer.addSubview(gradientImage)
        mainContainer.addSubview(blackContainer)
        mainContainer.addSubview(logoImage)
        blackContainer.addSubview(titleLabel)
        //mainContainer.addSubview(mainStackView)
        
        //mainStackView.addArrangedSubview(gradientImage)
        //mainStackView.addArrangedSubview(logoImage)
        //mainStackView.addArrangedSubview(titleLabel)
    }

    private func setupLayout() {
        scrollView.snp.makeConstraints { make in
            make.top.equalToSuperview() //equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()//equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
        }
        mainContainer.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.top)
            make.leading.equalToSuperview()//.offset(CommonMetrics.leadingOffset)
            make.trailing.equalToSuperview()//.offset(CommonMetrics.trailingOffset)
            make.bottom.equalToSuperview()
            make.width.equalTo(view)//.offset((CommonMetrics.trailingOffset - CommonMetrics.leadingOffset))
            make.height.equalTo(view)
        }
//        mainStackView.snp.makeConstraints { make in
//            make.top.equalTo(self.view.snp.top)
//            make.leading.equalToSuperview()
//            make.trailing.equalToSuperview()
//
//            //make.bottom.equalToSuperview()
//        }
        
        
        
        backgroundImage.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(450)
            //make.width.equalToSuperview()
        }
        
        blackContainer.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(backgroundImage.snp.bottom)
            make.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        gradientImage.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview()
        }
        logoImage.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(40)
            make.top.equalToSuperview().offset(420)
            make.trailing.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.height.lessThanOrEqualTo(70)
        }
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            //make.top.equalTo(logoImage.snp.bottom).offset(15)
            make.trailing.equalToSuperview().offset(-20)
            make.top.equalTo(blackContainer.snp.top).offset(-30)
            //make.center.equalToSuperview()
        }
    }
}

// MARK: - Binding
extension FilmDetailViewController {
    private func bindViewModel() {
        viewModel?.filmTitle.bind(listener: { filmTitle in
            DispatchQueue.main.async {
                self.titleLabel.text = filmTitle
            }
        })
        viewModel?.filmBackgroundImage.bind(listener: { filmBackgroundImage in
            DispatchQueue.main.async {
                self.backgroundImage.image = filmBackgroundImage
            }
        })
        viewModel?.filmLogoImage.bind(listener: { filmLogoImage in
            DispatchQueue.main.async {
                self.logoImage.image = filmLogoImage
            }
        })
    }
}
