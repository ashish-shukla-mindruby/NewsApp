//
//  Utilities.swift
//  IdeaVateNews
//
//  Created by Ashish Shukla on 04/01/21.
//  Copyright © 2021 Ashish. All rights reserved.
//

import Foundation
import SVProgressHUD
import Firebase

struct Utilities {
    
    static func showProgress() {
        SVProgressHUD.setDefaultMaskType(.clear)
        SVProgressHUD.show()
    }
    
    static func hideProgress() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    
    static func applyBorderToButton(button: UIButton) {
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.clipsToBounds = true
    }
    
    static func autoLogOut() {
        do {
            try Auth.auth().signOut()
            CurrentUser.setLoggedOut(true)
            CurrentUser.cleanup()
            CurrentUser.Keys.userDefaults.forEach({ UserDefaults.standard.removePersistentDomain(forName: $0) })
            if let setLoginVC = Storyboard.login.viewController(viewControllerClass: LoginNavigationController.self) {
                UIApplication.shared.windows.first?.rootViewController = setLoginVC
                if let loginVC = Storyboard.login.viewController(viewControllerClass: LoginViewController.self) {
                    setLoginVC.pushViewController(loginVC, animated: false)
                }
            }
        } catch {
            print("Sign out error")
        }
    }
}
