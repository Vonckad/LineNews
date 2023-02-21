//
//  NewsTableViewCell.swift
//  LineNews
//
//  Created by Vlad Ralovich on 18.02.2023.
//

import UIKit
import Kingfisher

protocol NewsTableViewCellDelegate {
    func didPressLike(newsItem: ArticlesNews)
}

class NewsTableViewCell: UITableViewCell {
    
    var delegate: NewsTableViewCellDelegate?
    
    var newsItem: ArticlesNews! {
        didSet {
            dateLabel.text = Utils.getFormattedDate(newsItem.publishedAt ?? "")
            titleLabel.text = newsItem.title
            newsImageView.kf.indicatorType = .activity
            guard let urlImage = URL(string: newsItem.urlToImage ?? "") else { return }
            newsImageView.kf.indicatorType = .activity
            newsImageView.kf.setImage(with: urlImage,
                                      options: [.transition(.fade(0.3))])
            descriptionLabel.text = newsItem.description
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
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13.0)
        label.numberOfLines = 2
        label.textColor = .black
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    override var frame: CGRect {
        get {
            return super.frame
        }
        set (newFrame){
            var frame = newFrame
            frame.origin.x += 15
            frame.size.width -= 2 * 15
            super.frame = frame
        }
    }
    
    //Life
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 22.0
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //public
    func cancelDownloadTask() {
        newsImageView.kf.cancelDownloadTask()
    }
    
    //private
    private func setupViews() {
        contentView.addSubview(newsImageView)
        contentView.addSubview(dateLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        
        newsImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.equalTo(contentView)
            make.trailing.equalTo(contentView)
            make.height.equalTo(180.0)
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
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2.0)
            make.leading.equalToSuperview().offset(16.0)
            make.trailing.equalToSuperview().inset(16.0)
            make.bottom.equalToSuperview().inset(12.0)
        }
    }
    
    @objc
    private func didSelectLikeButton() {
        likeButton.toggleImage()
        delegate?.didPressLike(newsItem: newsItem)
    }
}

