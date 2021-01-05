//
//  Storyboards.swift
//  IdeaVateNews
//
//  Created by Ashish Shukla on 04/01/21.
//  Copyright © 2021 Ashish. All rights reserved.
//

import Foundation
import UIKit

enum Storyboard: String {
    case login
    case home

    var instance: UIStoryboard {
        return UIStoryboard(name: self.name, bundle: Bundle.main)
    }
    
    var initialViewController: UIViewController? {
        return instance.instantiateInitialViewController()
    }
    
    private var name: String {
        return rawValue.prefix(1).uppercased() + rawValue.dropFirst()
    }

    func viewController<T: UIViewController>(viewControllerClass: T.Type) -> T? {
        let storyboardID = (viewControllerClass as UIViewController.Type).storyboardID
        return instance.instantiateViewController(withIdentifier: storyboardID) as? T
    }
}
