//
//  EventTableViewCell.swift
//  EventLists
//
//  Created by YOU-HSUAN YU on 2020/11/14.
//

import UIKit

protocol EventCellDisplayable {
    var title: String { get }
    var date: String { get }
    var image: String { get }
    var isFavorite: Bool { get }
}

class EventTableViewCell: UITableViewCell {
    
    private let thumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = .gray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "title"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "date"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .left
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let favoriteLabel: UILabel = {
        let label = UILabel()
        label.text = "Unfavorite"
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .right
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupView()
    }

    func setDisplayableItem(_ item: EventCellDisplayable) {
        titleLabel.text = item.title
        dateLabel.text = item.date
        favoriteLabel.text = item.isFavorite ? "Favorite" : "Unfavorite"
    }
    
    func setupView() {
        contentView.addSubview(thumbnailView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(favoriteLabel)
        
        NSLayoutConstraint.activate([
            thumbnailView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            thumbnailView.heightAnchor.constraint(equalToConstant: 40),
            thumbnailView.widthAnchor.constraint(equalToConstant: 40),
            thumbnailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: favoriteLabel.leadingAnchor, constant: 5),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: favoriteLabel.leadingAnchor, constant: 5),
            
            favoriteLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15)
        ])
    }
}
