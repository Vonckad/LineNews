//
//  NewsEntity+CoreDataProperties.swift
//  
//
//  Created by Vlad Ralovich on 22.02.2023.
//
//

import Foundation
import CoreData

extension NewsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NewsEntity> {
        return NSFetchRequest<NewsEntity>(entityName: "NewsEntity")
    }

    @NSManaged public var urlToImage: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var title: String?
    @NSManaged public var descriptionNews: String?
    @NSManaged public var dateNews: String?
    @NSManaged public var url: String?
}
