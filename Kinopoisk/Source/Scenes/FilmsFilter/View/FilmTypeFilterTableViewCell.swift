//
//  FilmTypeFilterTableViewCell.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 17.01.2023.
//

import UIKit

class FilmTypeFilterTableViewCell: UITableViewCell {
    
    static let identifier = "FilmTypeFilterTableViewCell"
    
    // MARK: - ViewModel
    
    weak var viewModel: FilmTypeFilterTableViewCellViewModelType? {
        willSet(viewModel) {
            guard let viewModel = viewModel else { return }
            
            textLabel?.text = viewModel.categoryTitle
            accessoryType = viewModel.isSelected ? .checkmark : .none
        }
    }
    
    // MARK: - Lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        // MARK: View Setup
//        setupHierarchy()
//        setupLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
