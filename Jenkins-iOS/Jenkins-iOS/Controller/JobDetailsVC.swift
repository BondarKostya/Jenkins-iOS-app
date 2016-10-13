//
//  JobDetailsVC.swift
//  Jenkins-iOS
//
//  Created by mini on 10/11/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit
import MBProgressHUD


class JobDetailsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var job:Job?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = job?.name
        self.tableView.tableFooterView = UIView()
        self.tableView.estimatedRowHeight = 44.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        if(self.job?.builds.count != 0) {
            self.job?.clearBuilds()
        }
        self.loadBuilds()
        
    }
    
    func loadBuilds() {
        guard let job = job else {
            return
        }
        MBProgressHUD.showAdded(to: self.view, animated: true)
        JenkinsAPI.sharedInstance.fetchBuilds(withJob: job.name) { (builds, error) in
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
                if let error = error {
                    AlertManager.showError(inVC: self, error.localizedDescription)
                    return
                }
                self.job?.addBuilds(builds)
                self.tableView.reloadData()
            }
        }
    }

    func rectForText(text: String, font: UIFont, maxSize: CGSize) -> CGSize {
        let attrString = NSAttributedString.init(string: text, attributes: [NSFontAttributeName:font])
        let rect = attrString.boundingRect(with: maxSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        let size = CGSize.init(width: rect.size.width, height: rect.size.height)
        return size
    }

}

extension JobDetailsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {

            return 1
        }
        return job?.builds.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let build = self.job?.builds[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if (indexPath.section == 0) {
            let buildWithParametersVC = storyboard.instantiateViewController(withIdentifier: "BuildWithParametersVC") as! BuildWithParametersVC
            buildWithParametersVC.job = self.job
            
            self.navigationController?.show(buildWithParametersVC, sender: self)
            return
        }
        let buildConsoleVC = storyboard.instantiateViewController(withIdentifier: "BuildConsoleVC") as! BuildConsoleVC
        buildConsoleVC.build = build
        
        self.navigationController?.show(buildConsoleVC, sender: self)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let buildWithParams = UITableViewCell(style: .default, reuseIdentifier: nil)
            buildWithParams.accessoryType = .disclosureIndicator
            buildWithParams.textLabel?.text = "Build with parameters"
            return buildWithParams
        }
        let buildCell = tableView.dequeueReusableCell(withIdentifier: "BuildDetailTVC", for: indexPath) as! BuildDetailTVC
        let build = self.job?.builds[indexPath.row]
        buildCell.setupCell(withBuild: build!)
        buildCell.setNeedsUpdateConstraints()
        buildCell.updateConstraintsIfNeeded()
        return buildCell
    }
}
