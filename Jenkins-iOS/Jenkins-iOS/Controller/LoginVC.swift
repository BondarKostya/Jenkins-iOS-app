//
//  ViewController.swift
//  Jenkins-iOS
//
//  Created by mini on 10/5/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit
import MBProgressHUD

class LoginVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func logAction() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        JenkinsAPI.sharedInstance.fetchJobs(callback: { (jobs) in
            print(jobs)
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
        })
    }

}

extension LoginVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
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
            cell.loginLabel.text = "User"
            cell.loginTextField.text = ""
            return cell
        case (0, 1) :
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserLoginTVC", for: indexPath) as! UserLoginTVC
            cell.loginLabel.text = "User"
            cell.loginTextField.text = ""
            return cell
        case (1, 0) :
            let cell = tableView.dequeueReusableCell(withIdentifier: "SaveAccountTVC", for: indexPath) as! SaveAccountTVC
            cell.saveSwitch.setOn(false, animated: false)
            return cell
        case (2, 0) :
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogButtonTVC", for: indexPath) as! LogButtonTVC
            cell.logButton.setTitle("Log out", for: .normal)
            cell.logButton.setTitleColor(UIColor.red, for: .normal)
            cell.buttonAction = {
                self.logAction()
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
}

