//
//  NewsTableViewController.swift
//  LineNews
//
//  Created by Vlad Ralovich on 18.02.2023.
//

import UIKit

class NewsTableViewController: UITableViewController {
    
    private let coreDataStack = AppDelegate.sharedAppDelegate.coreDataStack

    private var newsModel: [ArticlesNews] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.frame = CGRect(x: 0, y: 0, width: 37, height: 37)
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    //Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.addSubview(activityIndicatorView)
        activityIndicatorView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(UIScreen.main.bounds.maxX / 2)
        }
        tableView.backgroundColor = Theme.defaultBackgroundColor
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 600
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.backButtonTitle = ""
        loadNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.tintColor = Theme.defaultButtonBackgroundColor
        tabBarController?.tabBar.tintColor = Theme.defaultButtonBackgroundColor
        tabBarController?.tabBar.backgroundColor = .white
        if newsModel.isEmpty {
            loadNews()
        }
        checkLike()
    }
    
    //private
    private func loadNews() {
        activityIndicatorView.startAnimating()
        let service: ServiceFetcherProtocol = ServiceFetcher()
        service.fetchSpaceRokets { [weak self] response in
            guard let self = self else { return }
            guard let response = response else {
                UIAlertController.showAlertView(viewController: self, style: .networkError) { _ in
                    self.loadNews()
                }
                return
            }
            self.activityIndicatorView.stopAnimating()
            self.newsModel = response.articles
            self.checkLike()
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return newsModel.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as? NewsTableViewCell else { return UITableViewCell() }
        cell.newsItem = newsModel[indexPath.section]
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16.0
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    // MARK: - Table view delegate    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailNewsViewController(newsModel[indexPath.section])
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

//MARK: - NewsTableViewCellDelegate
extension NewsTableViewController: NewsTableViewCellDelegate {
    func didPressLike(newsItem: ArticlesNews, newsImage: UIImage?, isLiked: Bool) {
        if isLiked {
            saveNewsItem(newsItem: newsItem, newsImage: newsImage)
        } else {
            deleteNewsItem(newsItem: newsItem)
        }
        checkLike()
    }
}

//MARK: - CoreDate
extension NewsTableViewController {
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
        let saveNews = coreDataStack.getAllNews()
        for (index, news) in newsModel.enumerated() {
            newsModel[index].isLiked = saveNews.contains(where: {$0.url == news.url})
        }
        tableView.reloadData()
    }
}
