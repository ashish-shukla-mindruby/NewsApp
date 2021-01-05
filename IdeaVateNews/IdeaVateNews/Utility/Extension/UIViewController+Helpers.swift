//
//  UIViewController+Helpers.swift
//  IdeaVateNews
//
//  Created by Ashish Shukla on 04/01/21.
//  Copyright © 2021 Ashish. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import SafariServices

extension UIViewController {
    
    /**
     *  Height of status bar + navigation bar (if navigation bar exist)
     */

    var topBarHeight: CGFloat {
        return (UIApplication.shared.statusBarFrame.height) +
            (navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    /**
     *  Height of tabBar (if tab bar exist)
     */

    var bottomBarHeight: CGFloat {
        return tabBarController?.tabBar.frame.height ?? 0.0
    }
    
    /// StoryboardID defined in the Storyboard Identity Inspector.
    /// Note: This MUST be set as the ViewController class name or a fatalError will occur.
    static var storyboardID: String {
        return "\(self)"
    }
    
    // MARK: - Error alerts -
    
    func showMessage(withTitle title: String,
                     message: String,
                     cancelTitle: String = "OK",
                     cancelActionHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert  = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: cancelTitle, style: .default, handler: cancelActionHandler)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showError(message: String,
                   actionTitle: String,
                   cancelTitle: String = "Cancel",
                   actionHandler: ((UIAlertAction) -> Void)?) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .default)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: actionHandler)
        alert.addAction(cancelAction)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func showAlert(withTitle title: String? = appname,
                   message: String,
                   cancelActionTitle: String? = "OK",
                   confirmationActionTitle : String? = nil,
                   actionHandler: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let cancelActionTitle = cancelActionTitle {
            let cancelAction = UIAlertAction(title: cancelActionTitle, style: .default)
            alert.addAction(cancelAction)
        }
        if let confirmationActionTitle = confirmationActionTitle,
            let confirmationActionHandler = actionHandler {
            let confirmationAction = UIAlertAction(title: confirmationActionTitle, style: .default, handler: confirmationActionHandler)
            alert.addAction(confirmationAction)
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Keyboard setup -
    
    func setupKeyboardDismiss() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // MARK: - Child view Methods
    
    func add(asChildViewController viewController: UIViewController, inView containerView: UIView?) {
        // Add Child View Controller
        addChild(viewController)
        
        var bounds = view.bounds
        
        // Add Child View as Subview
        if let containerView = containerView {
            bounds = containerView.bounds
            containerView.addSubview(viewController.view)
        } else {
            view.addSubview(viewController.view)
        }
        
        // Configure Child View
        viewController.view.frame = bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
    }
    
    func remove(asChildViewController viewController: UIViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    // MARK: - Navigation -
    
    ///Removes uncosistent delay when presenting `UINavigationController` from `didSelectRowAt`
    ///See http://openradar.appspot.com/19563577
    func transitionSegue(withIdentifier identifier: String, sender: Any?) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: identifier, sender: sender)
        }
    }
    
    ///Removes uncosistent delay when presenting `UINavigationController` from `didSelectRowAt`
    ///See http://openradar.appspot.com/19563577
    func transition(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.present(viewController, animated: animated, completion: completion)
        }
    }
    
    func openURLInApp(url: URL) {
        if url.absoluteString.starts(with: "mailto") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            return
        }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
    }
    
    // MARK: - Notifications setup -
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options:[.alert, .badge, .sound]) { (success, error) in
        }
    }
}

extension UIViewController {
    var top: UIViewController? {
        if let controller = self as? UINavigationController {
            return controller.topViewController?.top
        }
        if let controller = self as? UISplitViewController {
            return controller.viewControllers.last?.top
        }
        if let controller = self as? UITabBarController {
            return controller.selectedViewController?.top
        }
        if let controller = presentedViewController {
            return controller.top
        }
        return self
    }
}
