//
//  ViewController.swift
//  Jenkins-iOS
//
//  Created by mini on 10/5/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit
import MBProgressHUD

enum LoginState {
    case UserLogin
    case UserLogout
}

class LoginVC: UIViewController {

    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var loginState = LoginState.UserLogout
    
    let userDefaults = UserDefaults.standard

    
    @IBOutlet weak var userLoginTF: UITextField!
    @IBOutlet weak var userPasswordTF: UITextField!
    @IBOutlet weak var saveAccountSwitch: UISwitch!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.doneButton.isEnabled = false
        let savedAccount = userDefaults.object(forKey: "savedAccount") as? Bool ?? false
        if savedAccount {
            if let userLogin = userDefaults.object(forKey: "userLogin") as? String ,
               let userPassword = userDefaults.object(forKey: "userPassword") as? String {
                self.userLoginTF.text = userLogin
                self.userPasswordTF.text = userPassword
                self.saveAccountSwitch.isOn = true
                
                self.loginState = .UserLogin
                self.doneButton.isEnabled = true
                
                self.changeTextFieldsColor(isGray: true)
                self.logoutButton.setTitleColor(UIColor.red, for: .normal)
            }else {
                self.clearSavedAccount()
                self.changeTextFieldsColor(isGray: false)
                self.logoutButton.setTitleColor(UIColor.lightGray, for: .normal)
            }
        }
    }

    @IBAction func textChanged(_ sender: UITextField) {
        if self.userLoginTF.text!.isEmpty || self.userPasswordTF.text!.isEmpty {
            self.doneButton.isEnabled = false
        } else {
            self.doneButton.isEnabled = true
        }
    }
    func changeTextFieldsColor(isGray: Bool) {
        self.userLoginTF.textColor = isGray ? UIColor.lightGray : UIColor.black
        self.userPasswordTF.textColor = isGray ? UIColor.lightGray : UIColor.black
    }
    
    @IBAction func doneAction(_ sender: AnyObject) {
        
        self.view.endEditing(true)
        self.saveAccount()
        self.doneButton.isEnabled = false
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        JenkinsAPI.sharedInstance.loginRequest(login: self.userLoginTF.text ?? "", password: self.userPasswordTF.text ?? "") {[weak weakSelf = self] (response, error) in
            DispatchQueue.main.async {
                guard let strongSelf = weakSelf else {
                    return
                }
                strongSelf.doneButton.isEnabled = true
                
                MBProgressHUD.hide(for: strongSelf.view, animated: true)
                if(response) {
                    strongSelf.loginState = .UserLogin
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let projectsVC = storyboard.instantiateViewController(withIdentifier: "ProjectsVC") as! ProjectsVC
                    strongSelf.navigationController?.pushViewController(projectsVC, animated: true)
                    strongSelf.changeTextFieldsColor(isGray: true)
                    self.logoutButton.setTitleColor(UIColor.red, for: .normal)
                }else {
                    if let error = error {
                        UIAlertController.alert(withError: error.localizedDescription).show(inController: strongSelf)
                    }
                    strongSelf.loginState = .UserLogout
                    self.logoutButton.setTitleColor(UIColor.lightGray, for: .normal)
                }
            }
            
        }
    }
    @IBAction func logoutAction(_ sender: UIButton) {
        if self.loginState == .UserLogin {
            self.logoutButton.setTitleColor(UIColor.lightGray, for: .normal)
            self.clearSavedAccount()
            self.userPasswordTF.text = ""
            self.userLoginTF.text = ""
            self.doneButton.isEnabled = false
        }
    }
    
    func saveAccount() {
        if self.saveAccountSwitch.isOn {
            userDefaults.set(true, forKey: "savedAccount")
            userDefaults.set(self.userLoginTF.text ?? "",forKey: "userLogin")
            userDefaults.set(self.userPasswordTF.text ?? "",forKey: "userPassword")
        } else {
            self.clearSavedAccount()
        }
    }
    
    func clearSavedAccount() {
        if self.loginState == .UserLogin {
            userDefaults.set(false, forKey: "savedAccount")
            userDefaults.removeObject(forKey: "userLogin")
            userDefaults.removeObject(forKey: "userPassword")
        }
    }
    func dismissKeyboard() {
        view.endEditing(true)
    }

}


extension LoginVC : UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.userLoginTF.textColor = UIColor.black
        self.userPasswordTF.textColor = UIColor.black
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == self.userLoginTF) {
            textField.resignFirstResponder()
            self.userPasswordTF?.becomeFirstResponder()
        }else {
           textField.resignFirstResponder() 
        }
        return true
    }
}


