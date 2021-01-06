//
//  DetailsViewController.swift
//  IdeaVateNews
//
//  Created by Ashish Shukla on 03/11/20.
//  Copyright © 2020 Ashish. All rights reserved.
//

import UIKit
import SafariServices
import Kingfisher

class DetailsViewController: UIViewController {

    //Properties
    @IBOutlet var newsImageView: UIImageView!
    @IBOutlet var newsTitle: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var publshedDateLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    var newsModel: NewsModel?
    
    let homeViewModel = HomeControllerViewModel()
    
    //Class methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let nTitle = newsModel?.title {
            newsTitle.text = "\(nTitle)"
        }
        
        if let author = newsModel?.author {
            authorLabel.text = "Author - \(author)"
        }
        
        if let publishedAt = newsModel?.publishedAt {
            publshedDateLabel.text = "Published Date - \(publishedAt)"
        }
        
        if let newsdescription = newsModel?.newsdescription {
            descriptionLabel.text = "Description - \(newsdescription)"
        }
        
        if let urlToImage = newsModel?.urlToImage {
            if let url = URL(string: urlToImage) {
                self.newsImageView.kf.indicatorType = .activity
                self.newsImageView.kf.setImage(with: url, placeholder: UIImage(),
                                             options: [.cacheOriginalImage])
            }
        }
    }
    
    @IBAction func readFullNewsButtonAction(_ sender: Any) {
        if NetworkConnectivityManager.sharedInstance.reachability.connection == .unavailable {
            self.showAlert(message: APPConstant.Alert.noInternet)
        } else {
            if let urlString = newsModel?.url {
                if let url = URL(string: urlString) {
                    let safariVC = SFSafariViewController(url: url)
                    self.present(safariVC, animated: true, completion: nil)
                }
            }
        }
    }
}
