//
//  DetailNewsViewController.swift
//  LineNews
//
//  Created by Vlad Ralovich on 20.02.2023.
//

import UIKit
import SDWebImage
import SafariServices

class DetailNewsViewController: UIViewController {
    
    private let coreDataStack = AppDelegate.sharedAppDelegate.coreDataStack
    private var newsItem: ArticlesNews
    
    private var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = Theme.defaultBackgroundColor
        return view
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = Utils.getFormattedDate(newsItem.publishedAt ?? "")
        label.font = .systemFont(ofSize: 13.0)
        return label
    }()
    
    private lazy var likeButton: LikeButton = {
        let button = LikeButton()
        button.addTarget(nil, action: #selector(didSelectLikeButton), for: .touchUpInside)
        if let like = newsItem.isLiked {
            button.setLike(like)
        }
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = newsItem.title
        label.font = .boldSystemFont(ofSize: 20.0)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = newsItem.description
        label.textColor = .black
        label.font = .systemFont(ofSize: 13.0)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = 22.0
        image.layer.maskedCorners = [CACornerMask.layerMinXMaxYCorner, CACornerMask.layerMaxXMaxYCorner]
        
        if let imageData = newsItem.imageData {
            image.image = UIImage.sd_image(with: imageData, scale: 1.0)
        } else if var urlComponents = URLComponents(string: newsItem.urlToImage ?? "") {
            urlComponents.query = nil
            if let url = urlComponents.url {
                image.sd_setImage(with: url, placeholderImage: UIImage(named: "No-Image-Placeholder"))
            }
        }
        
        return image
    }()
    
    private lazy var webViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Читать на сайте", for: .normal)
        button.addTarget(nil, action: #selector(openWebView), for: .touchUpInside)
        button.setTitleColor(Theme.defaultButtonBackgroundColor, for: .normal)
        return button
    }()
    
    private var scrollView = UIScrollView()
    
    //Life cycle
    init(_ newsItem: ArticlesNews) {
        self.newsItem = newsItem
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Theme.defaultBackgroundColor
        scrollView.backgroundColor = Theme.defaultBackgroundColor
        scrollView.showsVerticalScrollIndicator = false
        setupUI()
        title = "Статья"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .never
        checkLike()
    }
    
    //private
    private func setupUI() {
        scrollView.showsVerticalScrollIndicator = false
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(contentView)
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(dateLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(webViewButton)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.lessThanOrEqualTo(200)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(10.0)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalToSuperview()
            make.height.equalTo(view.frame.height / 1.5)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.0)
            make.leading.equalToSuperview().offset(18.0)
        }
        
        likeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10.0)
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
        }
        
        webViewButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(11.0)
            make.leading.equalToSuperview().offset(16.0)
            make.trailing.equalToSuperview().inset(16.0)
            make.bottom.lessThanOrEqualToSuperview().inset(12.0)
        }
    }
    
    @objc
    private func didSelectLikeButton() {        
        likeButton.toggleImage()
        if likeButton.isLiked {
            saveNewsItem(newsItem: newsItem, newsImage: imageView.image)
        } else {
            deleteNewsItem(newsItem: newsItem)
        }
    }
    
    @objc
    private func openWebView() {
        if let url = URL(string: newsItem.url ?? "") {
            let vc = SFSafariViewController(url: url)
            vc.modalPresentationStyle = .popover
            showDetailViewController(vc, sender: self)
        }
    }
}

//MARK: - CoreDate
extension DetailNewsViewController {
    //save in CoreData
    private func saveNewsItem(newsItem: ArticlesNews, newsImage: UIImage?) {
        coreDataStack.createFavoriteNews(newsItem: newsItem,
                                         newsImageData: newsImage?.pngData())
    }
    
    //delete from CoreData
    private func deleteNewsItem(newsItem: ArticlesNews) {
        coreDataStack.deleteNews(news: newsItem)
    }
    
    private func checkLike() {
        newsItem.isLiked = coreDataStack.getAllNews().contains(where: {$0.url == newsItem.url})
        likeButton.setLike(newsItem.isLiked!)
    }
}
