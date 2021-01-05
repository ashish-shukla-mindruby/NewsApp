//
//  SignUpViewController.swift
//  IdeaVateNews
//
//  Created by Ashish Shukla on 04/01/21.
//  Copyright © 2021 Ashish. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    //Variables
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    
    @IBOutlet var signUpButton: UIButton!
    
    var firebaseAPIHelper = FirebaseAuthModel.sharedInstance
    
    //Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        Utilities.applyBorderToButton(button: signUpButton)
    }
    
    //Button Actions
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        if NetworkConnectivityManager.sharedInstance.reachability.connection == .unavailable {
            self.showAlert(message: APPConstant.Alert.noInternet)
        } else {
            signUpButtonClicked()
        }
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - Private Helpers

extension SignUpViewController {
    fileprivate func validateEmail() -> Bool {
        let username = emailTextField.text?.stringWithoutBlank() ?? ""
        if username.isEmpty {
            emailTextField.becomeFirstResponder()
            self.showAlert(message: APPConstant.Alert.requiredEmail)
            return false
        }
        
        if username.isValidEmail == false {
            emailTextField.becomeFirstResponder()
            self.showAlert(message: APPConstant.Alert.validEmail)
            return false
        }
        return true
    }
    
    fileprivate func validatePassword() -> Bool {
        if let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text {
            if password.stringWithoutBlank().count == 0 {
                passwordTextField.becomeFirstResponder()
                self.showAlert(message: APPConstant.Alert.requiredPassword)
                return false
            }
            
            if confirmPassword.stringWithoutBlank().count == 0 {
                confirmPasswordTextField.becomeFirstResponder()
                self.showAlert(message: APPConstant.Alert.requiredPassword)
                return false
            }
            
            let minPasswordLength = 6
            if password.count < minPasswordLength {
                passwordTextField.becomeFirstResponder()
                self.showAlert(message: APPConstant.Alert.validPassword)
                return false
            }
            
            if password != confirmPassword {
                self.showAlert(message: APPConstant.Alert.matchConfirmPassword)
                return false
            }
        }
        return true
    }
    
    fileprivate func validateFields() -> Bool {
        return validateEmail() && validatePassword()
    }
    
    fileprivate func signUpButtonClicked() {
        guard validateFields() == true,
            let email = emailTextField.text?.stringWithoutBlank(),
            let password = passwordTextField.text?.stringWithoutBlank() else {
                return
        }
        view.endEditing(true)
        callSignUpAPI(email: email, password: password)
    }
    
    fileprivate func callSignUpAPI(email: String, password: String) {
        print(email, password)
        Utilities.showProgress()
        firebaseAPIHelper.signUp(withEmail: email, andPassword: password) { (result) in
            let (message, status) = result
            print(message, status)
            Utilities.hideProgress()
            if status == false {
                self.showAlert(message: message)
            } else {
                CurrentUser.setLoggedOut(false)
                CurrentUser.setEmail(email)
                CurrentUser.setPassword(password)
                if let setMainVC = Storyboard.home.viewController(viewControllerClass: HomeNavigationController.self) {
                    self.present(setMainVC, animated: true, completion: nil)
                }
            }
        }
    }
}

// MARK: - Textfield Delegates

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField, validateEmail() {
            passwordTextField.becomeFirstResponder()
        } else {
            signUpButtonClicked()
        }
        return true
    }
}
