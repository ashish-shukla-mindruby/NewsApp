//
//  HomeControllerViewModel.swift
//  IdeaVateNews
//
//  Created by Ashish Shukla on 03/11/20.
//  Copyright © 2020 Ashish. All rights reserved.
//

import UIKit
import CoreData

class HomeControllerViewModel: NSObject {
    
    var newsInfoArray = [[String:Any]]()
    
    //Get news data from URL
    func getNewsFromAPI(_ completion: @escaping ([NewsModel]?, Error?) -> Void) {
        
        let constant = APPConstant.NewsAPIConstant.self
        
        // Session Request to fetch data from server
        let session = URLSession.shared
        if let url = URL(string: constant.iNewsAPIURL) {
            let task = session.dataTask(with: url, completionHandler: { data, response, error in
                
                // Check Error
                if error != nil {
                    print("*Error - \(String(describing:error?.localizedDescription))")
                    completion(nil, error)
                }
                
                // Check Error
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("*Error - \(String(describing:error?.localizedDescription))")
                    completion(nil, error)
                    return
                }
                
                // Check Mime Type
                guard let mime = response?.mimeType, mime == "application/json" else {
                    print("*Wrong MIME type!")
                    completion(nil, error)
                    return
                }
                
                // Parse Server Data
                if let serverData = data {
                    do {
                        if let newsJson = try JSONSerialization.jsonObject(with: serverData, options: [JSONSerialization.ReadingOptions.allowFragments]) as? [String:Any] {
                            print(" Whole News Json -- \(newsJson)")
                            
                            var newsGroups  = [NewsModel]()
                            if let newsArray = newsJson[APPConstant.APIResponseConstant.articles] as? [[String:Any]] {
                                for news in newsArray {
                                    let model = NewsModel(with: news)
                                    newsGroups.append(model)
                                }
                                newsGroups.sort()
                                completion(newsGroups, error)
                            }
                        }
                    } catch {
                        print("JSON error: \(error.localizedDescription)")
                        completion(nil, error)
                    }
                }
            })
            task.resume()
        }
    }
    
    //Fetch news data from local db
    func fetchNewsFromDB(_ completion: @escaping ([NewsModel]?) -> Void) {
        let newsData = CoreDataOperations.fetchAllNewsData()
        print(newsData)
        
        let dbConstant = APPConstant.CoreDataConstant.self
        let apiConstant = APPConstant.APIResponseConstant.self
        
        var newsGroups  = [NewsModel]()
        
        for news in newsData {
            let newsInfo = news as? NSManagedObject
            let newsAuthor = newsInfo?.value(forKey: dbConstant.iAuthorAttribute) as? String
            let newsTitle = newsInfo?.value(forKey: dbConstant.iTitleAttribute) as? String
            let newsDescription = newsInfo?.value(forKey: dbConstant.iNewsdescriptionAttribute) as? String
            let url = newsInfo?.value(forKey: dbConstant.iUrlAttribute) as? String
            let urlToImage = newsInfo?.value(forKey: dbConstant.iUrlToImageAttribute) as? String
            let publishedAt = newsInfo?.value(forKey: dbConstant.iPublishedAtAttribute) as? String
            let content = newsInfo?.value(forKey: dbConstant.iContentAttribute) as? String
            
            let newsDict: [String:Any] = [apiConstant.author:newsAuthor ?? "--",
                                          apiConstant.title:newsTitle ?? "--",
                                          apiConstant.description:newsDescription ?? "--",
                                          apiConstant.url:url ?? "--",
                                          apiConstant.urlToImage:urlToImage ?? "--",
                                          apiConstant.publishedAt:publishedAt ?? "--",
                                          apiConstant.content:content ?? "--"]
            
            let model = NewsModel(with: newsDict)
            newsGroups.append(model)
        }
        
        newsGroups.sort()
        completion(newsGroups)
    }
    
    //Save news data into local db
    func saveDataInLocalDB(newsModel: [NewsModel]) {
        CoreDataOperations.deleteAllNewsData()
        for news in newsModel {
            CoreDataOperations.saveNewsData(title: news.title, description: news.newsdescription, author: news.author, url: news.url, urlToImage: news.urlToImage, publishedAt: "\(news.publishedAt)", content: news.content, totalResults: "", newsId: "", name: "")
        }
    }
    
    //Fetch image from URL
    func fetchImageFromURL(urlToImage: String, _ completion: @escaping (UIImage?) -> Void) {
        if let url = URL(string: urlToImage) {
            let session = URLSession.shared

            // Define a download task. The download task will download the contents of the URL as a Data object and then you can do what you wish with that data.
            let downloadPicTask = session.dataTask(with: url) { (data, response, error) in
                // The download has finished.
                if let e = error {
                    print("Error downloading cat picture: \(e)")
                    completion(nil)
                } else {
                    // No errors found.
                    // It would be weird if we didn't have a response, so check for that too.
                    if (response as? HTTPURLResponse) != nil {
                        if let imageData = data {
                            // Finally convert that Data into an image and do what you wish with it.
                            let image = UIImage(data: imageData)
                            DispatchQueue.main.async {
                                //self.newsImageView.image = image
                                completion(image)
                            }
                        } else {
                            print("Couldn't get image: Image is nil")
                            completion(nil)
                        }
                    } else {
                        print("Couldn't get response code for some reason")
                        completion(nil)
                    }
                }
            }
            downloadPicTask.resume()
        }
    }
}
