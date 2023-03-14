//
//  BookMarkEntity+CoreDataProperties.swift
//  MidVersion01
//
//  Created by Bjit on 18/1/23.
//
//

import Foundation
import CoreData


extension BookMarkEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookMarkEntity> {
        return NSFetchRequest<BookMarkEntity>(entityName: "BookMarkEntity")
    }

    @NSManaged public var author: String?
    @NSManaged public var bookMarked: Bool
    @NSManaged public var category: String?
    @NSManaged public var content: String?
    @NSManaged public var desc: String?
    @NSManaged public var publishedAt: String?
    @NSManaged public var source_id: String?
    @NSManaged public var source_name: String?
    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var urlToImg: String?

}

extension BookMarkEntity : Identifiable {

}
