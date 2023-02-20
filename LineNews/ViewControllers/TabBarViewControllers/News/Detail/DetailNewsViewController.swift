//
//  DetailNewsViewController.swift
//  LineNews
//
//  Created by Vlad Ralovich on 20.02.2023.
//

import UIKit
import Kingfisher
import SafariServices

class DetailNewsViewController: UIViewController {
    
    private let newsItem: ArticlesNews
    
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
    
    private let likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "heart"), for: .normal)
        button.addTarget(nil, action: #selector(didSelectLikeButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = newsItem.title
        label.font = .boldSystemFont(ofSize: 20.0)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = newsItem.description
        label.font = .systemFont(ofSize: 13.0)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        if let url = URL(string: newsItem.urlToImage ?? "") {
            image.kf.setImage(with: url)
        }
        return image
    }()
    
    private lazy var webViewButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Читайте на сайте", for: .normal)
        button.addTarget(nil, action: #selector(openWebView), for: .touchUpInside)
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
            make.height.lessThanOrEqualTo(250)
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
//        delegate?.didPressLike(newsItem: newsItem)
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
