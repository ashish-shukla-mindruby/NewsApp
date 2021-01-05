//
//  FirebaseAuthModel.swift
//  IdeaVateNews
//
//  Created by Ashish Shukla on 04/01/21.
//  Copyright © 2021 Ashish. All rights reserved.
//

import UIKit
import Firebase

class FirebaseAuthModel: NSObject {

    static let sharedInstance = FirebaseAuthModel()
    
    func signIn(withEmail: String, andPassword: String,_ completion: @escaping (_ success: (String, Bool)) -> Void) {
        Auth.auth().signIn(withEmail: withEmail, password: andPassword) { (authResult, error) in
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed:
                    // Error: Indicates that email and password accounts are not enabled. Enable them in the Auth section of the Firebase console.
                    completion(("Indicates that email and password accounts are not enabled. Enable them in the Auth section of the Firebase console.", false))
                    break
                case .userDisabled:
                    // Error: The user account has been disabled by an administrator.
                    completion(("The user account has been disabled by an administrator.", false))
                    break
                case .wrongPassword:
                    // Error: The password is invalid or the user does not have a password.
                    completion(("The password is invalid or the user does not have a password.", false))
                    break
                case .invalidEmail:
                    // Error: Indicates the email address is malformed.
                    completion(("Indicates the email address is malformed.", false))
                    break
                default:
                    print("Error: \(error.localizedDescription)")
                    completion(("Error: \(error.localizedDescription)", false))
                }
            } else {
                print("User signs in successfully")
                let userInfo = Auth.auth().currentUser
                if let user = userInfo {
                  let uid = user.uid
                  let email = user.email
                  let photoURL = user.photoURL
                  var multiFactorString = "MultiFactor: "
                  for info in user.multiFactor.enrolledFactors {
                    multiFactorString += info.displayName ?? "[DispayName]"
                    multiFactorString += " "
                  }
                  print(uid, email ?? "", photoURL ?? "", multiFactorString)
                }
                completion(("User sign in successfully", true))
            }
        }
    }
    
    func signUp(withEmail: String, andPassword: String,_ completion: @escaping (_ success: (String, Bool)) -> Void) {
        Auth.auth().createUser(withEmail: withEmail, password: andPassword) { authResult, error in
            if let error = error as NSError? {
                switch AuthErrorCode(rawValue: error.code) {
                case .operationNotAllowed:
                    // Error: The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.
                    completion(("The given sign-in provider is disabled for this Firebase project. Enable it in the Firebase console, under the sign-in method tab of the Auth section.", false))
                    break
                case .emailAlreadyInUse:
                    // Error: The email address is already in use by another account.
                    completion(("The email address is already in use by another account.", false))
                    break
                case .invalidEmail:
                    // Error: The email address is badly formatted.
                    completion(("The email address is badly formatted.", false))
                    break
                case .weakPassword:
                    // Error: The password must be 6 characters long or more.
                    completion(("The password must be 6 characters long or more.", false))
                    break
                default:
                    print("Error: \(error.localizedDescription)")
                    completion(("Error: \(error.localizedDescription)", false))
                }
            } else {
                print("User signs up successfully")
                let newUserInfo = Auth.auth().currentUser
                if let user = newUserInfo {
                  let uid = user.uid
                  let email = user.email
                  let photoURL = user.photoURL
                  var multiFactorString = "MultiFactor: "
                  for info in user.multiFactor.enrolledFactors {
                    multiFactorString += info.displayName ?? "[DispayName]"
                    multiFactorString += " "
                  }
                  print(uid, email ?? "", photoURL ?? "", multiFactorString)
                }
                completion(("User sign in successfully", true))
            }
        }
    }
}
