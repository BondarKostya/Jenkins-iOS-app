//
//  JobDetailsVC.swift
//  Jenkins-iOS
//
//  Created by mini on 10/11/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit

class JobDetailsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var job:Job?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }


}

extension JobDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        }
        return job?.builds.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section) {
            let buildWithParams = UITableViewCell(style: .default, reuseIdentifier: nil)
            buildWithParams.accessoryType = .disclosureIndicator
            buildWithParams.textLabel.text = "Build with parameters"
            return buildWithParams
        }
        return UITableViewCell()
    }
}
