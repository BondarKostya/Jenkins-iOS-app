//
//  ProjectsVC.swift
//  Jenkins-iOS
//
//  Created by mini on 10/10/16.
//  Copyright © 2016 bondar.k.dev. All rights reserved.
//

import UIKit
import MBProgressHUD

class ProjectsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var jobs = [Job]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Projects"
        self.tableView.contentInset = UIEdgeInsetsMake(40, 0, 40, 0)
        self.tableView.tableFooterView = UIView()

        self.loadProjects()
    }
    
    func loadProjects() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        JenkinsAPI.sharedInstance.fetchJobs {[weak weakSelf = self] (jobs, error) in
            DispatchQueue.main.async{
                guard let strongSelf = weakSelf else {
                    return
                }
                MBProgressHUD.hide(for: strongSelf.view, animated: true)
                if let error = error {
                    UIAlertController.alert(withError: error.localizedDescription).show(inController: strongSelf)
                    return
                }
                strongSelf.jobs = jobs
                strongSelf.tableView.reloadData()
            }
        }
    }
}

extension ProjectsVC : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.jobs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let projectCell = tableView.dequeueReusableCell(withIdentifier: "ProjectTVC", for: indexPath) as! ProjectTVC
        let job = self.jobs[indexPath.row]
        projectCell.setupCell(withJob: job)
        return projectCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let job = self.jobs[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let jobDetailVC = storyboard.instantiateViewController(withIdentifier: "JobDetailsVC") as! JobDetailsVC
        jobDetailVC.job = job
        
        self.navigationController?.show(jobDetailVC, sender: self)
    }
}
