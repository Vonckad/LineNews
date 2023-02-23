//
//  FavouritesNewsCollectionViewCell.swift
//  LineNews
//
//  Created by Vlad Ralovich on 21.02.2023.
//

import UIKit

protocol FavouritesNewsCollectionViewCellDelegate {
    func didPressLike(newsItem: ArticlesNews, newsImage: UIImage?, isLiked: Bool)
}

class FavouritesNewsCollectionViewCell: UICollectionViewCell {
    
    var delegate: FavouritesNewsCollectionViewCellDelegate?
    
    var newsItem: ArticlesNews! {
        didSet {
            dateLabel.text = Utils.getFormattedDate(newsItem.publishedAt ?? "")
            titleLabel.text = newsItem.title
            if let like = newsItem.isLiked {
                likeButton.setLike(like)
            }
            
            if let imageData = newsItem.imageData {
                newsImageView.image = UIImage.sd_image(with: imageData, scale: 1.0)
            } else if let url = URL(string: newsItem.urlToImage ?? "") {
                
                newsImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "No-Image-Placeholder"))
            }
        }
    }
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let likeButton: LikeButton = {
        let button = LikeButton()
        button.addTarget(nil, action: #selector(didSelectLikeButton), for: .touchUpInside)
        return button
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16.0)
        label.numberOfLines = 0
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 22.0
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //private
    private func setupViews() {
        contentView.addSubview(newsImageView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(titleLabel)
        
        newsImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.height.equalTo(contentView.frame.height / 2)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(newsImageView.snp.bottom).offset(10.0)
            make.leading.equalToSuperview().offset(18.0)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalTo(newsImageView.snp.bottom).offset(10.0)
            make.trailing.equalToSuperview().inset(16.0)
            make.height.equalTo(22.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(11.0)
            make.leading.equalToSuperview().offset(16.0)
            make.trailing.equalToSuperview().inset(16.0)
            make.bottom.equalToSuperview().inset(12.0)
        }
    }
    
    @objc
    private func didSelectLikeButton() {
        likeButton.toggleImage()
        delegate?.didPressLike(newsItem: newsItem, newsImage: newsImageView.image, isLiked: likeButton.isLiked)
    }
}
