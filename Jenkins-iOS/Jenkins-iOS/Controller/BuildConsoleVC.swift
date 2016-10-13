//
//  BuildConsoleVC.swift
//  Jenkins-iOS
//
//  Created by mini on 10/12/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit
import MBProgressHUD


class BuildConsoleVC: UIViewController {
    @IBOutlet weak var consoleTextView: UITextView!
    
    var build: Build?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadConsoleText()
    }
    
    func loadConsoleText() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        JenkinsAPI.sharedInstance.fetchConsoleOutput(withBuildURL: (build?.url)!) {[weak weakSelf = self] (consoleOutput, error) in
            DispatchQueue.main.async {
                guard let strongSelf = weakSelf else {
                    return
                }
                MBProgressHUD.hide(for: strongSelf.view, animated: true)
                if let error = error {
                    AlertManager.showError(inVC: strongSelf, error.localizedDescription)
                    return
                }
                strongSelf.consoleTextView.text = consoleOutput
            }
        }
    }
}
