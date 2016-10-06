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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let savedAccount = userDefaults.object(forKey: "savedAccount") as? Bool ?? false
        if savedAccount {
            if let userLogin = userDefaults.object(forKey: "userLogin") as? String ,
               let userPassword = userDefaults.object(forKey: "userPassword") as? String {
                self.userLogin = userLogin
                self.userPassword = userPassword
                self.saveState = true
                self.loginState = .UserLogin
            }else {
                self.logoutAction()
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func doneAction(_ sender: AnyObject) {
        
        if !self.checkLoginAndPass() {
           return
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        JenkinsAPI.sharedInstance.fetchJobs(callback: { (jobs,error) in
            print(jobs)
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                if error != nil {
                    return
                }
                
                
            }
            
        })
    }
    
    func checkLoginAndPass() -> Bool {
        if !self.userLogin.isEmpty && !self.userPassword.isEmpty {
            if self.saveState {
                userDefaults.set(true, forKey: "savedAccount")
                userDefaults.set(self.userLogin,forKey: "userLogin")
                userDefaults.set(self.userPassword,forKey: "userPassword")
            } else {
                self.logoutAction()
            }
            return true
        }
        return false
    }
    
    func switchSaveState(state: Bool) {
        self.saveState = state
    }
    
    func logoutAction() {
        if self.loginState == .UserLogin {
            userDefaults.set(false, forKey: "savedAccount")
            userDefaults.removeObject(forKey: "userLogin")
            userDefaults.removeObject(forKey: "userPassword")
            self.loginState = .UserLogout
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
            cell.loginTextField.tag = 1
            return cell
        case (0, 1) :
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserLoginTVC", for: indexPath) as! UserLoginTVC
            cell.loginLabel.text = "Password:"
            cell.loginTextField.isSecureTextEntry = true
            cell.loginTextField.text = self.userPassword
            cell.loginTextField.delegate = self
            cell.loginTextField.tag = 2
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
            cell.logButton.setTitleColor(UIColor.red, for: .normal)
            cell.buttonAction = {
                self.logoutAction()
                self.tableView.reloadData()
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension LoginVC : UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        switch(textField.tag) {
        case 1 :
            self.userLogin = textField.text ?? ""
        case 2 :
            self.userPassword = textField.text ?? ""
        default :
            return
        }
    }
}

