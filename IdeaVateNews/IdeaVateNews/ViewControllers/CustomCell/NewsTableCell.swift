//
//  NewsTableCell.swift
//  IdeaVateNews
//
//  Created by Ashish Shukla on 03/11/20.
//  Copyright © 2020 Ashish. All rights reserved.
//

import UIKit
import Kingfisher

class NewsTableCell: UITableViewCell {

    //Properties
    @IBOutlet var newsImageView: UIImageView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    
    let homeViewModel = HomeControllerViewModel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        newsImageView.image = nil
        titleLabel.text = ""
        authorLabel.text = ""
    }
    
    //MARK :- Set data on tableview cells
    var news: NewsModel? {
        didSet {
            if let title = news?.title {
                titleLabel.text = title
            }
            
            if let author = news?.author {
                authorLabel.text = "Author - \(author)"
            }
            
            if let urlToImage = news?.urlToImage {
                //newsImageView.downloaded(from: urlToImage, contentMode: .scaleToFill)

                if let url = URL(string: urlToImage) {
                    self.newsImageView.kf.indicatorType = .activity
                    self.newsImageView.kf.setImage(with: url, placeholder: UIImage(),
                                                 options: [.cacheOriginalImage])
                }
            }
        }
    }
}
