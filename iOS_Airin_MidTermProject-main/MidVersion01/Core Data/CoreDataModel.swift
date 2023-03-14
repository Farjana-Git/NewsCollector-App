//
//  CoreDataModel.swift
//  MidVersion01
//
//  Created by Bjit on 16/1/23.
//

import UIKit
import Foundation
import CoreData


class CoreDataModel{
    static let shared = CoreDataModel()
    
    private init() {}
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: For All
    
    func getAllRecords(category: String, search: String) -> [ArticleSourceEntity] {
        var articleArray = [ArticleSourceEntity]()
        do {
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<ArticleSourceEntity>(entityName: "ArticleSourceEntity")
            let predicate = NSPredicate(format: "category == %@ && title CONTAINS [c] %@", category, search)
            fetchRequest.predicate = predicate

            articleArray = try context.fetch(fetchRequest)
            print(articleArray)
        }
        catch {
            print(error.localizedDescription)
        }
        return articleArray
    }
    

    
    func addRecord(title: String, author: String, publishedAt: String, url: String, urlToImage: String, desc: String, content: String, category: String, context: NSManagedObjectContext) -> [ArticleSourceEntity] {
        
        let item = ArticleSourceEntity(context: context)
        var articlesArray = [ArticleSourceEntity]()
  
        do {
            item.title = title
            item.author = author
            item.publishedAt = publishedAt
            item.url = url
            item.urlToImg = urlToImage
            item.category = category
            item.bookMarked = false
            item.desc = desc
            item.content = content
            
            try context.save()
            articlesArray.append(item)
        }
        catch {
            print(error)
        }
        return articlesArray
    }
    
    
    func getAllRecordsForAllCategory() -> [ArticleSourceEntity] {
        
        var articlesArray = [ArticleSourceEntity]()
        do {
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<ArticleSourceEntity>(entityName: "ArticleSourceEntity")
            
            articlesArray = try context.fetch(fetchRequest)
            print(articlesArray)
        }
        catch {
            print(error.localizedDescription)
        }
        return articlesArray
    }
    
    
    
    // MARK: - Get All Records (Bookmark)
    func getAllRecordsBookMarked(category: String, search: String) -> [BookMarkEntity] {
        var articlesArrayForBookmark = [BookMarkEntity]()
        do {
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<BookMarkEntity>(entityName: "BookMarkEntity")
            let predicate = NSPredicate(format: "category == %@ && title CONTAINS [c] %@", category, search)
            fetchRequest.predicate = predicate

            articlesArrayForBookmark = try context.fetch(fetchRequest)
            print(articlesArrayForBookmark)
        }
        catch {
            print(error.localizedDescription)
        }
        return articlesArrayForBookmark
    }
    
    // MARK: - Get All Records without param (Bookmark)
    func getAllRecordsForAllCategory() -> [BookMarkEntity] {
        
        var articleArrayForBookMark = [BookMarkEntity]()
        do {
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let fetchReq = NSFetchRequest<BookMarkEntity>(entityName: "BookMarkEntity")
            
            articleArrayForBookMark = try context.fetch(fetchReq)
            print(articleArrayForBookMark)
        }
        catch {
            print(error.localizedDescription)
        }
        return articleArrayForBookMark
    }
    
    
    // MARK: - Add Records (Bookmark)
    func addRecordBookMark(title: String, author: String, publishedAt: String, url: String, urlToImage: String, desc: String, content: String, category: String, context: NSManagedObjectContext) -> [BookMarkEntity] {
        
        let item = BookMarkEntity(context: context)
        var articlesArrayforBookMark = [BookMarkEntity]()
  
        do {
            item.title = title
            item.author = author
            item.publishedAt = publishedAt
            item.url = url
            item.urlToImg = urlToImage
            item.category = category
            item.bookMarked = false
            item.desc = desc
            item.content = content
            
            try context.save()
            articlesArrayforBookMark.append(item)
        }
        catch {
            print(error)
        }
        return articlesArrayforBookMark
    }
    
    
    //MARK: Delete Records from CoreData
    
    func deleteRecordsFromCoreData(context: NSManagedObjectContext) {
        let deleteReq = NSBatchDeleteRequest(fetchRequest: ArticleSourceEntity.fetchRequest())

        do {
            try context.execute(deleteReq)
            
        } catch let error as NSError {
            print(error.localizedDescription)
            
        }
        }
    
    //MARK: Delete Records (BookMark)
    func deleteRecordsFromBookMarks(index: Int, bookMarkArray: inout [BookMarkEntity], context: NSManagedObjectContext) -> [BookMarkEntity]{
            
            let item = bookMarkArray[index]
            context.delete(item)
            
            do {
                try context.save()
                bookMarkArray.remove(at: index)
            }
            catch {
                print(error)
            }
            return bookMarkArray
        }

}
