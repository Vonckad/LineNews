//
//  NewsTableViewController.swift
//  LineNews
//
//  Created by Vlad Ralovich on 18.02.2023.
//

import UIKit

class NewsTableViewController: UITableViewController {

    private var newsModel: [ArticlesNews] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .large)
        activityIndicatorView.frame = CGRect(x: 0, y: 0, width: 37, height: 37)
        activityIndicatorView.startAnimating()
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
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 600
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
        navigationItem.backButtonTitle = ""
        loadNews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.black]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor : UIColor.black]
    }
    
    //private
    private func loadNews() {
        let service: ServiceFetcherProtocol = ServiceFetcher()
        service.fetchSpaceRokets { response in
            guard let response = response else {
                return
            }
            self.activityIndicatorView.stopAnimating()
            self.newsModel = response.articles
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! NewsTableViewCell
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
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? NewsTableViewCell {
            cell.cancelDownloadTask()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailNewsViewController(newsModel[indexPath.section])
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

//MARK: - NewsTableViewCellDelegate
extension NewsTableViewController: NewsTableViewCellDelegate {
    func didPressLike(newsItem: ArticlesNews) {
        print("didPressLike \(String(describing: newsItem.title))")
    }
}
