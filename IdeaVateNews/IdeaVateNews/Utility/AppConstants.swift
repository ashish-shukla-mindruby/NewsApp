//
//  AppConstants.swift
//  IdeaVateNews
//
//  Created by Ashish Shukla on 03/11/20.
//  Copyright © 2020 Ashish. All rights reserved.

import UIKit

let appname = "IdeaVateNews"

class APPConstant: NSObject {
    
    // MARK :- News API http URL
    struct NewsAPIConstant {
        static let iNewsAPIURL                  = "https://newsapi.org/v2/everything?q=bitcoin&apiKey=3a08b194bc2c4e17913dc1d397a97c0e" ///"http://newsapi.org/v2/everything?q=bitcoin&from=2020-10-03&sortBy=publishedAt&apiKey=3a08b194bc2c4e17913dc1d397a97c0e"
        ///https://newsapi.org/v2/everything?q=bitcoin&apiKey=3a08b194bc2c4e17913dc1d397a97c0e
        ///"https://newsapi.org/v2/top-headlines?country=us&apiKey=3a08b194bc2c4e17913dc1d397a97c0e"
    }
    
    // MARK :- Core Data Constants
    struct CoreDataConstant {
        static let iTableName                   = "IDEANEWS"
        static let iAuthorAttribute             = "author"
        static let iTitleAttribute              = "title"
        static let iNewsdescriptionAttribute    = "newsdescription"
        static let iUrlAttribute                = "url"
        static let iUrlToImageAttribute         = "urlToImage"
        static let iPublishedAtAttribute        = "publishedAt"
        static let iContentAttribute            = "content"
        static let iTotalResultsAttribute       = "totalResults"
        static let iIdAttribute                 = "id"
        static let iNameAttribute               = "name"
    }
    
    // MARK :- API Response Constatnts
    struct APIResponseConstant {
        static let articles                     = "articles"
        static let sources                      = "source"
        static let author                       = "author"
        static let title                        = "title"
        static let description                  = "description"
        static let url                          = "url"
        static let urlToImage                   = "urlToImage"
        static let publishedAt                  = "publishedAt"
        static let content                      = "content"
        static let totalResults                 = "totalResults"
        static let id                           = "id"
        static let name                         = "name"
    }
    
    // MARK :- Alert messages
    struct Alert {
        static let requiredEmail                = "Please enter email id."
        static let validEmail                   = "Please enter valid email id."
        static let requiredPassword             = "Please enter password."
        static let matchConfirmPassword         = "Password did not match. Password and confirm password must be the same."
        static let validPassword                = "Please enter valid password, the password must be 6 characters long or more."
        static let logout                       = "Do you realy want to logout..?"
        static let noInternet                   = "Please check internet connection."
    }
}
