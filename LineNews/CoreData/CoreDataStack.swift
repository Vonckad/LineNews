//
//  CoreDataStack.swift
//  LineNews
//
//  Created by Vlad Ralovich on 22.02.2023.
//

import CoreData

protocol CoreDataStackNews {
    func createFavoriteNews(newsItem: ArticlesNews, newsImageData: Data?)
    func getAllNews() -> [ArticlesNews]
    func deleteNews(news: ArticlesNews)
}

protocol CoreDataStackUserProfile {
    func saveUserProfile(_ user: UserProfileModel)
    func getUserProfile() -> UserProfile?
}

final class CoreDataStack: CoreDataStackNews, CoreDataStackUserProfile {
    
    private let modelName: String

    init(modelName: String) {
        self.modelName = modelName
    }

    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()

    lazy var managedContext: NSManagedObjectContext = self.storeContainer.viewContext

    func saveContext() {
        guard managedContext.hasChanges else { return }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Unresolved error \(error), \(error.userInfo)")
        }
    }
    
    //news
    func createFavoriteNews(newsItem: ArticlesNews, newsImageData: Data?) {
        if !getAllNewsEntity().contains(where: {$0.url == newsItem.url}) {
            let newNews = NewsEntity(context: managedContext)
            newNews.title = newsItem.title
            newNews.descriptionNews = newsItem.description
            newNews.dateNews = newsItem.publishedAt
            newNews.url = newsItem.url
            if let newsImageData = newsImageData {
                newNews.imageData = newsImageData
            }
            saveContext()
        }
    }
    
    func getAllNews() -> [ArticlesNews] {
        return getAllNewsEntity().map({ newsEntity in
            return ArticlesNews(title: newsEntity.title,
                                description: newsEntity.descriptionNews,
                                urlToImage: newsEntity.urlToImage,
                                publishedAt: newsEntity.dateNews,
                                url: newsEntity.url,
                                imageData: newsEntity.imageData,
                                isLiked: true)
        })
    }
    
    private func getAllNewsEntity() -> [NewsEntity] {
        let request: NSFetchRequest<NewsEntity> = NewsEntity.fetchRequest()
        var fetchedNews: [NewsEntity] = []
        
        do {
            fetchedNews = try managedContext.fetch(request)
        } catch let error {
            print("Error fetching news \(error)")
        }
        return fetchedNews
//        return getTEntity(type: NewsEntity.self)
    }
    
    
  
//    private func getTEntity<T: NSManagedObject>(type: T.Type) -> [T] {
//        guard let request = T.fetchRequest() as? NSFetchRequest<T> else {
//            fatalError("Cannot fetch \(type)")
//        }
//        var fetchedEntity: [T] = []
//
//        do {
//            fetchedEntity = try managedContext.fetch(request)
//        } catch let error {
//            print("Error fetching news \(error)")
//        }
//        return fetchedEntity
//    }
    
    func deleteNews(news: ArticlesNews) {
        if let newsEntity = getAllNewsEntity().first(where: {$0.url == news.url}) {
            managedContext.delete(newsEntity)
            saveContext()
        }
    }
    
    //UserProfile
    func saveUserProfile(_ user: UserProfileModel) {
        if let savedUser = getUserProfile() {
            savedUser.id = UUID()
            savedUser.image = user.image
            savedUser.name = user.name
            savedUser.email = user.email
        } else {
            let userProfile = UserProfile(context: managedContext)
            userProfile.id = UUID()
            userProfile.image = user.image
            userProfile.name = user.name
            userProfile.email = user.email
        }
        
        saveContext()
    }
    
    func getUserProfile() -> UserProfile? {
        let request: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        var fetchedNews: UserProfile?// = .init()
        
        do {
            fetchedNews = try managedContext.fetch(request).last
        } catch let error {
            print("Error fetching news \(error)")
        }
        return fetchedNews
//        return getTEntity(type: UserProfile.self).last
    }
}
