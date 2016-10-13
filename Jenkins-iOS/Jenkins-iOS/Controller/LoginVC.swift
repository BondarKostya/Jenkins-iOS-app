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
    
    var userLogin = ""
    var userPassword = ""
    var saveState = false
    
    @IBOutlet weak var tableView: UITableView!
    
    var userLoginTF:UITextField?
    var userPasswordTF:UITextField?
    var logoutButton:UIButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginVC.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        self.doneButton.isEnabled = false
        let savedAccount = userDefaults.object(forKey: "savedAccount") as? Bool ?? false
        if savedAccount {
            if let userLogin = userDefaults.object(forKey: "userLogin") as? String ,
               let userPassword = userDefaults.object(forKey: "userPassword") as? String {
                self.userLogin = userLogin
                self.userPassword = userPassword
                self.saveState = true
                self.loginState = .UserLogin
                self.doneButton.isEnabled = true
            }else {
                self.clearSavedAccount()
            }
        }
    }

    @IBAction func doneAction(_ sender: AnyObject) {
        
        if !self.checkLoginAndPass() {
           return
        }
        
        self.saveAccount()
        self.doneButton.isEnabled = false
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        JenkinsAPI.sharedInstance.loginRequest(login: self.userLogin, password: self.userPassword) {[weak weakSelf = self] (response, error) in
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
                    strongSelf.tableView.reloadData()
                    
                }else {
                    if let error = error {
                      AlertManager.showError(inVC: strongSelf, error.localizedDescription)
                    }
                    strongSelf.loginState = .UserLogout
                }
            }
            
        }
    }
    
    func checkLoginAndPass() -> Bool {
        if !self.userLogin.isEmpty && !self.userPassword.isEmpty {
            return true
        }
        return false
    }
    
    func saveAccount() {
        if self.saveState {
            userDefaults.set(true, forKey: "savedAccount")
            userDefaults.set(self.userLogin,forKey: "userLogin")
            userDefaults.set(self.userPassword,forKey: "userPassword")
        } else {
            self.clearSavedAccount()
        }
    }
    
    func switchSaveState(state: Bool) {
        self.saveState = state
    }
    
    func clearSavedAccount() {
        if self.loginState == .UserLogin {
            userDefaults.set(false, forKey: "savedAccount")
            userDefaults.removeObject(forKey: "userLogin")
            userDefaults.removeObject(forKey: "userPassword")
        }
    }

}

extension LoginVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0 : return 2
        case 1 : return 1
        case 2 : return 1
        default : return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch(indexPath.section,indexPath.row) {
        case (0, 0) :
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserLoginTVC", for: indexPath) as! UserLoginTVC
            cell.loginLabel.text = "User:"
            cell.loginTextField.isSecureTextEntry = false
            cell.loginTextField.text = self.userLogin
            cell.loginTextField.delegate = self
            cell.loginTextField.returnKeyType = .next
            cell.loginTextField.textColor = self.saveState ? UIColor.lightGray : UIColor.black
            self.userLoginTF = cell.loginTextField
            
            return cell
        case (0, 1) :
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserLoginTVC", for: indexPath) as! UserLoginTVC
            cell.loginLabel.text = "Password:"
            cell.loginTextField.isSecureTextEntry = true
            cell.loginTextField.text = self.userPassword
            cell.loginTextField.delegate = self
            cell.loginTextField.returnKeyType = .done
            cell.loginTextField.textColor = self.saveState ? UIColor.lightGray : UIColor.black
            self.userPasswordTF = cell.loginTextField
            
            return cell
        case (1, 0) :
            let cell = tableView.dequeueReusableCell(withIdentifier: "SaveAccountTVC", for: indexPath) as! SaveAccountTVC
            cell.saveSwitch.setOn(self.saveState, animated: false)
            
            cell.switchStateAction = { state in
                self.switchSaveState(state: state)
            }
            return cell
        case (2, 0) :
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogButtonTVC", for: indexPath) as! LogButtonTVC
            cell.logButton.setTitle("Log out", for: .normal)
            cell.logButton.setTitleColor((self.loginState == .UserLogin ? UIColor.red : UIColor.lightGray), for: .normal)
            cell.buttonAction = {
                self.clearSavedAccount()
                self.userLogin = ""
                self.userPassword = ""
                self.doneButton.isEnabled = false
                self.loginState = .UserLogout
                self.tableView.reloadData()
            }
            self.logoutButton = cell.logButton
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension LoginVC : UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.doneButton.isEnabled = false
        self.userLoginTF?.textColor = UIColor.black
        self.userPasswordTF?.textColor = UIColor.black
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch(textField) {
        case self.userLoginTF! :
            self.userLogin = textField.text ?? ""
        case self.userPasswordTF!:
            self.userPassword = textField.text ?? ""
        default :
            return
        }

        self.doneButton.isEnabled = self.checkLoginAndPass() ? true : false
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


