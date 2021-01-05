//
//  HomeViewController.swift
//  IdeaVateNews
//
//  Created by Ashish Shukla on 03/11/20.
//  Copyright © 2020 Ashish. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

    //Properties
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    let homeViewModel = HomeControllerViewModel()
    var newsModel = [NewsModel]()
    
    var refreshControl = UIRefreshControl()
    
    //Class methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Notification observer for internet connection
        NotificationCenter.default
            .addObserver(self,
                         selector: #selector(statusManager),
                         name: .flagsChanged,
                         object: nil)
        
        updateUserInterface()
        
        //Set tableview delegates
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: String(describing: NewsTableCell.self), bundle: nil), forCellReuseIdentifier: String(describing: NewsTableCell.self))
        
        //Add refresh control to table view
        refreshControl.addTarget(self, action: #selector(refreshNewsData), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
    }
    
    @IBAction func logoutButtonAction(_ sender: UIBarButtonItem) {
        if NetworkConnectivityManager.sharedInstance.reachability.connection == .unavailable {
            self.showAlert(message: APPConstant.Alert.noInternet)
        } else {
            self.showAlert(withTitle: "Alert!", message: APPConstant.Alert.logout, cancelActionTitle: "Cancel", confirmationActionTitle: "Ok") { (action) in
                Utilities.autoLogOut()
            }
        }
    }
}

extension HomeViewController {
    fileprivate func updateUserInterface() {
        if NetworkConnectivityManager.sharedInstance.reachability.connection == .unavailable {
            self.fetchNewsFromDB()
        } else {
            self.fetchNewsAPICall()
        }
    }
    
    //MARK :- API Call
    fileprivate func fetchNewsAPICall() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        homeViewModel.getNewsFromAPI({ (newsGroups, error) in
            print(newsGroups as Any, error as Any)
            DispatchQueue.main.async {
                if error != nil {
                    print(error?.localizedDescription as Any)
                    self.fetchNewsFromDB()
                } else {
                    if let news = newsGroups {
                        //Empty news model
                        self.newsModel.removeAll()
                        
                        //Store new data
                        self.newsModel = news
                        
                        //Reload tableview with data in main UI thread
                        self.tableView.reloadData()
                        self.homeViewModel.saveDataInLocalDB(newsModel: self.newsModel)
                    }
                }
                
                self.refreshControl.endRefreshing()
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
                self.activityIndicator.isHidden = true
            }
        })
    }
    
    //MARK :- Fetch from local
    fileprivate func fetchNewsFromDB() {
        DispatchQueue.main.async {
            self.refreshControl.endRefreshing()
            self.homeViewModel.fetchNewsFromDB { (newsGroup) in
                if let news = newsGroup {
                    //Empty news model
                    self.newsModel.removeAll()
                    
                    //Store new data
                    self.newsModel = news
                    
                    //Reload tableview with data in main UI thread
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    //MARK :- Refresh news data
    @objc fileprivate func refreshNewsData() {
        fetchNewsAPICall()
    }
    
    //MARK :- Notification observer
    @objc func statusManager(_ notification: Notification) {
        updateUserInterface()
    }
    
    //MARK :- Open news in detail controller
    fileprivate func openNewsINDetailVC(news: NewsModel) {
        if let detailVC = storyboard?.instantiateViewController(withIdentifier: String(describing: DetailsViewController.self)) as? DetailsViewController {
            detailVC.newsModel = news
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

//MARK :- tableview delegate methods
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NewsTableCell.self), for: indexPath) as! NewsTableCell
        
        cell.news = newsModel[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.openNewsINDetailVC(news: newsModel[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
