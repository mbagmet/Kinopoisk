//
//  FilmsListTableViewCell.swift
//  Kinopoisk
//
//  Created by Mikhail Bagmet on 06.01.2023.
//

import UIKit

class FilmsListTableViewCell: UITableViewCell {
    
    static let identifier = "FilmsListTableViewCell"

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    // MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)

        setupView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Settings
    
    private func setupView() {
        imageSetup()
        accessoryType = .disclosureIndicator
    }
    
    private func imageSetup() {

        
        imageView?.image = UIImage(systemName: "film")
    }
}
