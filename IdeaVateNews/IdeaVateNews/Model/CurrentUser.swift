//
//  CurrentUser.swift
//  IdeaVateNews
//
//  Created by Ashish Shukla on 04/01/21.
//  Copyright © 2021 Ashish. All rights reserved.
//

import Foundation
import Firebase

public class CurrentUser: NSObject {
    
    struct Keys {
        static let password = "password"
        static let email = "email"
        static let isLoggedOut = "LoggedOut"
        
        static var userDefaults: [String] {
            return [Keys.password, Keys.email, Keys.isLoggedOut]
        }
    }
        
//    public static var isLoggedIn: Bool {
//        return self.email != nil
//            && self.isLoggedOut == false
//    }
    
    public static var isLoggedIn: Bool {
      return Auth.auth().currentUser != nil
    }
    
    static let defaults = UserDefaults.standard
    
    // MARK: - Getters -
    
    public static var email: String? {
        return defaults.string(forKey: Keys.email)
    }
    
    public static var password: String? {
        return defaults.string(forKey: Keys.password)
    }
    
    public static var isLoggedOut: Bool {
        return defaults.bool(forKey: Keys.isLoggedOut)
    }
    
    // MARK: - Setters -
    
    static func setEmail(_ email: String?) {
        guard let email = email, email.isEmpty == false else { return }
        defaults.set(email, forKey: Keys.email)
        defaults.synchronize()
    }
    
    static func setPassword(_ password: String?) {
        guard let password = password else { return }
        defaults.set(password, forKey: Keys.password)
        defaults.synchronize()
    }
    
    static func setLoggedOut(_ isLoggedOut: Bool?) {
        defaults.removeObject(forKey: Keys.isLoggedOut)
        defaults.set(isLoggedOut, forKey: Keys.isLoggedOut)
        defaults.synchronize()
    }
    
    // MARK: - Helper methods -
    
    public static func cleanup() {
        Keys.userDefaults.forEach({ defaults.removeObject(forKey: $0) })
        defaults.synchronize()
    }
}
