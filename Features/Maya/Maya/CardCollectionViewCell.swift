//
//  CardCollectionViewCell.swift
//  Maya
//
//  Created by pyretttt pyretttt on 06.03.2022.
//

import UIKit

final class CardCollectionViewCell: UICollectionViewCell {
    
    static let reuseID: String = "CardCollectionViewCellReuseID"
    
    private enum Constants {
        static let headerHeight: CGFloat = 200
        static let defaultOffset: CGFloat = 16
    }
    
    // MARK: - VisualElements
    
    private let headerImage: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.textAlignment = .left
        view.font = view.font.withSize(24)
        
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .black
        view.textAlignment = .left
        view.font = view.font.withSize(20)
        
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateInfo(title: String, description: String, image: UIImage) {
        titleLabel.text = title
        descriptionLabel.text = description
        headerImage.image = image
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        let views = [headerImage, titleLabel, descriptionLabel]
        views.forEach { contentView.addSubview($0) }
        
        setupConstraints()
        
        contentView.layer.cornerRadius = 32
        contentView.backgroundColor = UIColor.systemGray
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            headerImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            headerImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            headerImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            headerImage.heightAnchor.constraint(equalToConstant: Constants.headerHeight),
            
            titleLabel.topAnchor.constraint(equalTo: headerImage.bottomAnchor, constant: Constants.defaultOffset),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.defaultOffset),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.defaultOffset),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: Constants.defaultOffset),
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.defaultOffset),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.defaultOffset)
        ])
    }
}
