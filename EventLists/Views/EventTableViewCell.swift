//
//  EventTableViewCell.swift
//  EventLists
//
//  Created by YOU-HSUAN YU on 2020/11/14.
//

import UIKit
import Kingfisher

protocol EventCellDisplayable {
    var title: String { get }
    var date: String { get }
    var image: String { get }
    var isFavorite: Bool { get }
}

protocol EventTableViewCellDelegate: class {
    func didSelectFavoriteButton(cell: EventTableViewCell)
}

class EventTableViewCell: UITableViewCell {
    
    var item: EventCellDisplayable? {
        didSet {
            layoutDisplayableItem()
        }
    }
    
    weak var delegate: EventTableViewCellDelegate?
    
    private let thumbnailView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
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
    
    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = .systemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .right
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        delegate = nil
    }

    func layoutDisplayableItem() {
        guard let item = item else { return }
        titleLabel.text = item.title
        dateLabel.text = item.date
        thumbnailView.kf.setImage(with: URL(string: item.image))
        let favoriteBtnTitle = (item.isFavorite) ? "Favorite" : "Unfavorite"
        favoriteButton.setTitle(favoriteBtnTitle, for: .normal)
    }
    
    @objc func didSelectFavoriteButton(sender: UIButton) {
        delegate?.didSelectFavoriteButton(cell: self)
    }
    
    func setupView() {
        contentView.addSubview(thumbnailView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(favoriteButton)
        
        favoriteButton.addTarget(self, action: #selector(didSelectFavoriteButton(sender:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            thumbnailView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            thumbnailView.heightAnchor.constraint(equalToConstant: 40),
            thumbnailView.widthAnchor.constraint(equalToConstant: 40),
            thumbnailView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            titleLabel.leadingAnchor.constraint(equalTo: thumbnailView.trailingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: 5),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: favoriteButton.leadingAnchor, constant: 5),
            
            favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -25)
        ])
    }
}
