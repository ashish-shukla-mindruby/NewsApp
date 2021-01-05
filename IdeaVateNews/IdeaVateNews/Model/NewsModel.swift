//
//  NewsModel.swift
//  IdeaVateNews
//
//  Created by Ashish Shukla on 03/11/20.
//  Copyright © 2020 Ashish. All rights reserved.
//

import UIKit

class NewsModel: NSObject, Encodable, Comparable {
    static func < (lhs: NewsModel, rhs: NewsModel) -> Bool {
        return lhs.publishedAt < rhs.publishedAt
    }
    
    var sources: SourceModel
    var author: String
    var title: String
    var newsdescription: String
    var url: String
    var urlToImage: String
    var publishedAt: Date
    var content: String
    
    init(with dictionary: [String:Any]) {
        let constant = APPConstant.APIResponseConstant.self
        
        if let source = dictionary[constant.sources] as? [String:Any] {
            self.sources = SourceModel(with: source)
        } else {
            self.sources = SourceModel(with: [:])
        }
        
        self.author = dictionary[constant.author] as? String ?? ""
        self.title = dictionary[constant.title] as? String ?? ""
        self.newsdescription = dictionary[constant.description] as? String ?? ""
        self.url = dictionary[constant.url] as? String ?? ""
        self.urlToImage = dictionary[constant.urlToImage] as? String ?? ""
        self.content = dictionary[constant.content] as? String ?? ""
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSS"
        
        if let postedAt = (dictionary[constant.publishedAt] as? String)?.replacingOccurrences(of: "T", with: " ") {
            if let date = formatter.date(from: postedAt) {
                self.publishedAt = date
            } else {
                self.publishedAt = Date()
            }
        } else {
            self.publishedAt = Date()
        }
        
        super.init()
    }
    
    private enum CodingKeys: String, CodingKey {
        case sources
        case author
        case title
        case newsdescription
        case url
        case urlToImage
        case publishedAt
        case content
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(sources, forKey: .sources)
        try container.encode(author, forKey: .author)
        try container.encode(title, forKey: .title)
        try container.encode(newsdescription, forKey: .newsdescription)
        try container.encode(url, forKey: .url)
        try container.encode(urlToImage, forKey: .urlToImage)
        try container.encode(publishedAt, forKey: .publishedAt)
        try container.encode(content, forKey: .content)
    }
}
