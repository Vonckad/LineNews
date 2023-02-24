//
//  FavouritesViewController.swift
//  LineNews
//
//  Created by Vlad Ralovich on 18.02.2023.
//

import UIKit

class FavouritesViewController: UICollectionViewController {

    private let coreDataStack = AppDelegate.sharedAppDelegate.coreDataStack
    private lazy var favouritesNewsModel: [ArticlesNews] = coreDataStack.getAllNews()
    
    //Life cycle
    init() {
        let flowLayout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: flowLayout)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = Theme.defaultBackgroundColor
        collectionView.contentInset = UIEdgeInsets(top: 18.0, left: 15.0, bottom: 0, right: 15.0)
        collectionView.register(FavouritesNewsCollectionViewCell.self, forCellWithReuseIdentifier: "favouritesNewsIdentifier")
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.prefersLargeTitles = true
        favouritesNewsModel = coreDataStack.getAllNews()
        collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = Theme.defaultButtonBackgroundColor
        tabBarController?.tabBar.tintColor = Theme.defaultButtonBackgroundColor
        
        favouritesNewsModel = coreDataStack.getAllNews()
        collectionView.reloadData()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favouritesNewsModel.count
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favouritesNewsIdentifier", for: indexPath) as? FavouritesNewsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.newsItem = favouritesNewsModel[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = DetailNewsViewController(favouritesNewsModel[indexPath.row])
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension FavouritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let height = (UIScreen.main.bounds.size.height - 40) / 4
        let width = (UIScreen.main.bounds.size.width - 45) / 2
        return CGSize(width: width, height: height)
    }
}

//MARK: - FavouritesNewsCollectionViewCellDelegate
extension FavouritesViewController: FavouritesNewsCollectionViewCellDelegate {
    func didPressLike(newsItem: ArticlesNews, newsImage: UIImage?, isLiked: Bool) {
        if isLiked {
            saveNewsItem(newsItem: newsItem, newsImage: newsImage)
        } else {
            deleteNewsItem(newsItem: newsItem)
            if let index = favouritesNewsModel.firstIndex(where: {$0 == newsItem}) {
                favouritesNewsModel.remove(at: index)
                collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
            }
        }
    }
}

//MARK: - CoreDate
extension FavouritesViewController {
    //save in CoreData
    private func saveNewsItem(newsItem: ArticlesNews, newsImage: UIImage?) {
        coreDataStack.createFavoriteNews(newsItem: newsItem,
                                         newsImageData: newsImage?.pngData())
    }
    
    //delete from CoreData
    private func deleteNewsItem(newsItem: ArticlesNews) {
        coreDataStack.deleteNews(news: newsItem)
    }
}
