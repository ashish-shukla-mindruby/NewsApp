//
//  CoreDataOperations.swift
//  IdeaVateNews
//
//  Created by Ashish Shukla on 03/11/20.
//  Copyright © 2020 Ashish. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataOperations: NSObject {
    static let constant = APPConstant.CoreDataConstant.self
    
    // MARK :- Save News Data Into Core Data
    class func saveNewsData(title: String, description: String, author: String, url: String, urlToImage: String, publishedAt: String, content: String, totalResults: String, newsId: String, name: String) {
        
        DispatchQueue.main.async {
            //As we know that container is set up in the AppDelegates so we need to refer that container.
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            //We need to create a context from this container
            let managedContext = appDelegate.persistentContainer.viewContext
            
            //Now let’s create an entity and new user records.
            let userEntity = NSEntityDescription.entity(forEntityName: constant.iTableName, in: managedContext)!
            
            // Add new data
            let news = NSManagedObject(entity: userEntity, insertInto: managedContext)
            news.setValue(title, forKeyPath: constant.iTitleAttribute)
            news.setValue(description, forKeyPath: constant.iNewsdescriptionAttribute)
            news.setValue(author, forKeyPath: constant.iAuthorAttribute)
            news.setValue(url, forKey: constant.iUrlAttribute)
            news.setValue(urlToImage, forKey: constant.iUrlToImageAttribute)
            news.setValue(publishedAt, forKey: constant.iPublishedAtAttribute)
            news.setValue(content, forKey: constant.iContentAttribute)
            news.setValue(totalResults, forKey: constant.iTotalResultsAttribute)
            news.setValue(newsId, forKey: constant.iIdAttribute)
            news.setValue(name, forKey: constant.iNameAttribute)
            
            //Now we have set all the values. The next step is to save them inside the Core Data
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    // MARK :- Fetch News Data
    class func fetchAllNewsData() -> [Any] {
        
        //As we know that container is set up in the AppDelegates so we need to refer that container.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        //We need to create a context from this container
        let context = appDelegate.persistentContainer.viewContext
        
        //fetch data from table
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: constant.iTableName)
        fetchRequest.returnsObjectsAsFaults = false
        
        var fetchResult = [Any]()
        
        do {
            //fetch all result
            let result = try context.fetch(fetchRequest)
            if result.count != 0 {
                // Get user data
                for data in result {
                    fetchResult.append(data)
                }
            } else {
                print(" * No Data Found * ")
            }
        } catch {
            print(" * Failed to fetch data * ")
        }
        
        do {
            try context.save()
        } catch {
            print(" * Failed saving data * ")
        }
        
        return fetchResult
    }
    
    //MARK :- Delete all data
    class func deleteAllNewsData() {
        DispatchQueue.main.async {
            //As we know that container is set up in the AppDelegates so we need to refer that container.
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            
            //We need to create a context from this container
            let managedContext = appDelegate.persistentContainer.viewContext
            
            let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: constant.iTableName)
            let request = NSBatchDeleteRequest(fetchRequest: fetch)
            
            do {
                let result = try managedContext.execute(request)
                print(result)
                try managedContext.save()
            } catch let error as NSError {
                print("Could not delete. \(error), \(error.userInfo)")
            }
        }
    }
}
